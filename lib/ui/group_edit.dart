import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/schedules_dictionary.dart';

/// Форма редактирования группы
class GroupEdit extends StatefulWidget {
  final GroupView groupView;
  const GroupEdit({Key key, this.groupView}) : super(key: key);
  @override
  _GroupEditState createState() => _GroupEditState();
}

/// Состояние формы редактирования группы
class _GroupEditState extends State<GroupEdit> {
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameEdit = TextEditingController();
  final _scheduleEdit = TextEditingController();
  Schedule schedule;
  bool _autoValidate = false;

  @override
  void initState() {
    _nameEdit.text = widget.groupView?.name;
    final activeSchedule = bloc.activeSchedule.value;
    schedule = widget.groupView?.schedule ?? activeSchedule;
    _scheduleEdit.text = schedule.code;
    super.initState();
  }

  @override
  void dispose() {
    _nameEdit.dispose();
    _scheduleEdit.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(widget.groupView == null
          ? L10n.of(context).groupInserting
          : L10n.of(context).groupUpdating
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.done),
          tooltip: L10n.of(context).done,
          onPressed: _handleSubmitted,
        ),
      ],
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
              horizontalSpace,
              // Наименование группы
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
              horizontalSpace,
              // График
              TextFormField(
                controller: _scheduleEdit,
                readOnly: true,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.calendar_today),
                  labelText: L10n.of(context).schedule,
                ),
                validator: _validateSchedule,
                onTap: () => _selectSchedule(context),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Выбор графика из словаря
  void _selectSchedule(BuildContext context) async {
    schedule = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SchedulesDictionary()),
    );
    _scheduleEdit.text = schedule?.code ?? bloc.activeSchedule.value.code;
  }

  /// Обработка формы
  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      if (widget.groupView == null) {
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
  Future _insert() async {
    try {
      await bloc.insertGroup(name: _nameEdit.text, schedule: schedule);
      Navigator.of(context).pop();
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Исправление группы
  Future _update() async {
    try {
      await bloc.updateGroup(widget.groupView.copyWith(name: _nameEdit.text,
          scheduleId: schedule.id));
      Navigator.of(context).pop();
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }
}