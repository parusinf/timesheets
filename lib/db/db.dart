import 'dart:io';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:timesheets/core/tools.dart';
import 'schedule_helper.dart';

part 'db.g.dart';

/// Представление организации
class OrgView extends Org {
  final int groupCount; // количество групп в организации

  OrgView({
    @required int id,
    @required String name,
    String inn,
    int activeGroupId,
    this.groupCount = 0,
  }) : super(
    id: id,
    name: name,
    inn: inn,
    activeGroupId: activeGroupId,
  );
}

/// Представление графика
class ScheduleView extends Schedule {
  final int groupCount; // количество групп, ссылающихся на график

  ScheduleView({
    @required int id,
    @required String code,
    this.groupCount = 0,
  }) : super(
    id: id,
    code: code,
  );
}

/// Представление персоны
class PersonView extends Person {
  final int groupCount;   // количество групп персоны

  PersonView({
    @required int id,
    @required String family,
    @required String name,
    String middleName,
    DateTime birthday,
    String phone,
    String phone2,
    this.groupCount = 0,
  }) : super(
    id: id,
    family: family,
    name: name,
    middleName: middleName,
    birthday: birthday,
    phone: phone,
    phone2: phone2,
  );
}

/// Представление группы
class GroupView extends Group {
  final Schedule schedule; // график
  final int personCount;   // количество персон в группе

  GroupView({
    @required int id,
    @required int orgId,
    @required String name,
    @required this.schedule,
    int meals,
    this.personCount = 0,
  }) : super(
    id: id,
    orgId: orgId,
    name: name,
    scheduleId: schedule.id,
    meals: meals,
  );
}

/// Персона группы
class GroupPersonView extends GroupPerson {
  final Person person;
  final int attendanceCount;

  GroupPersonView({
    @required int id,
    @required int groupId,
    @required this.person,
    DateTime beginDate,
    DateTime endDate,
    this.attendanceCount = 0,
  }) : super(
    id: id,
    groupId: groupId,
    personId: person.id,
    beginDate: beginDate,
    endDate: endDate,
  );
}

/// Группа и период
class GroupPeriod {
  Group group;
  DateTime period;
  GroupPeriod(this.group, this.period);
}

/// База данных
@UseMoor(
  include: {'model.moor'},
  tables: [
    Orgs,             // Организации
    Schedules,        // Графики
    ScheduleDays,     // Дни графиков
    Groups,           // Группы
    Persons,          // Персоны
    GroupPersons,     // Персоны в группе
    Attendances,      // Табели
    Settings,         // Настройки
  ],
  daos: [
    OrgsDao,
    SchedulesDao,
    ScheduleDaysDao,
    GroupsDao,
    PersonsDao,
    GroupPersonsDao,
    AttendancesDao,
    SettingsDao
  ]
)
class Db extends _$Db {
  /// Асинхронная база данных
  Db() : super(_openConnection());

  /// При модернизации модели нужно увеличить версию схемы и прописать миграцию
  @override
  int get schemaVersion => 2;

  /// Формирование графика и группы по умолчанию
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      if (from == 1) {
        await m.addColumn(groups, groups.meals);
        await m.addColumn(persons, persons.phone);
        await m.addColumn(persons, persons.phone2);
      }
    },
    onCreate: (Migrator m) {
      return m.createAll();
    },
    beforeOpen: (details) async {
      customStatement('PRAGMA foreign_keys = ON');
      if (details.wasCreated) {
        transaction(() async {
          settingsDao.setActivePeriod(lastDayOfMonth(DateTime.now()));
        });
      }
    }
  );
}

/// Помещает файл базы данных в каталог документов приложения
LazyDatabase _openConnection() => LazyDatabase(() async {
  final dbFolder = await getApplicationDocumentsDirectory();
  final file = File(p.join(dbFolder.path, 'db.sqlite'));
  return VmDatabase(file);
});

