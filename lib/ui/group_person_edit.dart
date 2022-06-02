import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/persons_dictionary.dart';

/// Добавление персоны
Future addGroupPerson(BuildContext context) async =>
    push(context, const GroupPersonEdit(null));

/// Исправление персоны
Future editGroupPerson(
        BuildContext context, GroupPersonView groupPerson) async =>
    push(context, GroupPersonEdit(groupPerson));

/// Форма редактирования персоны в группе
class GroupPersonEdit extends StatefulWidget {
  final GroupPersonView? groupPerson;
  final DataActionType actionType;
  const GroupPersonEdit(this.groupPerson, {Key? key})
      : actionType =
            groupPerson == null ? DataActionType.insert : DataActionType.update,
        super(key: key);
  @override
  GroupPersonEditState createState() => GroupPersonEditState();
}

/// Состояние формы редактирования персоны в группе
class GroupPersonEditState extends State<GroupPersonEdit> {
  final _personEdit = TextEditingController();
  final _beginDateEdit = TextEditingController();
  final _endDateEdit = TextEditingController();
  Person? _person;

  get bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _person = widget.groupPerson?.person;
    _personEdit.text = personFullName(_person) ?? '';
    _beginDateEdit.text = dateToString(widget.groupPerson?.beginDate);
    _endDateEdit.text = dateToString(widget.groupPerson?.endDate);
  }

  @override
  void dispose() {
    _personEdit.dispose();
    _beginDateEdit.dispose();
    _endDateEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return form(
      title: L10n.binding,
      scaffoldKey: _scaffoldKey,
      formKey: _formKey,
      autovalidateMode: _autovalidateMode,
      onSubmit: _onSubmit,
      fields: <Widget>[
        // Персона
        textFormField(
          controller: _personEdit,
          labelText: L10n.person,
          icon: Icons.person,
          onTap: _selectPerson,
          validator: validateEmpty,
          autofocus: widget.actionType == DataActionType.insert ? true : false,
          readOnly: true,
        ),
        // Дата поступления в группу
        dateFormField(
          controller: _beginDateEdit,
          labelText: L10n.beginDate,
        ),
        // Дата дата выбытия из группы
        dateFormField(
          controller: _endDateEdit,
          labelText: L10n.endDate,
        ),
      ],
    );
  }

  /// Выбор персоны из словаря
  Future _selectPerson() async {
    _person = await push(context, const PersonsDictionary());
    _personEdit.text =
        _person != null ? personFullName(_person)! : _personEdit.text;
  }

  /// Обработка формы
  Future _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      try {
        if (widget.actionType == DataActionType.insert) {
          await bloc.insertGroupPerson(
            group: bloc.activeGroup.valueWrapper?.value,
            person: _person,
            beginDate: stringToDateOrNull(_beginDateEdit.text),
            endDate: stringToDateOrNull(_endDateEdit.text),
          );
        } else {
          await bloc.updateGroupPerson(GroupPersonView(
            id: widget.groupPerson?.id ?? 0,
            groupId: widget.groupPerson?.groupId ?? 0,
            person: _person ?? widget.groupPerson!.person,
            beginDate: stringToDateOrNull(_beginDateEdit.text),
            endDate: stringToDateOrNull(_endDateEdit.text),
          ));
        }
        if (!mounted) return;
        Navigator.of(context).pop();
      } catch (e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }
}
