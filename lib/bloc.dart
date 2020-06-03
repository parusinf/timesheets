import 'package:timesheets/database/database.dart';
import 'package:moor/moor.dart';
import 'package:rxdart/rxdart.dart';
import 'package:injector/injector.dart';

/// Класс, в котором хранятся сведения о группе и о том, выбрана ли она
class GroupWithActiveInfo {
  GroupWithScheduleAndCount groupWithScheduleAndCount;
  bool isActive;

  GroupWithActiveInfo(this.groupWithScheduleAndCount, this.isActive);
}

/// Компонент бизнес логики (блок) приложения
class Bloc {
  final Database db;

  // Группа, которая выбрана в данный момент
  final BehaviorSubject<Group> activeGroup = BehaviorSubject();

  // Персоны в группе, которая выбрана в данный момент
  Stream<List<PersonOfGroup>> personsInActiveGroup;

  // Список групп
  final BehaviorSubject<List<GroupWithActiveInfo>> groups = BehaviorSubject();

  // Конструктор блока
  Bloc() : db = Injector.appInstance.getDependency<Database>() {
    // Отслеживание активной группы из настройки
    Rx.concat([db.watchActiveGroup()]).listen(activeGroup.add);

    // Отслеживание изменений в группе и отображение персон в ней
    personsInActiveGroup = activeGroup.switchMap(db.watchPersonsInGroup);

    // Отслеживание групп, чтобы они могли отображаться в дроувере
    Rx.combineLatest2<List<GroupWithScheduleAndCount>, Group, List<GroupWithActiveInfo>>(
      db.watchGroupsWithScheduleAndCount(),
      activeGroup,
      (groups, selected) =>
        groups.map((group) =>
          GroupWithActiveInfo(group, selected?.id == group?.id)
        ).toList()
    ).listen(groups.add);
  }

  // Отображение группы
  void showGroup(Group group) {
    activeGroup.add(group);
    db.setActiveGroup(group: group);
  }

  // Создание персоны и добавление её в выбранную группу
  void createPersonOfGroup({
    @required String family,
    @required String name,
    String middleName,
    DateTime birthday,
  }) async {
    final person = await db.createPerson(
        family: family,
        name: name,
        middleName: middleName,
        birthday: birthday,
    );
    await db.insertPersonIntoGroup(person: person, group: activeGroup.value);
  }

  // Освобождение ресурсов
  void close() {
    db.close();
    groups.close();
  }
}
