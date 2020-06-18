import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/db/db.dart';

class AddGroupPage extends StatefulWidget {
  @override
  _AddGroupPageState createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(L10n.of(context).addingOfGroup),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: L10n.of(context).groupName,
            ),
            onSubmitted: (_) => _addGroup(),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text(L10n.of(context).done),
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
  void _addGroup() async {
    final org = bloc.activeOrgSubject.value;
    final schedule = Schedule(id: 1, code: 'пн,вт,ср,чт,пт 12ч');
    if (_controller.text.isNotEmpty) {
      final group = await bloc.db.groupsDao.create(
        org: org,
        name: _controller.text,
        schedule: schedule,
      );
      bloc.showGroup(group);
      Navigator.of(context).pop(); // закрыть диалог добавления
    }
  }
}
