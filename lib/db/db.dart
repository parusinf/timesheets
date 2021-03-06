import 'dart:io';
import 'package:moor/moor.dart';
import 'package:moor/ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'schedule_helper.dart';
import 'value_type.dart';
import 'upgrade_db.dart';
import 'create_db.dart';

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
    scheduleId: schedule?.id,
    meals: meals,
  );

  GroupView copy({
    int id,
    int orgId,
    String name,
    Schedule schedule,
    int meals
  }) => GroupView(
    id: id ?? this.id,
    orgId: orgId ?? this.orgId,
    name: name ?? this.name,
    schedule: schedule ?? this.schedule,
    meals: meals ?? this.meals,
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
    personId: person?.id,
    beginDate: beginDate,
    endDate: endDate,
  );

  GroupPersonView copy({
    int id,
    int groupId,
    Person person,
    DateTime beginDate,
    DateTime endDate
  }) => GroupPersonView(
    id: id ?? this.id,
    groupId: groupId ?? this.groupId,
    person: person ?? this.person,
    beginDate: beginDate ?? this.beginDate,
    endDate: endDate ?? this.endDate,
  );
}

/// Представление посещаемости
class AttendanceView extends Attendance {
  final int groupId;
  final int meals;

  AttendanceView({
    @required int id,
    @required int groupPersonId,
    @required DateTime date,
    @required double hoursFact,
    @required this.groupId,
    @required this.meals,
  }) : super(
    id: id,
    groupPersonId: groupPersonId,
    date: date,
    hoursFact: hoursFact,
  );
}

/// Группа и период
class GroupPeriod {
  Group group;
  DateTime period;
  GroupPeriod(this.group, this.period);
}

/// Организация и период
class OrgPeriod {
  Org org;
  DateTime period;
  OrgPeriod(this.org, this.period);
}

