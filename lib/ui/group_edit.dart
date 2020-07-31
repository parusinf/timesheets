import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/schedules_dictionary.dart';

/// Форма редактирования группы
class GroupEdit extends StatefulWidget {
  final GroupView groupView;
  final DataActionType actionType;
  const GroupEdit({Key key, this.groupView})
      : this.actionType = groupView == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
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
    schedule = widget.groupView?.schedule ?? bloc.activeSchedule.value;
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
      title: Text(widget.actionType == DataActionType.Insert
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
  Future _selectSchedule(BuildContext context) async {
    schedule = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => SchedulesDictionary()));
    _scheduleEdit.text = schedule?.code ?? bloc.activeSchedule.value.code;
  }

  /// Обработка формы
  Future _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      try {
        switch (widget.actionType) {
          case DataActionType.Insert:
            await bloc.insertGroup(
                name: stringValue(_nameEdit.text),
                schedule: schedule
            );
            break;
          case DataActionType.Update:
            await bloc.updateGroup(Group(
                id: widget.groupView.id,
                orgId: widget.groupView.orgId,
                name: stringValue(_nameEdit.text),
                scheduleId: schedule.id
            ));
            break;
          case DataActionType.Delete: break;
        }
        Navigator.of(context).pop();
      } catch(e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }

  /// Проверка наименования
  String _validateName(String value) {
    if (isEmpty(value)) {
      return L10n.of(context).noName;
    }
    return null;
  }

  /// Проверка графика
  String _validateSchedule(String value) {
    if (isEmpty(value)) {
      return L10n.of(context).noSchedule;
    }
    return null;
  }
}