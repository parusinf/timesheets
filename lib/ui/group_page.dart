import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/db/db.dart';

class GroupPage extends StatefulWidget {
  final Group entry;
  const GroupPage({Key key, this.entry}) : super(key: key);
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final TextEditingController _nameEdit = TextEditingController();

  @override
  void initState() {
    _nameEdit.text = widget.entry?.name;
    super.initState();
  }

  @override
  void dispose() {
    _nameEdit.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.entry == null ?
          L10n.of(context).groupInserting : L10n.of(context).groupUpdating
      ),
    ),
    body: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            controller: _nameEdit,
            autofocus: true,
            decoration: InputDecoration(
              labelText: L10n.of(context).groupName,
            ),
            onSubmitted: (_) => widget.entry == null ? _insertGroup() : _updateGroup()
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text(L10n.of(context).done),
                textColor: Theme.of(context).accentColor,
                onPressed: widget.entry == null ? _insertGroup : _updateGroup,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  /// Добавление группы
  void _insertGroup() async {
    if (_nameEdit.text.isNotEmpty) {
      bloc.insertGroup(name: _nameEdit.text,
          schedule: Schedule(id: 1, code: 'пн,вт,ср,чт,пт 12ч'));
      Navigator.of(context).pop();
    }
  }

  /// Исправление группы
  void _updateGroup() {
    if (_nameEdit.text.isNotEmpty) {
      bloc.updateGroup(group: widget.entry, name: _nameEdit.text,
          schedule: Schedule(id: 1, code: 'пн,вт,ср,чт,пт 12ч'));
      Navigator.of(context).pop();
    }
  }
}