/// База данных
@UseMoor(
  include: {'model.moor'},
  daos: [
    OrgsDao,
    SchedulesDao,
    ScheduleDaysDao,
    HolidaysDao,
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
  int get schemaVersion => 5;

  /// Обновление структуры базы данных
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) => upgradeDb(this, m, from, to),
    onCreate: (Migrator m) => m.createAll(),
    beforeOpen: (details) async => await _init(details.wasCreated),
  );

  /// Сброс базы данных
  Future<void> reset() async {
    await _deleteEverything();
    return _init(true);
  }

  /// Инициализация базы данных
  Future<void> _init(bool wasCreated) async {
    transaction(() async {
      await customStatement('PRAGMA foreign_keys = ON');
      if (wasCreated) {
        await createDb(this);
      }
    });
  }

  /// Удаление всех таблиц базы данных
  Future<void> _deleteEverything() {
    return transaction(() async {
      await customStatement('PRAGMA foreign_keys = OFF');
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }}

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
      ),
    );
    return Org(
      id: id,
      name: name,
      inn: inn,
    );
  }

  /// Добавление или исправление по списку колонок
  Future<Org> upsert({
    @required String name,
    String inn,
    List<Column> target,
  }) async {
    final orgCompanion = OrgsCompanion(
      name: Value(name),
      inn: Value(inn),
    );
    final id = await into(db.orgs).insert(
      orgCompanion,
      onConflict: DoUpdate((old) => orgCompanion, target: target),
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
  Future<Org> getPrevious(Org org) async {
    try {
      return await db._previousOrg(org.name).map((row) =>
          Org(
            id: row.id,
            name: row.name,
            inn: row.inn,
            activeGroupId: row.activeGroupId,
          )).getSingle();
    } catch(_) {
      return _getFirst();
    }
  }

  /// Первая организация в алфавитном порядке
  Future<Org> _getFirst() async {
    try {
      return await db._firstOrg().map((row) =>
        Org(
          id: row.id,
          name: row.name,
          inn: row.inn,
          activeGroupId: row.activeGroupId,
        )).getSingle();
    } catch(_) {
      return null;
    }
  }

  /// Поиск организации
  Future<Org> find(String name) async {
    try {
      return await (select(db.orgs)
        ..where((e) => e.name.equals(name))).getSingle();
    } catch(_) {
      return null;
    }
  }
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
  getPrevious(Schedule schedule) async {
    try {
      return await db._previousSchedule(schedule.code).map((row) =>
          Schedule(
            id: row.id,
            code: row.code,
          )
      ).getSingle();
    } catch(_) {
      return _getFirst();
    }
  }

  /// Первый график в алфавитном порядке
  _getFirst() async {
    try {
      return await db._firstSchedule().map((row) =>
          Schedule(
            id: row.id,
            code: row.code,
          )
      ).getSingle();
    } catch (_) {
      return null;
    }
  }

  /// Получение графика
  get(int id) async {
    try {
      return await (select(db.schedules)
        ..where((schedule) => schedule?.id?.equals(id))).getSingle();
    } catch(_) {
      return null;
    }
  }

  /// Поиск графика
  find(String code) async {
    try {
      return await (select(db.schedules)
        ..where((schedule) => schedule.code.equals(code))).getSingle();
    } catch(_) {
      return null;
    }
  }
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
          scheduleId: Value(schedule?.id),
          dayNumber: Value(dayNumber),
          hoursNorm: Value(hoursNorm),
        )
    );
    return ScheduleDay(
      id: id,
      scheduleId: schedule?.id,
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

// Праздники -------------------------------------------------------------------
@UseDao(tables: [Holidays])
class HolidaysDao extends DatabaseAccessor<Db> with _$HolidaysDaoMixin {
  HolidaysDao(Db db) : super(db);

  /// Добавление праздника
  Future<Holiday> insert2({
    @required DateTime date,
    DateTime workday,
  }) async {
    final id = await into(db.holidays).insert(
        HolidaysCompanion(
          date: Value(date),
          workday: Value(workday),
        )
    );
    return Holiday(
      id: id,
      date: date,
      workday: workday,
    );
  }

  /// Исправление праздника
  Future<bool> update2(Holiday holiday) async =>
      await update(db.holidays).replace(holiday);

  /// Удаление праздника
  Future<bool> delete2(Holiday holiday) async =>
      (await delete(db.holidays).delete(holiday)) > 0 ? true : false;

  /// Отслеживание праздников
  Stream<List<Holiday>> watch() =>
      (select(db.holidays)
        ..orderBy([(t) => OrderingTerm.asc(t.date)])
      ).watch();

  /// Отслеживание праздничных дней
  Stream<List<DateTime>> watchHolidays() =>
      (select(db.holidays))
          .map((row) => row.date)
          .watch();

  /// Отслеживание рабочих дней
  Stream<List<DateTime>> watchWorkdays() =>
      db._holidaysWorkdays()
          .map((row) => row.workday)
          .watch();
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
        orgId: Value(org?.id),
        name: Value(name),
        scheduleId: Value(schedule?.id),
        meals: Value(meals),
      ),
    );
    return GroupView(
      id: id,
      orgId: org?.id,
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

  /// Отслеживание питаний организации
  Stream<List<GroupView>> watchMeals(Org org) =>
      db._orgMeals(org?.id).map((row) =>
          GroupView(
            id: 0,
            orgId: 0,
            name: null,
            schedule: null,
            meals: row.meals,
            personCount: 0,
          )
      ).watch();

  /// Предыдущая группа перед заданной
  getPrevious(Org org, Group group) async {
    try {
      return await db._previousGroup(org?.id, group.name).map((row) =>
          Group(
            id: row.id,
            orgId: row.orgId,
            name: row.name,
            scheduleId: row.scheduleId,
            meals: row.meals,
          )
      ).getSingle();
    } catch(_) {
      return _getFirst(org);
    }
  }

  /// Первая группа организации в алфавитном порядке
  _getFirst(Org org) async {
    try {
      return await db._firstGroup(org?.id).map((row) =>
          Group(
            id: row.id,
            orgId: row.orgId,
            name: row.name,
            scheduleId: row.scheduleId,
            meals: row.meals,
          )
      ).getSingle();
    } catch(_) {
      return null;
    }
  }

  /// Поиск группы
  find(String name, Org org, Schedule schedule) async {
    try {
      return await (select(db.groups)
        ..where((e) =>
        e.name.equals(name) &
        e.orgId.equals(org?.id) &
        e.scheduleId.equals(schedule?.id)
        )).getSingle();
    } catch(_) {
      return null;
    }
  }
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

  /// Поиск персоны
  Future<Person> find(
    String family,
    String name,
    String middleName,
    DateTime birthday,
  ) async {
    try {
      return await (db._findPerson(family, name, middleName, birthday).map((row) =>
          Person(
            id: row.id,
            family: row.family,
            name: row.name,
            middleName: row.middleName,
            birthday: row.birthday,
            phone: row.phone,
            phone2: row.phone2,
          ))).getSingle();
    } catch(_) {
      return null;
    }
  }
}

