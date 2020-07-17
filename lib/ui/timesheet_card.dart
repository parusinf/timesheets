import 'package:flutter/material.dart';
import 'package:timesheets/db/db.dart';

/// Карточка, на которой отображается пользователь
/// и кнопка со значком для удаления этого пользователя из группы
class TimesheetCard extends StatelessWidget {
  final GroupPerson personOfGroup;
  TimesheetCard(this.personOfGroup) : super(key: ObjectKey(personOfGroup.id));

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(personOfGroup.family),
    subtitle: Text('${personOfGroup.name} ${personOfGroup.middleName}'),
  );
}
