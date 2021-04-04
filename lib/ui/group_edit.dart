import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/schedules_dictionary.dart';
import 'package:timesheets/ui/group_persons_dictionary.dart';

/// Добавление группы
Future addGroup(BuildContext context) async {
  // Добавление группы
  final groupView = await push(context, GroupEdit(null));
  // Добавление персон в группу
  if (groupView != null) {
    await push(context, GroupPersonsDictionary());
  }
}

/// Исправление группы
Future editGroup(BuildContext context, GroupView groupView) async =>
  await push(context, GroupEdit(groupView));

/// Форма редактирования группы
class GroupEdit extends StatefulWidget {
  final GroupView groupView;
  final DataActionType actionType;
  const GroupEdit(this.groupView, {Key key})
      : this.actionType = groupView == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _GroupEditState createState() => _GroupEditState();
}

/// Состояние формы редактирования группы
class _GroupEditState extends State<GroupEdit> {
  final _nameEdit = TextEditingController();
  final _scheduleEdit = TextEditingController();
  Schedule _schedule;
  int _meals;

  get _bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _nameEdit.text = widget.groupView?.name;
    _schedule = widget.groupView?.schedule ?? _bloc.activeSchedule.value;
    _scheduleEdit.text = _schedule?.code;
    _meals = widget.groupView?.meals ?? 0; // 0 - Без питания, 1 - До 2 лет, 2 - От 3 лет
  }

  @override
  void dispose() {
    _nameEdit.dispose();
    _scheduleEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return form(
      title: L10n.group,
      onSubmit: _onSubmit,
      scaffoldKey: _scaffoldKey,
      formKey: _formKey,
      autovalidateMode: _autovalidateMode,
      fields: <Widget>[
        // Наименование группы
        textFormField(
          controller: _nameEdit,
          labelText: L10n.name,
          icon: Icons.group,
          validator: validateEmpty,
          textCapitalization: TextCapitalization.words,
          autofocus: widget.actionType == DataActionType.Insert ? true : false,
          maxLength: 20,
        ),
        // График
        textFormField(
          controller: _scheduleEdit,
          labelText: L10n.schedule,
          icon: Icons.calendar_today,
          onTap: _selectSchedule,
          validator: validateEmpty,
          readOnly: true,
        ),
        // Питание
        chooseFormField(
          initialValue: _meals,
          names: mealsNames,
          icon: Icons.restaurant,
          onChanged: (value, meals) {
            setState(() {
              _meals = value ? meals : -1;
            });
          },
        ),
      ],
    );
  }

  /// Выбор графика из словаря
  Future _selectSchedule() async {
    _schedule = await push(context, SchedulesDictionary())
        ?? _bloc.activeSchedule?.value;
    _scheduleEdit.text = _schedule?.code ?? _scheduleEdit.text;
  }

  /// Обработка формы
  Future _onSubmit() async {
    if (!_formKey.currentState.validate()) {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      try {
        if (widget.actionType == DataActionType.Insert) {
          final groupView = await _bloc.insertGroup(
            name: trim(_nameEdit.text),
            schedule: _schedule,
            meals: _meals,
          );
          Navigator.of(context).pop(groupView);
        } else {
          await _bloc.updateGroup(Group(
            id: widget.groupView.id,
            orgId: widget.groupView.orgId,
            name: trim(_nameEdit.text),
            scheduleId: _schedule?.id ?? widget.groupView.schedule,
            meals: _meals,
          ));
          Navigator.of(context).pop();
        }
      } catch(e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }
}
