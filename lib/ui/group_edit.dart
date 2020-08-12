import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:provider/provider.dart';
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
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameEdit = TextEditingController();
  final _scheduleEdit = TextEditingController();
  Schedule schedule;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _nameEdit.text = widget.groupView?.name;
    schedule = widget.groupView?.schedule ?? bloc.activeSchedule.value;
    _scheduleEdit.text = schedule?.code;
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
          ? l10n.groupInserting
          : l10n.groupUpdating
      ),
      actions: <Widget>[
        IconButton(icon: const Icon(Icons.done), onPressed: _handleSubmitted),
      ],
    ),
    body: Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Scrollbar(
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          padding: const EdgeInsets.symmetric(horizontal: padding),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              horizontalSpace(),
              // Наименование группы
              TextFormField(
                controller: _nameEdit,
                autofocus: widget.actionType == DataActionType.Insert ? true : false,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  icon: const Icon(Icons.group),
                  labelText: l10n.groupName,
                ),
                validator: _validateName,
              ),
              horizontalSpace(),
              // График
              TextFormField(
                controller: _scheduleEdit,
                readOnly: true,
                decoration: InputDecoration(
                  icon: const Icon(Icons.calendar_today),
                  labelText: l10n.schedule,
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
    schedule = await push(context, SchedulesDictionary());
    _scheduleEdit.text = schedule?.code ?? bloc.activeSchedule?.value?.code ?? '';
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
      return l10n.noName;
    }
    return null;
  }

  /// Проверка графика
  String _validateSchedule(String value) {
    if (isEmpty(value)) {
      return l10n.noSchedule;
    }
    return null;
  }
}