import 'package:timesheets/db/db.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart';

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
  // База данных
  final Db db;

  // Активная организация
  final activeOrg = BehaviorSubject<Org>();

  // Активный график
  final activeSchedule = BehaviorSubject<Schedule>();

  // Активная группа
  final activeGroup = BehaviorSubject<Group>();

  // Активный период
  final activePeriod = BehaviorSubject<DateTime>();

  // Организации с признаком активности
  final activeOrgList = BehaviorSubject<List<ActiveOrg>>();

  // Графики с признаком активности
  final activeScheduleList = BehaviorSubject<List<ActiveSchedule>>();

  // Дни активного графика
  final scheduleDayList = BehaviorSubject<List<ScheduleDay>>();

  // Группы с признаком активности
  final activeGroupList = BehaviorSubject<List<ActiveGroup>>();

  // Группы активной организации
  Stream<List<GroupView>> groupList;

  // Персоны активной группы
  Stream<List<GroupPerson>> groupPersonList;

  /// Конструктор блока
  Bloc() : db = Db() {
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
        .listen(scheduleDayList.add);

    // Отслеживание групп в активной организации
    groupList = activeOrg.switchMap(db.groupsDao.watch);

    // Формирование признака активности организаций
    Rx.combineLatest2<List<Org>, Org, List<ActiveOrg>>(
      db.orgsDao.watch(),
      activeOrg,
      (orgs, selected) => orgs.map(
        (org) => ActiveOrg(org, org?.id == selected?.id)).toList()
    ).listen(activeOrgList.add);

    // Формирование признака активности графиков
    Rx.combineLatest2<List<Schedule>, Schedule, List<ActiveSchedule>>(
      db.schedulesDao.watch(),
      activeSchedule,
      (schedules, selected) => schedules.map(
        (schedule) => ActiveSchedule(schedule, schedule?.id == selected?.id)
      ).toList()
    ).listen(activeScheduleList.add);

    // Формирование признака активности групп
    Rx.combineLatest2<List<GroupView>, Group, List<ActiveGroup>>(
      groupList,
      activeGroup,
      (groups, selected) => groups.map(
        (group) => ActiveGroup(group, group?.id == selected?.id)
      ).toList()
    ).listen(activeGroupList.add);

    // Отслеживание персон в активной группе
    groupPersonList = activeGroup.switchMap(db.groupPersonLinksDao.watch);
  }

  /// Освобождение ресурсов
  void close() {
    activeOrg.close();
    activeSchedule.close();
    activeGroup.close();
    activePeriod.close();
    activeOrgList.close();
    activeScheduleList.close();
    activeGroupList.close();
    scheduleDayList.close();
    db.close();
  }

  // Организации ---------------------------------------------------------------
  /// Установка активной организации
  Future setActiveOrg(Org org) async =>
    await db.settingsDao.setActiveOrg(org);

  /// Добавление организации
  Future<Org> insertOrg({
    @required String name,
    String inn,
  }) async {
    final org = await db.orgsDao.insert2(name: name, inn: inn);
    setActiveOrg(org);
    return org;
  }

  /// Исправление организации
  Future<bool> updateOrg(Org org) async =>
    await db.orgsDao.update2(org);

  /// Удаление организации
  Future<bool> deleteOrg(Org org) async {
    final result = db.orgsDao.delete2(org);
    final previousOrg = await db.orgsDao.getPreviousOrg(org);
    setActiveOrg(previousOrg);
    return result;
  }

  // Графики -------------------------------------------------------------------
  /// Установка активного графика
  Future setActiveSchedule(Schedule schedule) async =>
    await db.settingsDao.setActiveSchedule(schedule);

  /// Добавление графика
  Future<Schedule> insertSchedule({
    @required String code,
  }) async {
    final schedule = await db.schedulesDao.insert2(code: code);
    setActiveSchedule(schedule);
    return schedule;
  }

  /// Исправление графика
  Future<bool> updateSchedule(Schedule schedule) async =>
    await db.schedulesDao.update2(schedule);

  /// Удаление графика
  Future<bool> deleteSchedule(Schedule schedule) async {
    final result = db.schedulesDao.delete2(schedule);
    final previousSchedule = await db.schedulesDao.getPreviousSchedule(schedule);
    setActiveSchedule(previousSchedule);
    return result;
  }

  // Группы --------------------------------------------------------------------
  /// Установка активной группы
  Future setActiveGroup(Group group) async =>
    await db.settingsDao.setActiveGroup(activeOrg.value, group);

  /// Добавление группы
  Future<Group> insertGroup({
    @required String name,
    @required Schedule schedule,
  }) async {
    final group = await db.groupsDao.insert2(
      org: activeOrg.value,
      name: name,
      schedule: schedule,
    );
    setActiveGroup(group);
    return group;
  }

  /// Исправление группы
  Future<bool> updateGroup(Group group) async =>
    await db.groupsDao.update2(group);

  /// Удаление группы
  Future<bool> deleteGroup(Group group) async {
    final result = db.groupsDao.delete2(group);
    final previousGroup = await db.groupsDao.getPreviousGroup(
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
  }) async {
    final person = await db.personsDao.insert2(
        family: family,
        name: name,
        middleName: middleName,
        birthday: birthday,
    );
    //db.groupPersonLinksDao.insert2(group: activeGroup.value, person: person);
    return person;
  }
}
