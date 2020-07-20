import 'dart:io';
import 'dart:collection';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:timesheets/core/tools.dart';

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

/// Представление группы
class GroupView extends Group {
  final Schedule schedule; // график
  final int personCount;   // количество персон в группе

  GroupView({
    @required int id,
    @required int orgId,
    @required String name,
    @required this.schedule,
    this.personCount = 0,
  }) : super(
    id: id,
    orgId: orgId,
    name: name,
    scheduleId: schedule.id,
  );
}

/// Персона группы
class GroupPerson extends Person {
  final int gpLinkId;

  GroupPerson({
    @required int id,
    @required String family,
    @required String name,
    String middleName,
    DateTime birthday,
    @required this.gpLinkId,
  }) : super(
    id: id,
    family: family,
    name: name,
    middleName: middleName,
    birthday: birthday,
  );
}

/// База данных
@UseMoor(
  include: {'model.moor'},
  tables: [
    Orgs, // Организации
    Schedules,     // Графики
    ScheduleDays,  // Дни графиков
    Groups,        // Группы
    Persons,       // Персоны
    GpLinks,       // Связи персон с группами
    Timesheets,    // Табели
    Settings,      // Настройки
  ],
  daos: [
    OrgsDao,
    SchedulesDao,
    ScheduleDaysDao,
    GroupsDao,
    PersonsDao,
    GpLinksDao,
    TimesheetsDao,
    SettingsDao
  ]
)
class Db extends _$Db {
  /// Асинхронная база данных
  Db() : super(_openConnection());

  /// При модернизации модели нужно увеличить версию схемы и прописать миграцию
  @override
  int get schemaVersion => 1;