// Организации -----------------------------------------------------------------
@UseDao(tables: [Orgs])
class OrgsDao extends DatabaseAccessor<Db> with _$OrgsDaoMixin {
  OrgsDao(Db db) : super(db);

  /// Добавление организации
  Future<Org> insert2({
    @required String name,
    String inn,
  }) async {
    final id = await into(db.orgs).insert(
        OrgsCompanion(
          name: Value(name),
          inn: Value(inn),
        )
    );
    return Org(
      id: id,
      name: name,
      inn: inn,
    );
  }

  /// Исправление организации
  Future<bool> update2(Org org) async => await update(db.orgs).replace(org);

  /// Удаление организации
  Future<bool> delete2(Org org) async =>
      (await delete(db.orgs).delete(org)) > 0 ? true : false;

  /// Отслеживание организаций
  Stream<List<OrgView>> watch() =>
      db._orgsView().map((row) =>
          OrgView(
            id: row.id,
            name: row.name,
            inn: row.inn,
            activeGroupId: row.activeGroupId,
            groupCount: row.groupCount,
          )
      ).watch();

  /// Предыдущая организация перед заданной
  Future<Org> getPreviousOrg(Org org) async =>
    await db._previousOrg(org.name).map((row) =>
        Org(
          id: row.id,
          name: row.name,
          inn: row.inn,
          activeGroupId: row.activeGroupId,
        )
    ).getSingle() ?? _getFirstOrg();

  /// Первая организация в алфавитном порядке
  Future<Org> _getFirstOrg() async =>
      await db._firstOrg().map((row) =>
          Org(
            id: row.id,
            name: row.name,
            inn: row.inn,
            activeGroupId: row.activeGroupId,
          )
      ).getSingle();
}

// Графики ---------------------------------------------------------------------
@UseDao(tables: [Schedules])
class SchedulesDao extends DatabaseAccessor<Db> with _$SchedulesDaoMixin {
  SchedulesDao(Db db) : super(db);

  /// Добавление графика
  Future<Schedule> insert2({
    @required String code,
    bool createDays = false,
  }) async {
    final id = await into(db.schedules).insert(
        SchedulesCompanion(code: Value(code)));
    final schedule = Schedule(id: id, code: code);
    if (createDays) {
      final hoursByDays = parseScheduleCode(code);
      for (int dayNumber = 0; dayNumber < hoursByDays.length; dayNumber++) {
        db.scheduleDaysDao.insert2(
          schedule: schedule,
          dayNumber: dayNumber,
          hoursNorm: hoursByDays[dayNumber],
        );
      }
    }
    return schedule;
  }

  /// Исправление графика
  Future<bool> update2(Schedule schedule) async =>
      await update(db.schedules).replace(schedule);

  /// Удаление графика
  Future<bool> delete2(Schedule schedule) async =>
      (await delete(db.schedules).delete(schedule)) > 0 ? true : false;

  /// Отслеживание графиков
  Stream<List<ScheduleView>> watch() =>
      db._schedulesView().map((row) =>
          ScheduleView(
            id: row.id,
            code: row.code,
            groupCount: row.groupCount,
          )
      ).watch();

  /// Предыдущий график перед заданным
  Future<Schedule> getPreviousSchedule(Schedule schedule) async =>
      await db._previousSchedule(schedule.code).map((row) =>
          Schedule(
            id: row.id,
            code: row.code,
          )
      ).getSingle() ?? _getFirstSchedule();

  /// Первая организация в алфавитном порядке
  Future<Schedule> _getFirstSchedule() async =>
      await db._firstSchedule().map((row) =>
          Schedule(
            id: row.id,
            code: row.code,
          )
      ).getSingle();

  /// Получение графика
  Future<Schedule> getSchedule(int id) async =>
      await (select(db.schedules)..where((schedule) => schedule.id?.equals(id))).getSingle();
}

// Дни графиков ----------------------------------------------------------------
@UseDao(tables: [ScheduleDays])
class ScheduleDaysDao extends DatabaseAccessor<Db> with _$ScheduleDaysDaoMixin {
  ScheduleDaysDao(Db db) : super(db);

