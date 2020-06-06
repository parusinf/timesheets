import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/db/db.dart';

class AddGroupDialog extends StatefulWidget {
  @override
  _AddGroupDialogState createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Dialog(
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              L10n.of(context).addingOfGroup,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: L10n.of(context).groupName,
            ),
            onSubmitted: (_) => _addGroup(),
          ),
          /*Row(

          ),*/
          ButtonBar(
            children: [
              FlatButton(
                child: Text(L10n.of(context).cancel),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(L10n.of(context).ok),
                textColor: Theme.of(context).accentColor,
                onPressed: _addGroup,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  /// Добавление группы
  void _addGroup() {
    final schedule = Schedule(id: 1, code: 'пн,вт,ср,чт,пт 12ч');
    if (_controller.text.isNotEmpty) {
      bloc.db.groupsDao.create(
        name: _controller.text,
        schedule: schedule,
      );
      Navigator.of(context).pop();
    }
  }
}
