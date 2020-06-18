import 'package:timesheets/db/db.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart';

/// Организация с признаком активности
class ActiveOrg {
  OrgView orgView;
  bool isActive;
  ActiveOrg(this.orgView, this.isActive);
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
  // Активная группа
  final BehaviorSubject<Group> activeGroupSubject = BehaviorSubject();
  // Активный период
  final BehaviorSubject<DateTime> activePeriodSubject = BehaviorSubject();
  // Организации с признаком активности
  final BehaviorSubject<List<ActiveOrg>> activeOrgsSubject = BehaviorSubject();
  // Группы с признаком активности
  final BehaviorSubject<List<ActiveGroup>> activeGroupsSubject = BehaviorSubject();
  // Группы активной организации
  Stream<List<GroupView>> groupsStream;
  // Персоны активной группы
  Stream<List<GroupPerson>> groupPersonsStream;

  // Конструктор блока
  Bloc() : db = Db() {
    // Отслеживание активной организации из настройки
    Rx.concat([db.settingsDao.watchActiveOrg()])
        .listen(activeOrgSubject.add);
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
        (orgs, selected) =>
            orgs.map((org) =>
                ActiveOrg(org, org?.id == selected?.id)
            ).toList()
    ).listen(activeOrgsSubject.add);
    // Формирование признака активности групп
    Rx.combineLatest2<List<GroupView>, Group, List<ActiveGroup>>(
        groupsStream,
        activeGroupSubject,
        (groups, selected) =>
            groups.map((group) =>
                ActiveGroup(group, group?.id == selected?.id)
            ).toList()
    ).listen(activeGroupsSubject.add);
    // Отслеживание персон в активной группе
    groupPersonsStream = activeGroupSubject.switchMap(db.pgLinksDao.watch);
  }

  // Отображение организации
  void showOrg(Org org) {
    activeOrgSubject.add(org);
    db.settingsDao.setActiveOrg(org);
  }

  // Отображение группы
  void showGroup(Group group) {
    activeGroupSubject.add(group);
    db.settingsDao.setActiveGroup(activeOrgSubject.value, group);
  }

  // Создание персоны и добавление её в выбранную группу
  void createPersonOfGroup({
    @required String family,
    @required String name,
    String middleName,
  }) async {
    final person = await db.personsDao.create(
        family: family,
        name: name,
        middleName: middleName,
    );
    db.pgLinksDao.create(person: person, group: activeGroupSubject.value);
  }
  
  // Освобождение ресурсов
  void close() {
    db.close();
    activeOrgSubject.close();
    activeGroupSubject.close();
    activePeriodSubject.close();
    activeOrgsSubject.close();
    activeGroupsSubject.close();
  }
}