// Персоны в группе -----------------------------------------------------
@UseDao(tables: [GroupPersons])
class GroupPersonsDao extends DatabaseAccessor<Db> with _$GroupPersonsDaoMixin {
  GroupPersonsDao(Db db) : super(db);

  /// Добавление персоны в группу
  Future<GroupPerson> insert2(
    Group group,
    Person person,
    DateTime beginDate,
    DateTime endDate
  ) async {
    final id = await into(db.groupPersons).insert(
        GroupPersonsCompanion(
          groupId: Value(group?.id),
          personId: Value(person?.id),
          beginDate: Value(beginDate),
          endDate: Value(endDate),
        )
    );
    return GroupPerson(
      id: id,
      groupId: group?.id,
      personId: person?.id,
      beginDate: beginDate,
      endDate: endDate,
    );
  }

  /// Исправление персоны в группе
  Future<bool> update2(GroupPerson groupPerson) async =>
      await update(db.groupPersons).replace(groupPerson);

  /// Удаление персоны из группы
  Future<bool> delete2(GroupPerson groupPerson) async =>
      (await delete(db.groupPersons).delete(
          GroupPersonsCompanion(id: Value(groupPerson?.id))
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
        groupPeriod?.period != null
            ? DateTime(groupPeriod.period.year, groupPeriod.period.month, 1)
            : null,
        groupPeriod?.period,
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

  /// Поиск персоны в группе
  Future<GroupPerson> find(Group group, Person person) async {
    try {
      return await (select(db.groupPersons)
        ..where((e) =>
        e.groupId.equals(group?.id) &
        e.personId.equals(person?.id)
        )).getSingle();
    } catch(_) {
      return null;
    }
  }
}

// Посещаемость персон в группе ----------------------------------------------
@UseDao(tables: [Attendances])
class AttendancesDao extends DatabaseAccessor<Db> with _$AttendancesDaoMixin {
  AttendancesDao(Db db) : super(db);

  /// Добавление посещаемости
  Future<Attendance> insert2({
    @required GroupPerson groupPerson,
    @required DateTime date,
    @required double hoursFact,
  }) async {
    final id = await into(db.attendances).insert(
      AttendancesCompanion(
        groupPersonId: Value(groupPerson?.id),
        date: Value(date),
        hoursFact: Value(hoursFact),
      ),
      mode: InsertMode.insertOrReplace,
    );
    return Attendance(
        id: id,
        groupPersonId: groupPerson?.id,
        date: date,
        hoursFact: hoursFact
    );
  }

  /// Исправление посещаемости
  Future<bool> update2(Attendance attendance) async =>
      await update(db.attendances).replace(attendance);

  /// Удаление посещаемости
  Future<bool> delete2(Attendance attendance) async =>
      (await delete(db.attendances).delete(attendance)) > 0 ? true : false;

  /// Отслеживание посещаемости персон в группе за период
  Stream<List<Attendance>> watch(GroupPeriod groupPeriod) =>
      db._groupPersonAttendances(
        groupPeriod?.group?.id,
        groupPeriod?.period != null
            ? DateTime(groupPeriod.period.year, groupPeriod.period.month, 1)
            : null,
        groupPeriod?.period,
      ).map((row) => Attendance(
        id: row.id,
        groupPersonId: row.groupPersonId,
        date: row.date,
        hoursFact: row.hoursFact,
      )).watch();

  /// Отслеживание посещаемости персон в группе за период
  Stream<List<AttendanceView>> watchOrgPeriod(OrgPeriod orgPeriod) =>
      db._orgAttendances(
        orgPeriod?.org?.id,
        orgPeriod?.period != null
            ? DateTime(orgPeriod.period.year, orgPeriod.period.month, 1)
            : null,
        orgPeriod?.period,
      ).map((row) => AttendanceView(
        id: row.id,
        groupPersonId: row.groupPersonId,
        date: row.date,
        hoursFact: row.hoursFact,
        groupId: row.groupId,
        meals: row.meals,
      )).watch();

  /// Поиск посещаемости
  Future<Attendance> find(GroupPerson groupPerson, DateTime date) async {
    try {
      return await (select(db.attendances)
        ..where((e) =>
        e.groupPersonId.equals(groupPerson?.id) &
        e.date.equals(date)
        )).getSingle();
    } catch(_) {
      return null;
    }
  }
}

// Настройки -------------------------------------------------------------------
@UseDao(tables: [Settings])
class SettingsDao extends DatabaseAccessor<Db> with _$SettingsDaoMixin {
  SettingsDao(Db db) : super(db);

  /// Добавление настройки
  Future<Setting> insert2(String name, ValueType valueType, {
    String textValue,
    bool boolValue,
    int intValue,
    double realValue,
    DateTime dateValue,
    bool isUserSetting = false,
  }) async {
    final id = await into(db.settings).insert(
        SettingsCompanion(
          name: Value(name),
          valueType: Value(valueType),
          textValue: Value(textValue),
          boolValue: Value(boolValue),
          intValue: Value(intValue),
          realValue: Value(realValue),
          dateValue: Value(dateValue),
          isUserSetting: Value(isUserSetting),
        )
    );
    return Setting(
      id: id,
      name: name,
      valueType: valueType,
      textValue: textValue,
      intValue: intValue,
      boolValue: boolValue,
      realValue: realValue,
      dateValue: dateValue,
      isUserSetting: isUserSetting,
    );
  }

  /// Исправление настройки
  Future<bool> update2(Setting setting) async =>
      await update(db.settings).replace(setting);

  /// Удаление настройки
  void delete2(String settingName) =>
      delete(db.settings).where((row) => row.name.equals(settingName));

  /// Отслеживание пользовательских настроек
  Stream<List<Setting>> watchUserSettings() =>
      (select(db.settings)
        ..where((e) => e.isUserSetting.equals(true))
        ..orderBy([(e) => OrderingTerm.asc(e.id)])
      ).watch();

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
      final count = await db._setActiveOrg(org?.id);
      if (count == 0) {
        insert2('activeOrg', ValueType.int, intValue: org?.id);
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
      final count = await db._setActiveSchedule(schedule?.id);
      if (count == 0) {
        insert2('activeSchedule', ValueType.int, intValue: schedule?.id);
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
      await db._setActiveGroup(group?.id, org?.id);

  // Активный период
  Stream<DateTime> watchActivePeriod() => db._activePeriod().watchSingle();

  getActivePeriod() async {
    try {
      return await db._activePeriod().getSingle();
    } catch(_) {
      return null;
    }
  }

  /// Установка активного периода
  Future setActivePeriod(DateTime period) async {
    if (period == null)
      delete2('activePeriod');
    else {
      final count = await db._setActivePeriod(period);
      if (count == 0) {
        insert2('activePeriod', ValueType.date, dateValue: period);
      }
    }
  }
}