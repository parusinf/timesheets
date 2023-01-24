import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/foundation.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/core.dart';
import 'package:http/http.dart' as http;

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
  final eventChannel = defaultTargetPlatform == TargetPlatform.android?
    const EventChannel('receive_content/events') : null;
  final methodChannel = defaultTargetPlatform == TargetPlatform.android?
    const MethodChannel('receive_content/channel') : null;
  final StreamController<String> _contentController = StreamController();
  Stream<String> get content => _contentController.stream;
  Sink<String> get contentSink => _contentController.sink;

  // База данных
  final Db db;

  // Активная организация
  final activeOrg = BehaviorSubject<OrgView?>();

  // Активный график
  final activeSchedule = BehaviorSubject<ScheduleView?>();

  // Активная группа
  final activeGroup = BehaviorSubject<GroupView?>();

  // Активный период
  final activePeriod = BehaviorSubject<DateTime?>();

  // Выходные дни активного года
  final activeYearDayOff = BehaviorSubject<String?>();

  // Активная группа и период
  final activeGroupPeriod = BehaviorSubject<GroupPeriod?>();

  // Активная организация и период
  final activeOrgPeriod = BehaviorSubject<OrgPeriod?>();

  // Организации с признаком активности
  final activeOrgs = BehaviorSubject<List<ActiveOrg>>();

  // Графики с признаком активности
  final activeSchedules = BehaviorSubject<List<ActiveSchedule>>();

  // Дни активного графика
  final scheduleDays = BehaviorSubject<List<ScheduleDay>>();

  // Группы с признаком активности
  final activeGroups = BehaviorSubject<List<ActiveGroup>>();

  // Персоны активной группы
  final groupPersons = BehaviorSubject<List<GroupPersonView>>();

  // Персоны активной группы активного периода
  final groupPeriodPersons = BehaviorSubject<List<GroupPersonView>>();

  // Группы активной организации
  Stream<List<GroupView>>? groups;

  // Питания активной организации
  final meals = BehaviorSubject<List<GroupView>>();

  // Посещаемость персон активной группы в активном периоде
  Stream<List<Attendance>>? attendances;

  // Посещаемость активной организации в активном периоде
  Stream<List<AttendanceView>>? orgAttendances;

  // Пользовательские настройки
  final userSettings = BehaviorSubject<List<Setting>>();

  /// Конструктор
  Bloc() : db = Db() {
    // Получение контента, переданного при запуске приложения
    startUri().then(_onRedirected);

    // Отслеживание контента во время работы приложения
    eventChannel?.receiveBroadcastStream().listen((d) => _onRedirected(d));

    // Отслеживание активной организации из настройки
    Rx.concat([db.settingsDao.watchActiveOrg()]).listen(activeOrg.add);

    // Отслеживание активного графика из настройки
    Rx.concat([db.settingsDao.watchActiveSchedule()])
        .listen(activeSchedule.add);

    // Отслеживание активной группы организации
    Rx.concat([activeOrg.switchMap(db.settingsDao.watchActiveGroup)])
        .listen(activeGroup.add);

    // Отслеживание активного периода из настройки
    Rx.concat([db.settingsDao.watchActivePeriod()]).listen(onChangeActivePeriod);

    // Отслеживание выходных дней активного года из настройки
    Rx.concat([db.settingsDao.watchActiveYearDayOff()]).listen(activeYearDayOff.add);

    // Отслеживание дней активного графика
    Rx.concat([activeSchedule.switchMap(db.scheduleDaysDao.watch)])
        .listen(scheduleDays.add);

    // Отслеживание групп в активной организации
    groups = activeOrg.switchMap(db.groupsDao.watch);

    // Отслеживание питания в активной организации
    Rx.concat([activeOrg.switchMap(db.groupsDao.watchMeals)]).listen(meals.add);

    // Отслеживание активной группы и периода
    Rx.combineLatest2<Group?, DateTime?, GroupPeriod?>(
      activeGroup,
      activePeriod,
      (group, period) => group != null && period != null ? GroupPeriod(group, period) : null,
    ).listen(activeGroupPeriod.add);

    // Отслеживание активной организации и периода
    Rx.combineLatest2<Org?, DateTime?, OrgPeriod?>(
      activeOrg,
      activePeriod,
      (org, period) => org != null && period != null ? OrgPeriod(org, period) : null,
    ).listen(activeOrgPeriod.add);

    // Отслеживание посещаемости персон в группе за период
    attendances = activeGroupPeriod.switchMap(db.attendancesDao.watch);

    // Отслеживание посещаемости в организации за период
    orgAttendances =
        activeOrgPeriod.switchMap(db.attendancesDao.watchOrgPeriod);

    // Формирование признака активности организаций
    Rx.combineLatest2<List<OrgView>, OrgView?, List<ActiveOrg>>(
        db.orgsDao.watch(),
        activeOrg,
        (orgs, selected) => orgs
            .map((org) => ActiveOrg(org, org.id == selected?.id))
            .toList()).listen(activeOrgs.add);

    // Формирование признака активности графиков
    Rx.combineLatest2<List<ScheduleView>, ScheduleView?, List<ActiveSchedule>>(
        db.schedulesDao.watch(),
        activeSchedule,
        (schedules, selected) => schedules
            .map((schedule) =>
                ActiveSchedule(schedule, schedule.id == selected?.id))
            .toList()).listen(activeSchedules.add);

    // Формирование признака активности групп
    Rx.combineLatest2<List<GroupView>, GroupView?, List<ActiveGroup>>(
        groups!,
        activeGroup,
        (groups, selected) => groups
            .map((group) => ActiveGroup(group, group.id == selected?.id))
            .toList()).listen(activeGroups.add);

    // Отслеживание персон в активной группе
    Rx.concat([activeGroup.switchMap(db.groupPersonsDao.watch)])
        .listen(groupPersons.add);

    // Отслеживание персон в активной группе в активном периоде
    Rx.concat([activeGroupPeriod.switchMap(db.groupPersonsDao.watchGroupPeriod)])
        .listen(groupPeriodPersons.add);

    // Отслеживание пользовательских настроек
    Rx.concat([db.settingsDao.watchUserSettings()]).listen(userSettings.add);
  }

  /// При смене года активного периода меняем выходные дни года
  void onChangeActivePeriod(DateTime? date) async {
    activePeriod.add(date);
    if (date != null) {
      String? yearDayOff = await db.settingsDao.getActiveYearDayOff();
      final activeYearStr = date.year.toString();
      if (yearDayOff == null
          || yearDayOff.substring(0, 4) != activeYearStr) {
        final url = 'https://isdayoff.ru/api/getdata?year=$activeYearStr';
        final uri = Uri.parse(url);
        final request = http.MultipartRequest('GET', uri);
        final response = await request.send();
        if (response.statusCode == 200) {
          final responseBytes = await response.stream.toBytes();
          final responseStr = utf8.decode(responseBytes);
          yearDayOff = '$activeYearStr$responseStr';
        } else {
          yearDayOff = null;
        }
        await db.settingsDao.setActiveYearDayOff(yearDayOff);
      }
    }
  }

  /// Перенаправление контента в поток БЛоКа
  _onRedirected(String uri) {
    contentSink.add(uri);
  }

  /// Получение контента при запуске приложения
  Future<String> startUri() async {
    try {
      return (await methodChannel?.invokeMethod('initialLink')).toString();
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
    activeYearDayOff.close();
    activeGroupPeriod.close();
    activeOrgPeriod.close();
    activeOrgs.close();
    activeSchedules.close();
    activeGroups.close();
    scheduleDays.close();
    groupPersons.close();
    groupPeriodPersons.close();
    meals.close();
    userSettings.close();
    db.close();
  }

  // Активный период -----------------------------------------------------------
  /// Установка активного периода
  Future setActivePeriod(DateTime period) async =>
      await db.settingsDao.setActivePeriod(period);

  // Организации ---------------------------------------------------------------
  /// Установка активной организации
  Future setActiveOrg(Org? org) async =>
      await db.settingsDao.setActiveOrg(org);

  /// Добавление организации
  Future<Org> insertOrg({required String name, String? inn}) async {
    var org = await db.orgsDao.find(name);
    if (org != null) {
      throw Exception(L10n.dupOrgName);
    }
    org ??= await db.orgsDao.insert2(name: name, inn: inn);
    await setActiveOrg(org);
    return org;
  }

  /// Исправление организации
  Future<bool> updateOrg(Org org) async {
    await setActiveOrg(org);
    return await db.orgsDao.update2(org);
  }

  /// Удаление организации
  Future<bool> deleteOrg(Org org) async {
    final result = await db.orgsDao.delete2(org);
    final previousOrg = await db.orgsDao.getPrevious(org);
    await setActiveOrg(previousOrg);
    return result;
  }

  // Графики -------------------------------------------------------------------
  /// Установка активного графика
  Future setActiveSchedule(Schedule schedule) async =>
      await db.settingsDao.setActiveSchedule(schedule);

  /// Добавление графика
  Future<Schedule> insertSchedule(String code) async {
    var schedule = await db.schedulesDao.insert2(code: code, createDays: true);
    await setActiveSchedule(schedule);
    return schedule;
  }

  /// Исправление графика
  Future<bool> updateSchedule(Schedule schedule) async =>
      await db.schedulesDao.update2(schedule);

  /// Удаление графика
  Future<bool> deleteSchedule(Schedule schedule) async {
    final result = await db.schedulesDao.delete2(schedule);
    final previousSchedule = await db.schedulesDao.getPrevious(schedule);
    await setActiveSchedule(previousSchedule);
    return result;
  }

  // Группы --------------------------------------------------------------------
  /// Установка активной группы и установка активным её графика
  Future setActiveGroup(Group? group) async {
    await db.settingsDao.setActiveGroup(activeOrg.valueOrNull, group);
    if (group != null) {
      final schedule = await db.schedulesDao.get(group.scheduleId);
      await setActiveSchedule(schedule);
    }
  }

  /// Добавление группы
  Future<GroupView> insertGroup({
    required String name,
    required Schedule schedule,
    int? meals,
  }) async {
    final groupView = await db.groupsDao.insert2(
      org: activeOrg.valueOrNull,
      name: name,
      schedule: schedule,
      meals: meals,
    );
    await setActiveGroup(groupView);
    return groupView;
  }

  /// Исправление группы
  Future<bool> updateGroup(Group group) async {
    await setActiveGroup(group);
    return db.groupsDao.update2(group);
  }

  /// Удаление группы
  Future<bool> deleteGroup(Group group) async {
    final result = await db.groupsDao.delete2(group);
    final previousGroup =
        await db.groupsDao.getPrevious(activeOrg.valueOrNull, group);
    await setActiveGroup(previousGroup);
    return result;
  }

  // Персоны -------------------------------------------------------------------
  /// Добавление персоны
  Future<Person> insertPerson({
    required String family,
    required String name,
    String? middleName,
    DateTime? birthday,
    String? phone,
    String? phone2,
  }) async =>
      await db.personsDao.insert2(
        family: family,
        name: name,
        middleName: middleName,
        birthday: birthday,
        phone: phone,
        phone2: phone2,
      );

  /// Исправление персоны
  Future<bool> updatePerson(Person person) async =>
      await db.personsDao.update2(person);

  /// Удаление персоны
  Future<bool> deletePerson(Person person) async =>
      await db.personsDao.delete2(person);

  // Персоны в группе ----------------------------------------------------------
  /// Добавление персоны в группу
  Future<GroupPerson> insertGroupPerson(
          {required Group group,
          required Person person,
          DateTime? beginDate,
          DateTime? endDate}) async =>
      await db.groupPersonsDao.insert2(group, person, beginDate, endDate);

  /// Исправление персоны в группе
  Future<bool> updateGroupPerson(GroupPerson groupPerson) async =>
      await db.groupPersonsDao.update2(groupPerson);

  /// Удаление персоны из группы
  Future<bool> deleteGroupPerson(GroupPerson groupPerson) async =>
      await db.groupPersonsDao.delete2(groupPerson);

  // Посещаемость --------------------------------------------------------------
  /// Добавление посещаемости
  Future<Attendance> insertAttendance({
    required GroupPerson groupPerson,
    required DateTime date,
    required double hoursFact,
    required bool isNoShow,
  }) async =>
      await db.attendancesDao.insert2(
          groupPerson: groupPerson,
          date: date,
          hoursFact: hoursFact,
          isNoShow: isNoShow,
      );

  /// Исправление посещаемости
  Future<bool> updateAttendance(Attendance attendance) async {
    return await db.attendancesDao.update2(attendance);
  }

  /// Удаление посещаемости
  Future<bool> deleteAttendance(Attendance attendance) async {
    return await db.attendancesDao.delete2(attendance);
  }

  // Настройки -----------------------------------------------------------------
  Setting getSetting(String name) {
    return userSettings.value.firstWhere((e) => e.name == name);
  }

  get doubleTapInTimesheet => getSetting(L10n.doubleTapInTimesheet).boolValue;

  get useParusIntegration => getSetting(L10n.useParusIntegration).boolValue;

  get useIsNoShow => getSetting(L10n.isNoShow).boolValue;

  /// Исправление настройки
  Future<bool> updateSetting(Setting setting) async =>
      await db.settingsDao.update2(setting);

  /// Сброс базы данных
  reset() async {
    await db.reset();
    activeOrg.add(null);
    activeSchedule.add(null);
    activeGroup.add(null);
    activePeriod.add(null);
    activeYearDayOff.add(null);
    activeGroupPeriod.add(null);
    activeOrgPeriod.add(null);
    activeOrgs.add([]);
    activeSchedules.add([]);
    scheduleDays.add([]);
    activeGroups.add([]);
    groupPersons.add([]);
    groupPeriodPersons.add([]);
    meals.add([]);
    userSettings.add([]);
  }
}
