import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/db/db.dart';
//import 'package:timesheets/widgets/timesheets_edit_dialog.dart';

/// Карточка, на которой отображается пользователь
/// и кнопка со значком для удаления этого пользователя из группы
class TimesheetCard extends StatelessWidget {
  final PersonOfGroup personOfGroup;
  TimesheetCard(this.personOfGroup) : super(key: ObjectKey(personOfGroup.id));

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(personOfGroup.family),
                  Text(personOfGroup.name),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit),
              color: Colors.lightBlue,
              onPressed: () {
                /*showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) => TodoEditDialog(person: person),
                );*/
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              color: Colors.red,
              onPressed: () => Provider.of<Bloc>(context, listen: false)
                  .db.pgLinksDao.del(personOfGroup)
            )
          ],
        ),
      ),
    );
  }
}
