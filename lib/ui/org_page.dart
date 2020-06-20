import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/db/db.dart';

class OrgPage extends StatefulWidget {
  final Org entry;
  const OrgPage({Key key, this.entry}) : super(key: key);
  @override
  _OrgPageState createState() => _OrgPageState();
}

class _OrgPageState extends State<OrgPage> {
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final TextEditingController _nameEdit = TextEditingController();
  final TextEditingController _innEdit = TextEditingController();

  @override
  void initState() {
    _nameEdit.text = widget.entry?.name;
    _innEdit.text = widget.entry?.inn;
    super.initState();
  }

  @override
  void dispose() {
    _nameEdit.dispose();
    _innEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.entry == null ?
          L10n.of(context).orgInserting : L10n.of(context).orgUpdating
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
              labelText: L10n.of(context).orgName,
            ),
            onSubmitted: (_) => widget.entry == null ? _insertOrg() : _updateOrg(),
          ),
          TextField(
            controller: _innEdit,
            autofocus: true,
            decoration: InputDecoration(
              labelText: L10n.of(context).inn,
            ),
            onSubmitted: (_) => widget.entry == null ? _insertOrg() : _updateOrg(),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text(L10n.of(context).done),
                textColor: Theme.of(context).accentColor,
                onPressed: widget.entry == null ? _insertOrg : _updateOrg,
              ),
            ],
          ),
        ],
      ),
    ),
  );

  /// Добавление организации
  void _insertOrg() {
    if (_nameEdit.text.isNotEmpty) {
      bloc.insertOrg(name: _nameEdit.text, inn: _innEdit.text);
      Navigator.of(context).pop();
    }
  }
  
  /// Исправление организации
  void _updateOrg() {
    if (_nameEdit.text.isNotEmpty) {
      bloc.updateOrg(org: widget.entry, name: _nameEdit.text, inn: _innEdit.text);
      Navigator.of(context).pop();
    }
  }
}
