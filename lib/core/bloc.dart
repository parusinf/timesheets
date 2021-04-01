import 'dart:async';
import 'package:flutter/services.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/core.dart';

/// Организация с признаком активности
class ActiveOrg {
  OrgView orgView;
  bool isActive;
  ActiveOrg(this.orgView, this.isActive);
}

/// График с признаком активности
class ActiveSchedule {
  ScheduleView scheduleView;
  bool isActive;
  ActiveSchedule(this.scheduleView, this.isActive);
}

/// Группа с признаком активности
class ActiveGroup {
  GroupView groupView;
  bool isActive;
  ActiveGroup(this.groupView, this.isActive);
}

/// Компонент бизнес логики (блок) приложения
class Bloc {
  // Отслеживание контента
  static const eventChannel = const EventChannel('receive_content/events');
  static const methodChannel = const MethodChannel('receive_content/channel');
  StreamController<String> _contentController = StreamController();
  Stream<String> get content => _contentController.stream;
  Sink<String> get contentSink => _contentController.sink;

  // База данных
  final Db db;

  // Активная организация
  final activeOrg = BehaviorSubject<Org>();

  // Активный график
  final activeSchedule = BehaviorSubject<Schedule>();

  // Активная группа
  final activeGroup = BehaviorSubject<GroupView>();

  // Активный период
  final activePeriod = BehaviorSubject<DateTime>();

  // Активная группа и период
  final activeGroupPeriod = BehaviorSubject<GroupPeriod>();

  // Активная организация и период
  final activeOrgPeriod = BehaviorSubject<OrgPeriod>();

  // Организации с признаком активности
  final activeOrgs = BehaviorSubject<List<ActiveOrg>>();

  // Графики с признаком активности
  final activeSchedules = BehaviorSubject<List<ActiveSchedule>>();

  // Дни активного графика
  final scheduleDays = BehaviorSubject<List<ScheduleDay>>();

  // Праздники
  final holidays = BehaviorSubject<List<Holiday>>();

  // Праздничные дни
  final holidaysDateList = BehaviorSubject<List<DateTime>>();

  // Рабочие дни
  final workdaysDateList = BehaviorSubject<List<DateTime>>();

  // Группы с признаком активности
  final activeGroups = BehaviorSubject<List<ActiveGroup>>();

  // Персоны активной группы
  final groupPersons = BehaviorSubject<List<GroupPersonView>>();

  // Персоны активной группы активного периода
  final groupPeriodPersons = BehaviorSubject<List<GroupPersonView>>();

  // Группы активной организации
  Stream<List<GroupView>> groups;

  // Питания активной организации
  final meals = BehaviorSubject<List<GroupView>>();

  // Посещаемость персон активной группы в активном периоде
  Stream<List<Attendance>> attendances;

  // Посещаемость активной организации в активном периоде
  Stream<List<AttendanceView>> orgAttendances;

  // Пользовательские настройки
  final userSettings = BehaviorSubject<List<Setting>>();

