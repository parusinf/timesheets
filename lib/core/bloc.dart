import 'package:timesheets/db/db.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart';

/// Организация с признаком активности
class ActiveOrganization {
  Organization organization;
  bool isActive;
  ActiveOrganization(this.organization, this.isActive);
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
  final BehaviorSubject<Organization> activeOrganizationStream = BehaviorSubject();
  // Активная группа
  final BehaviorSubject<Group> activeGroupStream = BehaviorSubject();
  // Активный период
  final BehaviorSubject<DateTime> activePeriodStream = BehaviorSubject();
  // Группы активной организации
  Stream<List<GroupView>> groupsStream;
  // Организации с признаком активности
  final BehaviorSubject<List<ActiveOrganization>> activeOrganizationsStream = BehaviorSubject();
  // Группы с признаком активности
  final BehaviorSubject<List<ActiveGroup>> activeGroupsStream = BehaviorSubject();
  // Персоны активной группы
  Stream<List<GroupPerson>> groupPersonsStream;

  // Конструктор блока
  Bloc() : db = Db() {
    // Отслеживание активной организации из настройки
    Rx.concat([db.settingsDao.watchActiveOrganization()])
        .listen(activeOrganizationStream.add);
    // Отслеживание активной группы из настройки
    Rx.concat([db.settingsDao.watchActiveGroup()])
        .listen(activeGroupStream.add);
    // Отслеживание активного периода из настройки
    Rx.concat([db.settingsDao.watchActivePeriod()])
        .listen(activePeriodStream.add);
    // Отслеживание групп в активной организации
    groupsStream = activeOrganizationStream.switchMap(db.groupsDao.watch);
    // Формирование признака активности организаций
    Rx.combineLatest2<List<Organization>, Organization, List<ActiveOrganization>>(
        db.organizationsDao.watch(),
        activeOrganizationStream,
        (organizations, selected) =>
            organizations.map((organization) =>
                ActiveOrganization(organization, organization?.id == selected?.id)
            ).toList()
    ).listen(activeOrganizationsStream.add);
    // Формирование признака активности групп
    Rx.combineLatest2<List<GroupView>, Group, List<ActiveGroup>>(
        groupsStream,
        activeGroupStream,
        (groups, selected) =>
            groups.map((group) =>
                ActiveGroup(group, group?.id == selected?.id)
            ).toList()
    ).listen(activeGroupsStream.add);
    // Отслеживание персон в активной группе
    groupPersonsStream = activeGroupStream.switchMap(db.pgLinksDao.watch);
  }

  // Отображение группы
  void showGroup(Group group) {
    activeGroupStream.add(group);
    db.settingsDao.setActiveGroup(group);
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
    db.pgLinksDao.create(person: person, group: activeGroupStream.value);
  }
  
  // Освобождение ресурсов
  void close() {
    db.close();
    activeOrganizationStream.close();
    activeGroupStream.close();
    activePeriodStream.close();
    activeOrganizationsStream.close();
    activeGroupsStream.close();
  }
}