  /// Добавление дня графика
  Future<ScheduleDay> insert2({
    @required Schedule schedule,
    @required int dayNumber,
    @required double hoursNorm,
  }) async {
    final id = await into(db.scheduleDays).insert(
        ScheduleDaysCompanion(
          scheduleId: Value(schedule.id),
          dayNumber: Value(dayNumber),
          hoursNorm: Value(hoursNorm),
        )
    );
    return ScheduleDay(
      id: id,
      scheduleId: schedule.id,
      dayNumber: dayNumber,
      hoursNorm: hoursNorm,
    );
  }

  /// Исправление дня графика
  Future<bool> update2(ScheduleDay scheduleDay) async =>
      await update(db.scheduleDays).replace(scheduleDay);

  /// Удаление дня графика
  Future<bool> delete2(ScheduleDay scheduleDay) async =>
    (await delete(db.scheduleDays).delete(scheduleDay)) > 0 ? true : false;

  // Отслеживание дней графика
  Stream<List<ScheduleDay>> watch(Schedule schedule) =>
      db._daysInSchedule(schedule?.id).map((row) =>
          ScheduleDay(
              id: row.id,
              scheduleId: row.scheduleId,
              dayNumber: row.dayNumber,
              hoursNorm: row.hoursNorm
          )
      ).watch();
}

// Группы ----------------------------------------------------------------------
@UseDao(tables: [Groups])
class GroupsDao extends DatabaseAccessor<Db> with _$GroupsDaoMixin {
  GroupsDao(Db db) : super(db);
  
  /// Добавление группы
  Future<GroupView> insert2({
    @required Org org,
    @required String name,
    @required Schedule schedule,
    int meals,
  }) async {
    final id = await into(db.groups).insert(
        GroupsCompanion(
          orgId: Value(org.id),
          name: Value(name),
          scheduleId: Value(schedule.id),
          meals: Value(meals),
        )
    );
    return GroupView(
      id: id,
      orgId: org.id,
      name: name,
      schedule: schedule,
      meals: meals,
    );
  }

  /// Исправление группы
  Future<bool> update2(Group group) async =>
      await update(db.groups).replace(group);

  /// Удаление группы
  Future<bool> delete2(Group group) async =>
      (await delete(db.groups).delete(group)) > 0 ? true : false;

  /// Отслеживание групп организации
  Stream<List<GroupView>> watch(Org org) =>
      db._groupsView(org?.id).map((row) =>
          GroupView(
            id: row.id,
            orgId: row.orgId,
            name: row.name,
            schedule: Schedule(id: row.scheduleId, code: row.scheduleCode),
            meals: row.meals,
            personCount: row.personCount,
          )
      ).watch();

  /// Предыдущая группа перед заданной
  Future<Group> getPreviousGroup(Org org, Group group) async =>
    await db._previousGroup(org.id, group.name).map((row) =>
        Group(
          id: row.id,
          orgId: row.orgId,
          name: row.name,
          scheduleId: row.scheduleId,
          meals: row.meals,
        )
    ).getSingle() ?? _getFirstGroup(org);

  /// Первая группа организации в алфавитном порядке
  Future<Group> _getFirstGroup(Org org) async =>
      await db._firstGroup(org.id).map((row) =>
          Group(
            id: row.id,
            orgId: row.orgId,
            name: row.name,
            scheduleId: row.scheduleId,
            meals: row.meals,
          )
      ).getSingle();
}

// Персоны ---------------------------------------------------------------------
@UseDao(tables: [Persons])
class PersonsDao extends DatabaseAccessor<Db> with _$PersonsDaoMixin {
  PersonsDao(Db db) : super(db);