  /// Конструктор
  Bloc() : db = Db() {
    // Получение контента, переданного при запуске приложения
    startUri().then(_onRedirected);
    
    // Отслеживание контента во время работы приложения
    eventChannel.receiveBroadcastStream().listen((d) => _onRedirected(d));

    // Отслеживание активной организации из настройки
    Rx.concat([db.settingsDao.watchActiveOrg()])
        .listen(activeOrg.add);

    // Отслеживание активного графика из настройки
    Rx.concat([db.settingsDao.watchActiveSchedule()])
        .listen(activeSchedule.add);

    // Отслеживание активной группы организации
    Rx.concat([activeOrg.switchMap(db.settingsDao.watchActiveGroup)])
        .listen(activeGroup.add);

    // Отслеживание активного периода из настройки
    Rx.concat([db.settingsDao.watchActivePeriod()])
        .listen(activePeriod.add);

    // Отслеживание дней активного графика
    Rx.concat([activeSchedule.switchMap(db.scheduleDaysDao.watch)])
        .listen(scheduleDays.add);

    // Отслеживание праздников
    Rx.concat([db.holidaysDao.watch()])
        .listen(holidays.add);

    // Отслеживание праздничных дней
    Rx.concat([db.holidaysDao.watchHolidays()])
        .listen(holidaysDateList.add);

    // Отслеживание рабочих дней
    Rx.concat([db.holidaysDao.watchWorkdays()])
        .listen(workdaysDateList.add);

    // Отслеживание групп в активной организации
    groups = activeOrg.switchMap(db.groupsDao.watch);

    // Отслеживание питания в активной организации
    Rx.concat([activeOrg.switchMap(db.groupsDao.watchMeals)])
        .listen(meals.add);

    // Отслеживание активной группы и периода
    Rx.combineLatest2<Group, DateTime, GroupPeriod>(
        activeGroup,
        activePeriod,
        (group, period) => GroupPeriod(group, period),
    ).listen(activeGroupPeriod.add);

    // Отслеживание активной организации и периода
    Rx.combineLatest2<Org, DateTime, OrgPeriod>(
        activeOrg,
        activePeriod,
        (org, period) => OrgPeriod(org, period),
    ).listen(activeOrgPeriod.add);

    // Отслеживание посещаемости персон в группе за период
    attendances = activeGroupPeriod.switchMap(db.attendancesDao.watch);

    // Отслеживание посещаемости в организации за период
    orgAttendances = activeOrgPeriod.switchMap(db.attendancesDao.watchOrgPeriod);

    // Формирование признака активности организаций
    Rx.combineLatest2<List<Org>, Org, List<ActiveOrg>>(
        db.orgsDao.watch(),
        activeOrg,
        (orgs, selected) =>
            orgs.map((org) =>
                ActiveOrg(org, org?.id == selected?.id)
            ).toList()
    ).listen(activeOrgs.add);

    // Формирование признака активности графиков
    Rx.combineLatest2<List<Schedule>, Schedule, List<ActiveSchedule>>(
        db.schedulesDao.watch(),
        activeSchedule,
        (schedules, selected) =>
            schedules.map((schedule) =>
                ActiveSchedule(schedule, schedule?.id == selected?.id)
            ).toList()
    ).listen(activeSchedules.add);

    // Формирование признака активности групп
    Rx.combineLatest2<List<GroupView>, Group, List<ActiveGroup>>(
        groups,
        activeGroup,
        (groups, selected) =>
            groups.map((group) =>
                ActiveGroup(group, group?.id == selected?.id)
            ).toList()
    ).listen(activeGroups.add);

    // Отслеживание персон в активной группе
    Rx.concat([activeGroup.switchMap(db.groupPersonsDao.watch)])
        .listen(groupPersons.add);

    // Отслеживание персон в активной группе в активном периоде
    Rx.concat([activeGroupPeriod.switchMap(db.groupPersonsDao.watchGroupPeriod)])
        .listen(groupPeriodPersons.add);

    // Отслеживание пользовательских настроек
    Rx.concat([db.settingsDao.watchUserSettings()])
        .listen(userSettings.add);
  }

  /// Перенаправление контента в поток БЛоКа
  _onRedirected(String uri) {
    contentSink.add(uri);
  }

  /// Получение контента при запуске приложения
  Future<String> startUri() async {
    try {
      return methodChannel.invokeMethod('initialLink');
    } on PlatformException catch (e) {
      return "Failed to Invoke: '${e.message}'.";
    }
  }

  /// Освобождение ресурсов
  void close() {
    _contentController.close();
    activeOrg.close();
    activeSchedule.close();
    activeGroup.close();
    activePeriod.close();
    activeGroupPeriod.close();
    activeOrgPeriod.close();
    activeOrgs.close();
    activeSchedules.close();
    activeGroups.close();
    scheduleDays.close();
    holidays.close();
    holidaysDateList.close();
    workdaysDateList.close();
    groupPersons.close();
    groupPeriodPersons.close();
    meals.close();
    userSettings.close();
    db.close();
  }

  // Активный период -----------------------------------------------------------
  /// Установка активного периода
  Future setActivePeriod(DateTime period) async =>
      db.settingsDao.setActivePeriod(period);

  // Организации ---------------------------------------------------------------
  /// Установка активной организации
  Future setActiveOrg(Org org) async =>
      db.settingsDao.setActiveOrg(org);

  /// Добавление организации
  Future<Org> insertOrg({@required String name, String inn}) async {
    final org = await db.orgsDao.insert2(name: name, inn: inn);
    setActiveOrg(org);
    return org;
  }

  /// Исправление организации
  Future<bool> updateOrg(Org org) async {
    setActiveOrg(org);
    return db.orgsDao.update2(org);
  }

  /// Удаление организации
  Future<bool> deleteOrg(Org org) async {
    final result = db.orgsDao.delete2(org);
    final previousOrg = await db.orgsDao.getPrevious(org);
    setActiveOrg(previousOrg);
    return result;
  }

  // Графики -------------------------------------------------------------------
  /// Установка активного графика
  Future setActiveSchedule(Schedule schedule) async =>
      db.settingsDao.setActiveSchedule(schedule);

