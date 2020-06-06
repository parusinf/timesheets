import 'dart:io';
import 'dart:collection';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:timesheets/core/tools.dart';

part 'db.g.dart';

/// Представление группы
class GroupView extends Group {
  final Schedule schedule; // график
  final int personCount; // количество персон в группе

  GroupView({
    @required int id,
    @required String name,
    @required this.schedule,
    this.personCount = 0,
  }) : super(id: id, name: name, scheduleId: schedule.id);
}

/// Персона группы
class PersonOfGroup extends Person {
  final int pgLinkId;

  PersonOfGroup({
    @required int id,
    @required String family,
    @required String name,
    String middleName,
    @required this.pgLinkId,
  }) : super(
    id: id,
    family: family,
    name: name,
    middleName: middleName,
  );
}

/// База данных
@UseMoor(
  include: {'model.moor'},
  tables: [Schedules, ScheduleDays, Groups, Persons, PgLinks, Timesheets, Settings],
  daos: [SchedulesDao, ScheduleDaysDao, GroupsDao, PersonsDao, PgLinksDao, TimesheetsDao, SettingsDao]
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
          final s = await schedulesDao.create(
              code: 'пн,вт,ср,чт,пт 12ч',
              createDays: true);
          final g1 = await groupsDao.create(name: 'Группа 1', schedule: s);
          settingsDao.setActiveGroup(g1);
          pgLinksDao.create(
              person: await personsDao.create(family: 'Шишкин', name: 'Константин'),
              group: g1);
          pgLinksDao.create(
              person: await personsDao.create(family: 'Малеев', name: 'Виктор'),
              group: g1);
          groupsDao.create(name: 'Группа 2', schedule: s);
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

// Графики ---------------------------------------------------------------------
@UseDao(tables: [Schedules])
class SchedulesDao extends DatabaseAccessor<Db> with _$SchedulesDaoMixin {
  SchedulesDao(Db db) : super(db);

  /// Создание графика
  Future<Schedule> create({
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
          db.scheduleDaysDao.create(
            schedule: schedule,
            dayNumber: dayNumber,
            hoursNorm: hoursByDays[dayNumber],
          );
    }
    return schedule;
  }

  /// Удаление графика
  Future del(Schedule schedule) =>
      delete(db.schedules).delete(schedule);

  /// Формирование списка часов по коду графика
  static List<double> parseScheduleCode(String code) {
    var hours = List<double>();
    if (code.contains(_inWeekStr))
      hours = List<double>.generate(14, (i) => 0.0);
    else
      hours = List<double>.generate(7, (i) => 0.0);
    final parts = code.split(';');
    if (parts.length > 1) // пн,вт 1ч;чт 2ч
      parts.forEach((part) => _parseScheduleCode(hours, part));
    else // пн,вт 1ч
      _parseScheduleCode(hours, code);
    return hours;
  }

  /// Формирование кода графика по списку часов
  static String createScheduleCode(List<double> hours) {
    assert(hours.every((e) => e != null));
    assert(hours.reduce((a, b) => a + b) != 0);
    final parts = List<String>();
    final week = _createOneWeekDays(hours, 0);
    if (hours.length == 7)
      week.forEach((hour, days) {
        parts.add(days.join(',') + ' $hour$_hourStr');
      });
    else {
      final week2 = _createOneWeekDays(hours, 7);
      week.forEach((hour, days) {
        week2.forEach((hour2, days2) {
          if (hour == hour2) {
            final daysStr = days.join(',');
            final days2Str = days2.join(',');
            if (daysStr == days2Str)
              parts.add(daysStr + ' $hour$_hourStr');
            else
              parts.add(daysStr + '/' + days2Str + ' $_inWeekStr $hour$_hourStr');
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
      if (daysHour.length == 1)
        _parseWeek(hours, '', daysHour[1], 0);
      else {
        _parseWeek(hours, daysHour[0], daysHour[1], 0);
        if (hours.length == 14)
          _parseWeek(hours, daysHour[0], daysHour[1], 7);
      }
    }
  }

  /// Разбор строки с днями недели и строки с часами с учётом чередования недель
  static void _parseWeek(List<double> hours, String daysString,
      String hourString, int shift) {
    final hour = double.parse(
        hourString.replaceFirst(_hourStr, '').replaceFirst(',', '.'));
    for (int day = 0; day < 7; day++)
      if (daysString == '' || daysString.contains(weekDays[day]))
        hours[day + shift] = hour;
  }

  /// Формирование дней одной недели
  static _createOneWeekDays(List<double> hours, int offset) {
    final hoursMap = SplayTreeMap<double, List<String>>();
    hours.sublist(offset, offset + 7).where((e) => e > 0).toSet().forEach((hour) {
      hoursMap[hour] = [];
    });
    for (int day = offset; day < offset + 7; day++)
      if (hoursMap.containsKey(hours[day]))
        hoursMap[hours[day]].add(weekDays[day % 7]);
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

  /// Создание дня графика
  Future<ScheduleDay> create({
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
  Future del(ScheduleDay scheduleDay) =>
      delete(db.scheduleDays).delete(scheduleDay);

  // Просмотр дней графика
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
  
  /// Создание группы
  Future<Group> create({
    @required String name,
    @required Schedule schedule,
  }) async {
    final id = await into(db.groups).insert(
        GroupsCompanion(
          name: Value(name),
          scheduleId: Value(schedule.id),
        )
    );
    return Group(
      id: id,
      name: name,
      scheduleId: schedule.id,
    );
  }

  /// Удаление группы
  Future del(Group group) async {
    final activeGroup = await db.settingsDao.getActiveGroup();
    if (group.id == activeGroup.id)
      db.settingsDao.setActiveGroup(await _getPreviousGroup(group.name));
    delete(db.groups).delete(group);
  }

  /// Просмотр представлений групп
  Stream<List<GroupView>> watch() =>
      db._groupsView().map((row) =>
          GroupView(
            id: row.id,
            name: row.name,
            schedule: Schedule(id: row.scheduleId, code: row.scheduleCode),
            personCount: row.personCount,
          )
      ).watch();

  /// Предыдущая группа (в алфавитном порядке) перед заданной
  Future<Group> _getPreviousGroup(String groupName) =>
      db._previousGroup(groupName).map((row) =>
          Group(
            id: row.id,
            name: row.name,
            scheduleId: row.scheduleId,
          )
      ).getSingle();
}

// Персоны ---------------------------------------------------------------------
@UseDao(tables: [Persons])
class PersonsDao extends DatabaseAccessor<Db> with _$PersonsDaoMixin {
  PersonsDao(Db db) : super(db);

  /// Создание персоны
  Future<Person> create({
    @required String family,
    @required String name,
    String middleName,
  }) async {
    final id = await into(db.persons).insert(
        PersonsCompanion(
          family: Value(family),
          name: Value(name),
          middleName: Value(middleName),
        )
    );
    return Person(
      id: id,
      family: family,
      name: name,
      middleName: middleName,
    );
  }

  /// Исправление персоны
  Future upd(Person person) => update(db.persons).replace(person);

  /// Удаление персоны
  Future del(Person person) => delete(db.persons).delete(person);
}

// Связи персон с группами -----------------------------------------------------
@UseDao(tables: [PgLinks])
class PgLinksDao extends DatabaseAccessor<Db> with _$PgLinksDaoMixin {
  PgLinksDao(Db db) : super(db);

  /// Добавление связи персоны и группы
  Future<PersonOfGroup> create({
    @required Person person,
    @required Group group,
  }) async {
    final id = await into(db.pgLinks).insert(
        PgLinksCompanion(
          personId: Value(person.id),
          groupId: Value(group.id),
        )
    );
    return PersonOfGroup(
      id: person.id,
      family: person.family,
      name: person.name,
      middleName: person.middleName,
      pgLinkId: id,
    );
  }

  /// Удаление связи персоны и группы
  Future del(PersonOfGroup personOfGroup) =>
      delete(db.pgLinks).delete(
          PgLinksCompanion(
            id: Value(personOfGroup.pgLinkId),
          )
      );

  /// Просмотр связей персон и групп
  Stream<List<PersonOfGroup>> watch(Group group) =>
      db._personsInGroup(group.id).map((row) =>
          PersonOfGroup(
            id: row.personId,
            family: row.family,
            name: row.name,
            middleName: row.middleName,
            pgLinkId: row.pgLinkId,
          )
      ).watch();
}

// Посещаемость персон в группе ----------------------------------------------
@UseDao(tables: [Timesheets])
class TimesheetsDao extends DatabaseAccessor<Db> with _$TimesheetsDaoMixin {
  TimesheetsDao(Db db) : super(db);

  /// Создание посещаемости персоны
  Future<Timesheet> create({
    @required PersonOfGroup personOfGroup,
    @required DateTime attendanceDate,
    @required num hoursNumber,
  }) async {
    final id = await into(db.timesheets).insert(
        TimesheetsCompanion(
          pgLinkId: Value(personOfGroup.pgLinkId),
          attendanceDate: Value(attendanceDate),
          hoursNumber: Value(hoursNumber),
        )
    );
    return Timesheet(
        id: id,
        pgLinkId: personOfGroup.pgLinkId,
        attendanceDate: attendanceDate,
        hoursNumber: hoursNumber
    );
  }

  /// Удаление посещаемости персоны
  Future del(Timesheet timesheet) =>
      delete(db.timesheets).delete(timesheet);

  /// Просмотр посещаемости персоны в группе за период
  Stream<List<Timesheet>> watch({
    @required PersonOfGroup personOfGroup,
    @required DateTime period,
  }) => db._timesheetsView(
      personOfGroup.pgLinkId, period.toIso8601String()).map((row) =>
      Timesheet(
        id: row.id,
        pgLinkId: row.pgLinkId,
        attendanceDate: row.attendanceDate,
        hoursNumber: row.hoursNumber,
      )
  ).watch();
}

// Настройки -------------------------------------------------------------------
@UseDao(tables: [Settings])
class SettingsDao extends DatabaseAccessor<Db> with _$SettingsDaoMixin {
  SettingsDao(Db db) : super(db);

  /// Создание настройки
  Future<Setting> create({
    @required String name,
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

  /// Исправление настройки
  Future updateSetting(Setting setting) => update(db.settings).replace(setting);

  /// Удаление настройки
  Future deleteSetting(Setting setting) => delete(db.settings).delete(setting);

  /// Активная группа
  Stream<Group> watchActiveGroup() => _selectActiveGroup().watchSingle();
  Future<Group> getActiveGroup() async => await _selectActiveGroup().getSingle();
  Selectable<Group> _selectActiveGroup() => db._activeGroup().map((row) =>
      Group(id: row.id, name: row.name, scheduleId: row.scheduleId));

  /// Установка активной группы
  Future setActiveGroup(Group group) async {
    final activeGroupOld = await getActiveGroup();
    if (activeGroupOld == null)
      create(name: 'activeGroup', intValue: group.id);
    else if (activeGroupOld.id != group.id)
      db._setActiveGroup(group.id);
  }

  // Активный период
  Stream<DateTime> watchActivePeriod() => db._activePeriod().watchSingle();
  Future<DateTime> getActivePeriod() => db._activePeriod().getSingle();

  /// Установка активного периода
  Future setActivePeriod(DateTime activePeriod) async {
    final activePeriodOld = await getActivePeriod();
    if (activePeriodOld != null && activePeriodOld != activePeriod)
      db._setActivePeriod(activePeriod);
    else
      create(name: 'activePeriod', dateValue: activePeriod);
  }
}