  /// Добавление персоны
  Future<Person> insert2({
    @required String family,
    @required String name,
    String middleName,
    DateTime birthday,
    String phone,
    String phone2,
  }) async {
    final id = await into(db.persons).insert(
        PersonsCompanion(
          family: Value(family),
          name: Value(name),
          middleName: Value(middleName),
          birthday: birthday != null ? Value(birthday) : Value.absent(),
          phone: Value(phone),
          phone2: Value(phone2),
        )
    );
    return Person(
      id: id,
      family: family,
      name: name,
      middleName: middleName,
      birthday: birthday,
      phone: phone,
      phone2: phone2,
    );
  }

  /// Исправление персоны
  Future<bool> update2(Person person) async =>
      await update(db.persons).replace(person);

  /// Удаление персоны
  Future<bool> delete2(Person person) async =>
      (await delete(db.persons).delete(person)) > 0 ? true : false;

  /// Отслеживание персон
  Stream<List<PersonView>> watch() =>
      db._personsView().map((row) =>
          PersonView(
            id: row.id,
            family: row.family,
            name: row.name,
            middleName: row.middleName,
            birthday: row.birthday,
            phone: row.phone,
            phone2: row.phone2,
            groupCount: row.groupCount,
          )
      ).watch();
}

// Персоны в группе -----------------------------------------------------
@UseDao(tables: [GroupPersons])
class GroupPersonsDao extends DatabaseAccessor<Db> with _$GroupPersonsDaoMixin {
  GroupPersonsDao(Db db) : super(db);

  /// Добавление персоны в группу
  Future<GroupPersonView> insert2(Group group, Person person, DateTime beginDate, DateTime endDate) async {
    final id = await into(db.groupPersons).insert(
        GroupPersonsCompanion(
          groupId: Value(group.id),
          personId: Value(person.id),
          beginDate: Value(beginDate),
          endDate: Value(endDate),
        )
    );
    return GroupPersonView(
      id: id,
      groupId: group.id,
      person: person,
      beginDate: beginDate,
      endDate: endDate,
    );
  }

  /// Исправление персоны в группе
  Future<bool> update2(GroupPersonView groupPerson) async =>
      await update(db.groupPersons).replace(groupPerson);

  /// Удаление персоны из группы
  Future<bool> delete2(GroupPersonView groupPerson) async =>
      (await delete(db.groupPersons).delete(
          GroupPersonsCompanion(id: Value(groupPerson.id))
      )) > 0 ? true : false;

  /// Отслеживание персон в группе
  Stream<List<GroupPersonView>> watch(Group group) =>
      db._personsInGroup(group?.id).map((row) => GroupPersonView(
        id: row.id,
        groupId: row.groupId,
        person: Person(
          id: row.personId,
          family: row.family,
          name: row.name,
          middleName: row.middleName,
          birthday: row.birthday,
          phone: row.phone,
          phone2: row.phone2,
        ),
        beginDate: row.beginDate,
        endDate: row.endDate,
        attendanceCount: row.attendanceCount,
      )).watch();

  /// Отслеживание персон в группе за период
  Stream<List<GroupPersonView>> watchGroupPeriod(GroupPeriod groupPeriod) =>
      db._personsInGroupPeriod(
        groupPeriod?.group?.id,
        DateTime(groupPeriod.period.year, groupPeriod.period.month, 1),
        groupPeriod.period,
      ).map((row) => GroupPersonView(
        id: row.id,
        groupId: row.groupId,
        person: Person(
          id: row.personId,
          family: row.family,
          name: row.name,
          middleName: row.middleName,
          birthday: row.birthday,
          phone: row.phone,
          phone2: row.phone2,
        ),
        beginDate: row.beginDate,
        endDate: row.endDate,
        attendanceCount: row.attendanceCount,
      )).watch();
}

// Посещаемость персон в группе ----------------------------------------------
@UseDao(tables: [Attendances])
class AttendancesDao extends DatabaseAccessor<Db> with _$AttendancesDaoMixin {
  AttendancesDao(Db db) : super(db);

