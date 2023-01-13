import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/schedules_dictionary.dart';

/// Добавление группы
Future addGroup(BuildContext context) async {
  // Добавление группы
  return await push(context, const GroupEdit(null));
}

/// Исправление группы
Future editGroup(BuildContext context, GroupView groupView) async =>
    await push(context, GroupEdit(groupView));

/// Форма редактирования группы
class GroupEdit extends StatefulWidget {
  final GroupView? groupView;
  final DataActionType actionType;
  const GroupEdit(this.groupView, {Key? key})
      : actionType = groupView == null ? DataActionType.insert : DataActionType.update,
        super(key: key);
  @override
  GroupEditState createState() => GroupEditState();
}

/// Состояние формы редактирования группы
class GroupEditState extends State<GroupEdit> {
  final _nameEdit = TextEditingController();
  final _scheduleEdit = TextEditingController();
  Schedule? _schedule;
  int? _meals;

  get _bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _nameEdit.text = widget.groupView?.name ?? '';
    _schedule = widget.groupView?.schedule ?? _bloc.activeSchedule.valueOrNull;
    _scheduleEdit.text = _schedule?.code ?? '';
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
        textFormField(
          controller: _nameEdit,
          labelText: L10n.name,
          icon: Icons.group,
          validator: validateEmpty,
          textCapitalization: TextCapitalization.words,
          autofocus: widget.actionType == DataActionType.insert ? true : false,
          maxLength: 20,
        ),
        textFormField(
          controller: _scheduleEdit,
          labelText: L10n.schedule,
          icon: Icons.calendar_today,
          onTap: _selectSchedule,
          validator: validateEmpty,
          readOnly: true,
        ),
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
    _schedule = await push(context, const SchedulesDictionary()) ??
        _bloc.activeSchedule?.valueOrNull;
    _scheduleEdit.text = _schedule?.code ?? _scheduleEdit.text;
  }

  /// Обработка формы
  Future _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      try {
        if (widget.actionType == DataActionType.insert) {
          final groupView = await _bloc.insertGroup(
            name: trim(_nameEdit.text),
            schedule: _schedule,
            meals: _meals,
          );
          if (!mounted) return;
          Navigator.of(context).pop(groupView);
        } else {
          await _bloc.updateGroup(Group(
            id: widget.groupView?.id ?? 0,
            orgId: widget.groupView?.orgId ?? 0,
            name: trim(_nameEdit.text) ?? '',
            scheduleId: _schedule?.id ?? widget.groupView?.schedule?.id ?? 0,
            meals: _meals,
          ));
          if (!mounted) return;
          Navigator.of(context).pop();
        }
      } catch (e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }
}
