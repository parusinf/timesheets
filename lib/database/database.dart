import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'schedule_helper.dart';

part 'database.g.dart';

/// Группа с графиком и количеством персон
class GroupWithScheduleAndCount extends Group {
  final Schedule schedule; // график
  final int personsAmount; // количество персон в группе

  GroupWithScheduleAndCount({
    @required int id,
    @required String name,
    @required this.schedule,
    this.personsAmount = 0,
  }) : super(id: id, name: name, scheduleId: schedule.id);
}

/// Персона группы
class PersonOfGroup extends Person {
  final int personGroupLinkId;

  PersonOfGroup({
    @required int id,
    @required String family,
    @required String name,
    String middleName,
    DateTime birthday,
    @required this.personGroupLinkId,
  }) : super(
    id: id,
    family: family,
    name: name,
    middleName: middleName,
    birthday: birthday,
  );
}

/// База данных
@UseMoor(include: {'model.moor'})
class Database extends _$Database {
  /// База данных в фоновом изоляте
  Database() : super(VmDatabase.memory());
  Database.connect(DatabaseConnection connection) : super.connect(connection);

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
        //transaction(() async {
          final schedule = await createSchedule(
              code: 'пн,вт,ср,чт,пт 12ч',
              createDaysByCode: true);
          final group1 = await createGroup(name: 'Носов', schedule: schedule);
          await insertPersonIntoGroup(
              person: await createPerson(family: 'Шишкин', name: 'Константин'),
              group: group1);
          await insertPersonIntoGroup(
              person: await createPerson(family: 'Малеев', name: 'Виктор'),
              group: group1);
          await setActiveGroup(group: group1);
          final group2 = await createGroup(
              name: 'Достоевский', schedule: schedule);
          await insertPersonIntoGroup(
              person: await createPerson(family: 'Карамазов', name: 'Дмитрий'),
              group: group2);
          await insertPersonIntoGroup(
              person: await createPerson(family: 'Карамазов', name: 'Иван'),
              group: group2);
          await insertPersonIntoGroup(
              person: await createPerson(family: 'Карамазов', name: 'Алексей'),
              group: group2);
        //});
      }
    }
  );

  // Графики -------------------------------------------------------------------
  /// Создание графика
  Future<Schedule> createSchedule({
    @required String code,
    bool createDaysByCode = false,
  }) async {
    final id = await into(schedules).insert(SchedulesCompanion(code: Value(code)));
    final schedule = Schedule(id: id, code: code);
    if (createDaysByCode != null && createDaysByCode) {
      final hoursByDays = parseScheduleCode(code);
      for (int dayNumber = 0; dayNumber < hoursByDays.length; dayNumber++) {
        if (hoursByDays[dayNumber] != 0) {
          createScheduleDay(
            schedule: schedule,
            dayNumber: dayNumber,
            hoursNorm: hoursByDays[dayNumber],
          );
        }
      }
    }
    return schedule;
  }

  /// Удаление графика
  Future<void> deleteSchedule({
    @required Schedule schedule,
  }) async => delete(schedules).delete(schedule);

  // Дни графиков --------------------------------------------------------------
  /// Создание дня графика
  Future<ScheduleDay> createScheduleDay({
    @required Schedule schedule,
    @required int dayNumber,
    @required double hoursNorm,
  }) async {
    final id = await into(scheduleDays).insert(
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
  Future<void> deleteScheduleDay({
    @required ScheduleDay scheduleDay,
  }) async => delete(scheduleDays).delete(scheduleDay);

  // Дни графика
  Stream<List<ScheduleDay>> watchDaysInSchedule(Schedule schedule) =>
      _daysInSchedule(schedule.id).map((row) =>
      ScheduleDay(
        id: row.id,
        scheduleId: row.scheduleId,
        dayNumber: row.dayNumber,
        hoursNorm: row.hoursNorm
      )
  ).watch();

  // Группы --------------------------------------------------------------------
  /// Создание группы
  Future<Group> createGroup({
    @required String name,
    @required Schedule schedule,
  }) async {
    final id = await into(groups).insert(
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
  Future<void> deleteGroup({
    @required Group group,
  }) async => delete(groups).delete(group);

  /// Список групп с графиками и количеством персон
  Stream<List<GroupWithScheduleAndCount>> watchGroupsWithScheduleAndCount() =>
      _groupsExtras().map((row) =>
          GroupWithScheduleAndCount(
            id: row.id,
            name: row.name,
            schedule: Schedule(id: row.scheduleId, code: row.scheduleCode),
            personsAmount: row.personsAmount,
          )
      ).watch();

  // Персоны -------------------------------------------------------------------
  /// Создание персоны
  Future<Person> createPerson({
    @required String family,
    @required String name,
    String middleName,
    DateTime birthday,
  }) async {
    final id = await into(persons).insert(
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
  Future<void> updatePerson({
    @required Person person,
  }) async => update(persons).replace(person);

  /// Удаление персоны
  Future<void> deletePerson({
    @required Person person,
  }) async => delete(persons).delete(person);

  // Персоны в группе ----------------------------------------------------------
  /// Добавление персоны в группу
  Future<PersonOfGroup> insertPersonIntoGroup({
    @required Person person,
    @required Group group,
  }) async {
    final id = await into(personGroupLinks).insert(
        PersonGroupLinksCompanion(
          personId: Value(person.id),
          groupId: Value(group.id),
        )
    );
    return PersonOfGroup(
      id: person.id,
      family: person.family,
      name: person.name,
      middleName: person.middleName,
      birthday: person.birthday,
      personGroupLinkId: id,
    );
  }

  /// Удаление персоны из группы
  Future<void> deletePersonFromGroup({
    @required PersonOfGroup personOfGroup,
  }) async => delete(personGroupLinks).delete(
      PersonGroupLinksCompanion(
        id: Value(personOfGroup.personGroupLinkId),
      )
  );

  /// Список персон в группе
  Stream<List<PersonOfGroup>> watchPersonsInGroup(Group group) => 
      _personsInGroup(group.id).map((row) =>
      PersonOfGroup(
        id: row.personId,
        family: row.family,
        name: row.name,
        middleName: row.middleName,
        birthday: row.birthday,
        personGroupLinkId: row.personGroupLinkId,
      )
  ).watch();

  // Посещаемость персон в группе ----------------------------------------------
  /// Создание посещаемости персоны
  Future<Timesheet> createTimesheet({
    @required PersonOfGroup personOfGroup,
    @required DateTime attendanceDate,
    @required num hoursNumber,
  }) async {
    final id = await into(timesheets).insert(
        TimesheetsCompanion(
          personGroupLinkId: Value(personOfGroup.personGroupLinkId),
          attendanceDate: Value(attendanceDate),
          hoursNumber: Value(hoursNumber),
        )
    );
    return Timesheet(
      id: id,
      personGroupLinkId: personOfGroup.personGroupLinkId,
      attendanceDate: attendanceDate,
      hoursNumber: hoursNumber
    );
  }

  /// Удаление посещаемости персоны
  Future<void> deleteTimesheet({
    @required PersonOfGroup personOfGroup,
  }) async => delete(timesheets).delete(
      TimesheetsCompanion(
        personGroupLinkId: Value(personOfGroup.personGroupLinkId),
      )
  );

  /// Посещаемость персоны в группе за период
  Stream<List<Timesheet>> watchTimesheetsOfPersonInGroupForPeriod({
    @required PersonOfGroup personOfGroup,
    @required DateTime period,
  }) => _timesheetsOfPersonInGroupForPeriod(
      personOfGroup.personGroupLinkId, period.toIso8601String()).map((row) =>
      Timesheet(
        id: row.id,
        personGroupLinkId: row.personGroupLinkId,
        attendanceDate: row.attendanceDate,
        hoursNumber: row.hoursNumber,
      )
  ).watch();

  // Настройки -----------------------------------------------------------------
  /// Создание настройки
  Future<Setting> createSetting({
    @required String name,
    String textValue,
    int intValue,
    DateTime dateValue,
  }) async {
    final id = await into(settings).insert(
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
  Future<void> updateSetting({
    @required Setting setting,
  }) async => update(settings).replace(setting);

  /// Удаление настройки
  Future<void> deleteSetting({
    @required Setting setting,
  }) async => delete(settings).delete(setting);

  /// Активная группа
  Stream<Group> watchActiveGroup() => _activeGroup().map((row) =>
      Group(
        id: row.id,
        name: row.name,
        scheduleId: row.scheduleId
      )
  ).watchSingle();

  /// Установка активной группы
  Future<void> setActiveGroup({
    @required Group group,
  }) async {
    final activeGroupId = await _activeGroup().map((row) => row.id).getSingle();
    if (activeGroupId != null && activeGroupId != group.id)
      await _setActiveGroup(group.id);
    else
      await createSetting(name: 'activeGroup', intValue: group.id);
  }
}
