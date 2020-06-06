import 'package:timesheets/db/db.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart';

/// Представление группы с признаком активности
class GroupIsActive {
  GroupView groupView;
  bool isActive;

  GroupIsActive(this.groupView, this.isActive);
}

/// Компонент бизнес логики (блок) приложения
class Bloc {
  // База данных
  final Db db;
  // Текущий период
  final BehaviorSubject<DateTime> activePeriodStream = BehaviorSubject();
  // Группа, которая выбрана в данный момент
  final BehaviorSubject<Group> activeGroupStream = BehaviorSubject();
  // Список групп
  final BehaviorSubject<List<GroupIsActive>> groupsStream = BehaviorSubject();
  // Персоны в группе, которая выбрана в данный момент
  Stream<List<PersonOfGroup>> personsInActiveGroupStream;

  // Конструктор блока
  Bloc() : db = Db() {
    // Отслеживание активного периода из настройки
    Rx.concat([db.settingsDao.watchActivePeriod()]).listen(activePeriodStream.add);
    // Отслеживание активной группы из настройки
    Rx.concat([db.settingsDao.watchActiveGroup()]).listen(activeGroupStream.add);
    // Отслеживание изменений в группе и отображение персон в ней
    personsInActiveGroupStream = activeGroupStream.switchMap(db.pgLinksDao.watch);
    // Отслеживание групп, чтобы они могли отображаться в дроувере
    Rx.combineLatest2<List<GroupView>, Group, List<GroupIsActive>>(
      db.groupsDao.watch(),
      activeGroupStream,
      (groups, selected) =>
        groups.map((group) =>
          GroupIsActive(group, selected?.id == group?.id)
        ).toList()
    ).listen(groupsStream.add);
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
    activePeriodStream.close();
    activeGroupStream.close();
    groupsStream.close();
  }
}
