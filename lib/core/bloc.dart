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
  final BehaviorSubject<Org> activeOrgSubject = BehaviorSubject();
  // Активный график
  final BehaviorSubject<Schedule> activeScheduleSubject = BehaviorSubject();
  // Активная группа
  final BehaviorSubject<Group> activeGroupSubject = BehaviorSubject();
  // Активный период
  final BehaviorSubject<DateTime> activePeriodSubject = BehaviorSubject();
  // Организации с признаком активности
  final BehaviorSubject<List<ActiveOrg>> activeOrgsSubject = BehaviorSubject();
  // Графики с признаком активности
  final BehaviorSubject<List<ActiveSchedule>> activeSchedulesSubject = BehaviorSubject();
  // Группы с признаком активности
  final BehaviorSubject<List<ActiveGroup>> activeGroupsSubject = BehaviorSubject();
  // Группы активной организации
  Stream<List<GroupView>> groupsStream;
  // Персоны активной группы
  Stream<List<GroupPerson>> groupPersonsStream;

  /// Конструктор блока
  Bloc() : db = Db() {
    // Отслеживание активной организации из настройки
    Rx.concat([db.settingsDao.watchActiveOrg()])
        .listen(activeOrgSubject.add);
    // Отслеживание активного графика из настройки
    Rx.concat([db.settingsDao.watchActiveSchedule()])
        .listen(activeScheduleSubject.add);
    // Отслеживание активной группы организации
    Rx.concat([activeOrgSubject.switchMap(db.settingsDao.watchActiveGroup)])
        .listen(activeGroupSubject.add);
    // Отслеживание активного периода из настройки
    Rx.concat([db.settingsDao.watchActivePeriod()])
        .listen(activePeriodSubject.add);
    // Отслеживание групп в активной организации
    groupsStream = activeOrgSubject.switchMap(db.groupsDao.watch);
    // Формирование признака активности организаций
    Rx.combineLatest2<List<Org>, Org, List<ActiveOrg>>(
      db.orgsDao.watch(),
      activeOrgSubject,
      (orgs, selected) => orgs.map(
        (org) => ActiveOrg(org, org?.id == selected?.id)).toList()
    ).listen(activeOrgsSubject.add);
    // Формирование признака активности графиков
    Rx.combineLatest2<List<Schedule>, Schedule, List<ActiveSchedule>>(
      db.schedulesDao.watch(),
      activeScheduleSubject,
      (schedules, selected) => schedules.map(
        (schedule) => ActiveSchedule(schedule, schedule?.id == selected?.id)
      ).toList()
    ).listen(activeSchedulesSubject.add);
    // Формирование признака активности групп
    Rx.combineLatest2<List<GroupView>, Group, List<ActiveGroup>>(
      groupsStream,
      activeGroupSubject,
      (groups, selected) => groups.map(
        (group) => ActiveGroup(group, group?.id == selected?.id)
      ).toList()
    ).listen(activeGroupsSubject.add);
    // Отслеживание персон в активной группе
    groupPersonsStream = activeGroupSubject.switchMap(db.groupPersonLinksDao.watch);
  }

  /// Отображение организации
  void showOrg(Org org) {
    activeOrgSubject.add(org);
    db.settingsDao.setActiveOrg(org);
  }

  /// Добавление организации
  void insertOrg({
    @required String name,
    String inn,
  }) async {
    final org = await db.orgsDao.insert2(
      name: name,
      inn: inn,
    );
    showOrg(org);
  }

  /// Исправление организации
  void updateOrg(Org org) {
    db.orgsDao.update2(org);
  }

  /// Удаление организации
  void deleteOrg(Org org) async {
    db.orgsDao.delete2(org);
    final previousOrg = await db.orgsDao.getPreviousOrg(org);
    showOrg(previousOrg);
  }

  /// Отображение графика
  void showSchedule(Schedule schedule) {
    activeScheduleSubject.add(schedule);
    db.settingsDao.setActiveSchedule(schedule);
  }

  /// Добавление графика
  void insertSchedule({
    @required String code,
  }) async {
    final schedule = await db.schedulesDao.insert2(code: code);
    showSchedule(schedule);
  }

  /// Исправление графика
  void updateSchedule(Schedule schedule) {
    db.schedulesDao.update2(schedule);
  }

  /// Удаление графика
  void deleteSchedule(Schedule schedule) async {
    db.schedulesDao.delete2(schedule);
    final previousSchedule = await db.schedulesDao.getPreviousSchedule(schedule);
    showSchedule(previousSchedule);
  }

  /// Отображение группы
  void showGroup(Group group) {
    activeGroupSubject.add(group);
    db.settingsDao.setActiveGroup(activeOrgSubject.value, group);
  }

  /// Добавление группы
  void insertGroup({
    @required String name,
    @required Schedule schedule,
  }) async {
    final group = await db.groupsDao.insert2(
      org: activeOrgSubject.value,
      name: name,
      schedule: schedule,
    );
    showGroup(group);
  }

  /// Исправление группы
  void updateGroup(Group group) {
    db.groupsDao.update2(group);
  }

  /// Удаление группы
  void deleteGroup(Group group) async {
    db.groupsDao.delete2(group);
    final previousGroup = await db.groupsDao.getPreviousGroup(
        activeOrgSubject.value, group);
    showGroup(previousGroup);
  }

  /// Создание персоны и добавление её в выбранную группу
  void createPersonOfGroup({
    @required String family,
    @required String name,
    String middleName,
  }) async {
    final person = await db.personsDao.insert2(
        family: family,
        name: name,
        middleName: middleName,
    );
    db.groupPersonLinksDao.insert2(person: person, group: activeGroupSubject.value);
  }
  
  /// Освобождение ресурсов
  void close() {
    activeOrgSubject.close();
    activeScheduleSubject.close();
    activeGroupSubject.close();
    activePeriodSubject.close();
    activeOrgsSubject.close();
    activeSchedulesSubject.close();
    activeGroupsSubject.close();
    db.close();
  }
}