  /// Формирование графика и группы по умолчанию
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) {
      return m.createAll();
    },
    beforeOpen: (details) async {
      if (details.wasCreated) {
        transaction(() async {
          final schedule = await schedulesDao.insert2(
            code: 'пн,вт,ср,чт,пт 12ч',
            createDays: true);
          settingsDao.setActiveSchedule(schedule);
          final org1 = await orgsDao.insert2(
            name: 'МБДОУ д/с общеразвивающего типа №1 "Светлячок"',
            inn: '5001030102',
          );
          settingsDao.setActiveOrg(org1);
          final group11 = await groupsDao.insert2(
            org: org1,
            name: 'Группа 1',
            schedule: schedule,
          );
          settingsDao.setActiveGroup(org1, group11);
          gpLinksDao.insert2(
              person: await personsDao.insert2(
                family: 'Акульшин',
                name: 'Роман',
                middleName: 'Андреевич',
                birthday: DateTime(2016, 08, 23),
              ),
              group: group11);
          gpLinksDao.insert2(
              person: await personsDao.insert2(
                family: 'Алиева',
                name: 'Амина-Хатун',
                middleName: 'Кенатовна',
                birthday: DateTime(2016, 12, 23),
              ),
              group: group11);
          groupsDao.insert2(
              org: org1,
              name: 'Группа 2',
              schedule: schedule,
          );
          final org2 = await orgsDao
              .insert2(name: 'Детсад №2', inn: '5001101025');
          final group21 = await groupsDao.insert2(
              org: org2,
              name: 'Группа 1',
              schedule: schedule,
          );
          settingsDao.setActiveGroup(org2, group21);
        });
      }
      customStatement('PRAGMA foreign_keys = ON');
      if (await settingsDao.getActivePeriod() == null)
        settingsDao.setActivePeriod(lastDayOfMonth(DateTime.now()));
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
  void update2(Org org) => update(db.orgs).replace(org);

  /// Удаление организации
  void delete2(Org org) => delete(db.orgs).delete(org);

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
  Future<Org> _getFirstOrg() =>
      db._firstOrg().map((row) =>
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
    if (createDays != null && createDays) {
      final hoursByDays = parseScheduleCode(code);
      for (int dayNumber = 0; dayNumber < hoursByDays.length; dayNumber++)
        if (hoursByDays[dayNumber] != 0)
          db.scheduleDaysDao.insert2(
            schedule: schedule,
            dayNumber: dayNumber,
            hoursNorm: hoursByDays[dayNumber],
          );
    }
    return schedule;
  }

  /// Исправление графика
  void update2(Schedule schedule) => update(db.schedules).replace(schedule);

  /// Удаление графика
  void delete2(Schedule schedule) => delete(db.schedules).delete(schedule);

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
  Future<Schedule> _getFirstSchedule() =>
      db._firstSchedule().map((row) =>
          Schedule(
            id: row.id,
            code: row.code,
          )
      ).getSingle();

  /// Формирование списка часов по коду графика
  static List<double> parseScheduleCode(String code) {
    var hours = List<double>();
    if (code.contains(_inWeekStr)) {
      hours = List<double>.generate(14, (i) => 0.0);
    } else {
      hours = List<double>.generate(7, (i) => 0.0);
    }
    final parts = code.split(';');
    if (parts.length > 1) { // пн,вт 1ч;чт 2ч
      parts.forEach((part) => _parseScheduleCode(hours, part));
    } else { // пн,вт 1ч
      _parseScheduleCode(hours, code);
    }
    return hours;
  }

  /// Формирование кода графика по списку часов
  static String createScheduleCode(List<double> hours) {
    assert(hours.every((e) => e != null));
    assert(hours.reduce((a, b) => a + b) != 0);
    final parts = List<String>();
    final week = _createOneWeekDays(hours, 0);
    if (hours.length == 7) {
      week.forEach((hour, days) {
        parts.add(days.join(',') + ' $hour$_hourStr');
      });
    } else {
      final week2 = _createOneWeekDays(hours, 7);
      week.forEach((hour, days) {
        week2.forEach((hour2, days2) {
          if (hour == hour2) {
            final daysStr = days.join(',');
            final days2Str = days2.join(',');
            if (daysStr == days2Str) {
              parts.add(daysStr + ' $hour$_hourStr');
            } else {
              parts.add(
                  daysStr + '/' + days2Str + ' $_inWeekStr $hour$_hourStr');
            }
          }
        });
      });
    }
    return parts.join(';');
  }

  /// Формирование списка часов одному количеству часов
  static _parseScheduleCode(List<double> hours, String code) {
    if (code.contains(_inWeekStr)) { // вт/ср чз/нед 1ч
      final daysHour = code.replaceFirst('$_inWeekStr ', '').split(
          ' '); // ['вт/ср','1ч']
      assert(daysHour.length == 2);
      final weeks = daysHour[0].split('/'); // ['вт','ср']
      assert(weeks.length == 2);
      _parseWeek(hours, weeks[0], daysHour[1], 0);
      _parseWeek(hours, weeks[1], daysHour[1], 7);
    } else { // пн,вт 1ч
      final daysHour = code.split(' '); // ['пн,вт','1ч']
      assert(daysHour.length == 2);
      if (daysHour.length == 1) {
        _parseWeek(hours, '', daysHour[1], 0);
      } else {
        _parseWeek(hours, daysHour[0], daysHour[1], 0);
        if (hours.length == 14) {
          _parseWeek(hours, daysHour[0], daysHour[1], 7);
        }
      }
    }
  }

  /// Разбор строки с днями недели и строки с часами с учётом чередования недель
  static void _parseWeek(List<double> hours, String daysString,
      String hourString, int shift) {
    final hour = double.parse(
        hourString.replaceFirst(_hourStr, '').replaceFirst(',', '.'));
    for (int day = 0; day < 7; day++) {
      if (daysString == '' || daysString.contains(weekDays[day])) {
        hours[day + shift] = hour;
      }
    }
  }

  /// Формирование дней одной недели
  static _createOneWeekDays(List<double> hours, int offset) {
    final hoursMap = SplayTreeMap<double, List<String>>();
    hours.sublist(offset, offset + 7).where((e) => e > 0).toSet().forEach((hour) {
      hoursMap[hour] = [];
    });
    for (int day = offset; day < offset + 7; day++) {
      if (hoursMap.containsKey(hours[day])) {
        hoursMap[hours[day]].add(weekDays[day % 7]);
      }
    }
    return hoursMap;
  }

  static const List<String> weekDays = ['пн','вт','ср','чт','пт','сб','вс'];
  static const String _inWeekStr = 'чз/нед';
  static const String _hourStr = 'ч';
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

  /// Удаление дня графика
  void delete2(ScheduleDay scheduleDay) =>
      delete(db.scheduleDays).delete(scheduleDay);

  // Отслеживание дней графика
  Stream<List<ScheduleDay>> watch(Schedule schedule) =>
      db._daysInSchedule(schedule.id).map((row) =>
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
  Future<Group> insert2({
    @required Org org,
    @required String name,
    @required Schedule schedule,
  }) async {
    final id = await into(db.groups).insert(
        GroupsCompanion(
          orgId: Value(org.id),
          name: Value(name),
          scheduleId: Value(schedule.id),
        )
    );
    return Group(
      id: id,
      orgId: org.id,
      name: name,
      scheduleId: schedule.id,
    );
  }

  /// Исправление группы
  void update2(Group group) => update(db.groups).replace(group);

  /// Удаление группы
  void delete2(Group group) => delete(db.groups).delete(group);

  /// Отслеживание групп организации
  Stream<List<GroupView>> watch(Org org) =>
      db._groupsView(org?.id).map((row) =>
          GroupView(
            id: row.id,
            orgId: row.orgId,
            name: row.name,
            schedule: Schedule(id: row.scheduleId, code: row.scheduleCode),
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
        )
    ).getSingle() ?? _getFirstGroup(org);

  /// Первая группа организации в алфавитном порядке
  Future<Group> _getFirstGroup(Org org) =>
      db._firstGroup(org.id).map((row) =>
          Group(
            id: row.id,
            orgId: row.orgId,
            name: row.name,
            scheduleId: row.scheduleId,
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
  }) async {
    final id = await into(db.persons).insert(
        PersonsCompanion(
          family: Value(family),
          name: Value(name),
          middleName: Value(middleName),
          birthday: Value(birthday),
        )
    );
    return Person(
      id: id,
      family: family,
      name: name,
      middleName: middleName,
      birthday: birthday,
    );
  }

  /// Исправление персоны
  void update2(Person person) => update(db.persons).replace(person);

  /// Удаление персоны
  void delete2(Person person) => delete(db.persons).delete(person);

  /// Отслеживание персон
  Stream<List<Person>> watch() => select(db.persons).watch();
}

// Связи персон с группами -----------------------------------------------------
@UseDao(tables: [GpLinks])
class GpLinksDao extends DatabaseAccessor<Db> with _$GpLinksDaoMixin {
  GpLinksDao(Db db) : super(db);

  /// Добавление связи персоны с группой
  Future<GroupPerson> insert2({
    @required Person person,
    @required Group group,
  }) async {
    final id = await into(db.gpLinks).insert(
        GpLinksCompanion(
          personId: Value(person.id),
          groupId: Value(group.id),
        )
    );
    return GroupPerson(
      id: person.id,
      family: person.family,
      name: person.name,
      middleName: person.middleName,
      birthday: person.birthday,
      gpLinkId: id,
    );
  }

  /// Удаление связи персоны с группой
  void delete2(GroupPerson personOfGroup) =>
      delete(db.gpLinks).delete(
          GpLinksCompanion(
            id: Value(personOfGroup.gpLinkId),
          )
      );

  /// Отслеживание связей персон с группой
  Stream<List<GroupPerson>> watch(Group group) =>
      db._personsInGroup(group.id).map((row) =>
          GroupPerson(
            id: row.personId,
            family: row.family,
            name: row.name,
            middleName: row.middleName,
            birthday: row.birthday,
            gpLinkId: row.gpLinkId,
          )
      ).watch();
}

// Посещаемость персон в группе ----------------------------------------------
@UseDao(tables: [Timesheets])
class TimesheetsDao extends DatabaseAccessor<Db> with _$TimesheetsDaoMixin {
  TimesheetsDao(Db db) : super(db);

  /// Добавление посещаемости
  Future<Timesheet> insert2({
    @required GroupPerson personOfGroup,
    @required DateTime attendanceDate,
    @required num hoursNumber,
  }) async {
    final id = await into(db.timesheets).insert(
        TimesheetsCompanion(
          gpLinkId: Value(personOfGroup.gpLinkId),
          attendanceDate: Value(attendanceDate),
          hoursNumber: Value(hoursNumber),
        )
    );
    return Timesheet(
        id: id,
        gpLinkId: personOfGroup.gpLinkId,
        attendanceDate: attendanceDate,
        hoursNumber: hoursNumber
    );
  }

  /// Удаление посещаемости
  void delete2(Timesheet timesheet) =>
      delete(db.timesheets).delete(timesheet);

  /// Отслеживание посещаемости персоны в группе за период
  Stream<List<Timesheet>> watch({
    @required GroupPerson personOfGroup,
    @required DateTime period,
  }) => db._timesheetsView(
      personOfGroup.gpLinkId, period.toIso8601String()).map((row) =>
      Timesheet(
        id: row.id,
        gpLinkId: row.gpLinkId,
        attendanceDate: row.attendanceDate,
        hoursNumber: row.hoursNumber,
      )
  ).watch();
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
      delete(db.settings).where((s) => s.name.equals(settingName));

  /// Активная организация
  Stream<Org> watchActiveOrg() => _selectActiveOrg().watchSingle();
  Future<Org> getActiveOrg() => _selectActiveOrg().getSingle();
  Selectable<Org> _selectActiveOrg() =>
      db._activeOrg().map((row) =>
          Org(
            id: row.id,
            name: row.name,
            inn: row.inn,
            activeGroupId: row.activeGroupId,
          )
      );

  /// Установка активной организации
  void setActiveOrg(Org org) async {
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
  Stream<Schedule> watchActiveSchedule() => _selectActiveSchedule().watchSingle();
  Future<Schedule> getActiveSchedule() => _selectActiveSchedule().getSingle();
  Selectable<Schedule> _selectActiveSchedule() =>
      db._activeSchedule().map((row) =>
          Schedule(
            id: row.id,
            code: row.code,
          )
      );

  /// Установка активного графика
  void setActiveSchedule(Schedule schedule) async {
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
  Stream<Group> watchActiveGroup(Org org) =>
      _selectActiveGroup(org).watchSingle();
  Future<Group> getActiveGroup(Org org) =>
      _selectActiveGroup(org).getSingle();
  Selectable<Group> _selectActiveGroup(Org org) =>
      select(db.groups)..where((entry) => entry.id?.equals(org?.activeGroupId));

  /// Установка активной группы
  Future setActiveGroup(Org org, Group group) =>
      db._setActiveGroup(group.id, org.id);

  // Активный период
  Stream<DateTime> watchActivePeriod() => db._activePeriod().watchSingle();
  Future<DateTime> getActivePeriod() => db._activePeriod().getSingle();

  /// Установка активного периода
  Future setActivePeriod(DateTime activePeriod) async {
    final activePeriodOld = await getActivePeriod();
    if (activePeriodOld != null && activePeriodOld != activePeriod) {
      db._setActivePeriod(activePeriod);
    } else {
      insert2('activePeriod', dateValue: activePeriod);
    }
  }
}