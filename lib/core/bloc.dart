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
  final activeGroup = BehaviorSubject<GroupView>();

  // Активный период
  final activePeriod = BehaviorSubject<DateTime>();

  // Активная группа и период
  final activeGroupPeriod = BehaviorSubject<GroupPeriod>();
  
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

  // Группы активной организации
  Stream<List<GroupView>> groups;

  // Посещаемость персон активной группы в активном периоде
  Stream<List<Attendance>> attendances;

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
        .listen(scheduleDays.add);

    // Отслеживание групп в активной организации
    groups = activeOrg.switchMap(db.groupsDao.watch);

    // Отслеживание активной группы и периода
    Rx.combineLatest2<Group, DateTime, GroupPeriod>(
        activeGroup,
        activePeriod,
        (group, period) => GroupPeriod(group, period)
    ).listen(activeGroupPeriod.add);

    // Отслеживание групп в активной организации
    attendances = activeGroupPeriod.switchMap(db.attendancesDao.watch);

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
    Rx.concat([activeGroup.switchMap(db.groupPersonLinksDao.watch)])
        .listen(groupPersons.add);
  }

  /// Освобождение ресурсов
  void close() {
    activeOrg.close();
    activeSchedule.close();
    activeGroup.close();
    activePeriod.close();
    activeGroupPeriod.close();
    activeOrgs.close();
    activeSchedules.close();
    activeGroups.close();
    scheduleDays.close();
    groupPersons.close();
    db.close();
  }

  // Активный период -----------------------------------------------------------
  /// Установка активного периода
  Future setActivePeriod(DateTime period) async =>
      await db.settingsDao.setActivePeriod(period);

  // Организации ---------------------------------------------------------------
  /// Установка активной организации
  Future setActiveOrg(Org org) async =>
    await db.settingsDao.setActiveOrg(org);

  /// Добавление организации
  Future<Org> insertOrg({@required String name, String inn}) async {
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
  Future<Schedule> insertSchedule({@required String code}) async {
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
  /// Установка активной группы и установка активным её графика 
  Future setActiveGroup(Group group) async {
    db.settingsDao.setActiveGroup(activeOrg.value, group);
    if (group != null) {
      final schedule = await db.schedulesDao.getSchedule(group.scheduleId);
      setActiveSchedule(schedule);
    }
  }

  /// Добавление группы
  Future<Group> insertGroup({@required String name, @required Schedule schedule}) async {
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
  }) async => await db.personsDao.insert2(
    family: family,
    name: name,
    middleName: middleName,
    birthday: birthday,
  );

  /// Исправление персоны
  Future<bool> updatePerson(Person person) async =>
      await db.personsDao.update2(person);

  /// Удаление персоны
  Future<bool> deletePerson(Person person) async =>
      await db.personsDao.delete2(person);

  /// Добавление персоны в группу
  Future<GroupPersonView> addPersonToGroup(Group group, Person person) async =>
      await db.groupPersonLinksDao.insert2(group, person);

  /// Удаление персоны из группы
  Future<bool> deletePersonFromGroup(GroupPersonView groupPerson) async =>
      await db.groupPersonLinksDao.delete2(groupPerson);
  
  // Посещаемость --------------------------------------------------------------
  /// Добавление посещаемости
  Future<Attendance> insertAttendance({
    @required GroupPersonView groupPerson,
    @required DateTime date,
    @required double hoursFact,
  }) async => await db.attendancesDao.insert2(
    groupPerson: groupPerson,
    date: date,
    hoursFact: hoursFact,
  );

  /// Удаление посещаемости
  Future<bool> deleteAttendance(Attendance attendance) async =>
      await db.attendancesDao.delete2(attendance);
}