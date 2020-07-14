import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/db/db.dart';

class GroupPage extends StatefulWidget {
  final GroupView entry;
  const GroupPage({Key key, this.entry}) : super(key: key);
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final TextEditingController _nameEdit = TextEditingController();
  final TextEditingController _scheduleEdit = TextEditingController();

  @override
  void initState() {
    _nameEdit.text = widget.entry?.name;
    _scheduleEdit.text = widget.entry?.schedule?.code;
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
      title: Text(widget.entry == null
          ? L10n.of(context).groupInserting
          : L10n.of(context).groupUpdating
      ),
    ),
    body: Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Scrollbar(
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameEdit,
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.group),
                  labelText: L10n.of(context).groupName,
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _scheduleEdit,
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.calendar_today),
                  labelText: L10n.of(context).schedule,
                ),
                validator: _validateSchedule,
              ),
              const SizedBox(height: 16),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    child: Text(L10n.of(context).done),
                    onPressed: _handleSubmitted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Обработка формы
  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      if (widget.entry == null) {
        _insert();
      } else {
        _update();
      }
    }
  }

  /// Проверка наименования
  String _validateName(String value) {
    if (value.isEmpty) {
      return L10n.of(context).noName;
    }
    return null;
  }

  /// Проверка графика
  String _validateSchedule(String value) {
    if (value.isEmpty) {
      return L10n.of(context).noSchedule;
    }
    return null;
  }

  /// Добавление группы
  void _insert() {
    if (_nameEdit.text.isNotEmpty) {
      bloc.insertGroup(name: _nameEdit.text,
          schedule: Schedule(id: 1, code: 'пн,вт,ср,чт,пт 12ч'));
      Navigator.of(context).pop();
    }
  }

  /// Исправление группы
  void _update() {
    if (_nameEdit.text.isNotEmpty) {
      bloc.updateGroup(group: widget.entry, name: _nameEdit.text,
          schedule: Schedule(id: 1, code: 'пн,вт,ср,чт,пт 12ч'));
      Navigator.of(context).pop();
    }
  }
}
