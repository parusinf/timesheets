import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/core/l10n.dart';

class AddOrgPage extends StatefulWidget {
  @override
  _AddOrgPageState createState() => _AddOrgPageState();
}

class _AddOrgPageState extends State<AddOrgPage> {
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final TextEditingController _nameEdit = TextEditingController();
  final TextEditingController _innEdit = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(L10n.of(context).addingOfOrg),
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
              labelText: L10n.of(context).orgName,
            ),
            onSubmitted: (_) => _addOrg(),
          ),
          TextField(
            controller: _innEdit,
            autofocus: true,
            decoration: InputDecoration(
              labelText: L10n.of(context).inn,
            ),
            onSubmitted: (_) => _addOrg(),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text(L10n.of(context).done),
                textColor: Theme.of(context).accentColor,
                onPressed: _addOrg,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  /// Добавление группы
  void _addOrg() async {
    if (_nameEdit.text.isNotEmpty) {
      final org = await bloc.db.orgsDao.create(
        name: _nameEdit.text,
        inn: _innEdit.text,
      );
      bloc.showOrg(org);
      Navigator.of(context).pop(); // закрыть диалог добавления
    }
  }
}