  /// Добавление графика
  Future<Schedule> insertSchedule({@required String code, createDays = false}) async {
    final schedule = await db.schedulesDao.insert2(code: code, createDays: createDays);
    setActiveSchedule(schedule);
    return schedule;
  }

  /// Исправление графика
  Future<bool> updateSchedule(Schedule schedule) async =>
      db.schedulesDao.update2(schedule);

  /// Удаление графика
  Future<bool> deleteSchedule(Schedule schedule) async {
    final result = db.schedulesDao.delete2(schedule);
    final previousSchedule = await db.schedulesDao.getPrevious(schedule);
    setActiveSchedule(previousSchedule);
    return result;
  }

  // Праздники -----------------------------------------------------------------
  /// Добавление праздника
  Future<Holiday> insertHoliday({
    @required DateTime date,
    DateTime workday,
  }) async {
    return await db.holidaysDao.insert2(
      date: date,
      workday: workday,
    );
  }

  /// Исправление праздника
  Future<bool> updateHoliday(Holiday holiday) async =>
      db.holidaysDao.update2(holiday);

  /// Удаление праздника
  Future<bool> deleteHoliday(Holiday holiday) async {
    return await db.holidaysDao.delete2(holiday);
  }

  // Группы --------------------------------------------------------------------
  /// Установка активной группы и установка активным её графика
  Future setActiveGroup(Group group) async {
    db.settingsDao.setActiveGroup(activeOrg.value, group);
    if (group != null) {
      final schedule = await db.schedulesDao.get(group.scheduleId);
      setActiveSchedule(schedule);
    }
  }

  /// Добавление группы
  Future<GroupView> insertGroup({
    @required String name,
    @required Schedule schedule,
    int meals,
    upsert = false,
  }) async {
    final groupView = await db.groupsDao.insert2(
      org: activeOrg.value,
      name: name,
      schedule: schedule,
      meals: meals,
      upsert: upsert,
    );
    setActiveGroup(groupView);
    return groupView;
  }

  /// Исправление группы
  Future<bool> updateGroup(Group group) async {
    await setActiveGroup(group);
    return db.groupsDao.update2(group);
  }

  /// Удаление группы
  Future<bool> deleteGroup(Group group) async {
    final result = db.groupsDao.delete2(group);
    final previousGroup = await db.groupsDao.getPrevious(
        activeOrg.value, group);
    setActiveGroup(previousGroup);
    return result;
  }

  // Персоны -------------------------------------------------------------------
  /// Добавление персоны
  Future<Person> insertPerson({
    @required String family,
    @required String name,
    String middleName,
    DateTime birthday,
    String phone,
    String phone2,
  }) async => db.personsDao.insert2(
    family: family,
    name: name,
    middleName: middleName,
    birthday: birthday,
    phone: phone,
    phone2: phone2,
  );

  /// Исправление персоны
  Future<bool> updatePerson(Person person) async =>
      db.personsDao.update2(person);

  /// Удаление персоны
  Future<bool> deletePerson(Person person) async =>
      db.personsDao.delete2(person);

  // Персоны в группе ----------------------------------------------------------
  /// Добавление персоны в группу
  Future<GroupPerson> insertGroupPerson({
    @required Group group,
    @required Person person,
    DateTime beginDate,
    DateTime endDate
  }) async =>
      db.groupPersonsDao.insert2(group, person, beginDate, endDate);

  /// Исправление персоны в группе
  Future<bool> updateGroupPerson(GroupPerson groupPerson) async =>
      db.groupPersonsDao.update2(groupPerson);

  /// Удаление персоны из группы
  Future<bool> deleteGroupPerson(GroupPerson groupPerson) async =>
      db.groupPersonsDao.delete2(groupPerson);

  // Посещаемость --------------------------------------------------------------
  /// Добавление посещаемости
  Future<Attendance> insertAttendance({
    @required GroupPerson groupPerson,
    @required DateTime date,
    @required double hoursFact,
  }) async => db.attendancesDao.insert2(
    groupPerson: groupPerson,
    date: date,
    hoursFact: hoursFact,
  );

  /// Удаление посещаемости
  Future<bool> deleteAttendance(Attendance attendance) async =>
      db.attendancesDao.delete2(attendance);

  // Настройки -----------------------------------------------------------------
  Setting getSetting(String name) =>
      userSettings.value.firstWhere((e) => e.name == name);

  get doubleTapInTimesheet =>
      getSetting(L10n.doubleTapInTimesheet).boolValue;

  /// Исправление настройки
  Future<bool> updateSetting(Setting setting) async =>
      db.settingsDao.update2(setting);
}