  /// Добавление посещаемости
  Future<Attendance> insert2({
    @required GroupPersonView groupPerson,
    @required DateTime date,
    @required double hoursFact,
  }) async {
    final id = await into(db.attendances).insert(
        AttendancesCompanion(
          groupPersonId: Value(groupPerson.id),
          date: Value(date),
          hoursFact: Value(hoursFact),
        )
    );
    return Attendance(
        id: id,
        groupPersonId: groupPerson.id,
        date: date,
        hoursFact: hoursFact
    );
  }

  /// Удаление посещаемости
  Future<bool> delete2(Attendance attendance) async =>
      (await delete(db.attendances).delete(attendance)) > 0 ? true : false;

  /// Получение посещаемости персоны в группе за период
  Stream<List<Attendance>> watch(GroupPeriod groupPeriod) =>
      db._attendancesView(
        groupPeriod.group.id,
        DateTime(groupPeriod.period.year, groupPeriod.period.month, 1),
        groupPeriod.period
      ).map((row) => Attendance(
        id: row.id,
        groupPersonId: row.groupPersonId,
        date: row.date,
        hoursFact: row.hoursFact,
      )).watch();
}

// Настройки -------------------------------------------------------------------
@UseDao(tables: [Settings])
class SettingsDao extends DatabaseAccessor<Db> with _$SettingsDaoMixin {
  SettingsDao(Db db) : super(db);

  /// Добавление настройки
  Future<Setting> insert2(String name, {
    String textValue,
    int intValue,
    DateTime dateValue,
  }) async {
    final id = await into(db.settings).insert(
        SettingsCompanion(
          name: Value(name),
          textValue: Value(textValue),
          intValue: Value(intValue),
          dateValue: Value(dateValue),
        )
    );
    return Setting(
      id: id,
      name: name,
      textValue: textValue,
      intValue: intValue,
      dateValue: dateValue,
    );
  }

  /// Удаление настройки
  void delete2(String settingName) =>
      delete(db.settings).where((row) => row.name.equals(settingName));

  /// Активная организация
  Stream<Org> watchActiveOrg() => db._activeOrg().map((row) =>
      Org(
        id: row.id,
        name: row.name,
        inn: row.inn,
        activeGroupId: row.activeGroupId,
      )
  ).watchSingle();

  /// Установка активной организации
  Future setActiveOrg(Org org) async {
    if (org == null)
      delete2('activeOrg');
    else {
      final count = await db._setActiveOrg(org.id);
      if (count == 0) {
        insert2('activeOrg', intValue: org.id);
      }
    }
  }

  /// Активный график
  Stream<Schedule> watchActiveSchedule() => (db._activeSchedule().map((row) =>
      Schedule(
        id: row.id,
        code: row.code,
      )
  )).watchSingle();

  /// Установка активного графика
  Future setActiveSchedule(Schedule schedule) async {
    if (schedule == null)
      delete2('activeSchedule');
    else {
      final count = await db._setActiveSchedule(schedule.id);
      if (count == 0) {
        insert2('activeSchedule', intValue: schedule.id);
      }
    }
  }

  /// Активная группа
  Stream<GroupView> watchActiveGroup(Org org) =>
      db._activeGroup(org?.id).map((row) =>
          GroupView(
            id: row.id,
            orgId: row.orgId,
            name: row.name,
            schedule: Schedule(id: row.scheduleId, code: row.scheduleCode),
            meals: row.meals,
            personCount: row.personCount,
          )
      ).watchSingle();

  /// Установка активной группы
  Future setActiveGroup(Org org, Group group) async =>
      await db._setActiveGroup(group?.id, org.id);

  // Активный период
  Stream<DateTime> watchActivePeriod() => db._activePeriod().watchSingle();
  Future<DateTime> getActivePeriod() async => await db._activePeriod().getSingle();

  /// Установка активного периода
  Future setActivePeriod(DateTime period) async {
    if (period == null)
      delete2('activePeriod');
    else {
      final count = await db._setActivePeriod(period);
      if (count == 0) {
        insert2('activePeriod', dateValue: period);
      }
    }
  }
}