import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/persons_dictionary.dart';

/// Добавление персоны
Future addGroupPerson(BuildContext context) async =>
    push(context, GroupPersonEdit(null));

/// Исправление персоны
Future editGroupPerson(BuildContext context, GroupPersonView groupPerson) async =>
    push(context, GroupPersonEdit(groupPerson));

/// Форма редактирования персоны в группе
class GroupPersonEdit extends StatefulWidget {
  final GroupPersonView groupPerson;
  final DataActionType actionType;
  const GroupPersonEdit(this.groupPerson, {Key key})
      : this.actionType = groupPerson == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _GroupPersonEditState createState() => _GroupPersonEditState();
}

/// Состояние формы редактирования персоны в группе
class _GroupPersonEditState extends State<GroupPersonEdit> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _personEdit = TextEditingController();
  final _beginDateEdit = TextEditingController();
  final _endDateEdit = TextEditingController();
  Person person;
  bool _autoValidate = false;

  @override
  void initState() {
    person = widget.groupPerson?.person;
    _personEdit.text = fio(person);
    _beginDateEdit.text = dateToString(widget.groupPerson?.beginDate);
    _endDateEdit.text = dateToString(widget.groupPerson?.endDate);
    super.initState();
  }

  @override
  void dispose() {
    _personEdit.dispose();
    _beginDateEdit.dispose();
    _endDateEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(l10n.binding),
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              horizontalSpace(height: dividerHeight),
              // Персона
              TextFormField(
                controller: _personEdit,
                readOnly: true,
                textCapitalization: TextCapitalization.words,
                autofocus: widget.actionType == DataActionType.Insert ? true : false,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: l10n.person,
                ),
                validator: _validatePerson,
                onTap: () => _selectPerson(context),
              ),
              horizontalSpace(),
              // Дата поступления в группу
              TextFormField(
                controller: _beginDateEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.event),
                  labelText: l10n.beginDate,
                ),
                validator: _validateDate,
                inputFormatters: DateFormatters.formatters,
                maxLength: 10,
              ),
              // Дата дата выбытия из группы
              TextFormField(
                controller: _endDateEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.event),
                  labelText: l10n.endDate,
                ),
                validator: _validateDate,
                inputFormatters: DateFormatters.formatters,
                maxLength: 10,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Выбор персоны из словаря
  Future _selectPerson(BuildContext context) async {
    person = await push(context, PersonsDictionary());
    _personEdit.text = person != null ? fio(person) : _personEdit.text;
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
            await bloc.insertGroupPerson(
              group: bloc.activeGroup.value,
              person: person,
              beginDate: stringToDate(_beginDateEdit.text),
              endDate: stringToDate(_endDateEdit.text),
            );
            break;
          case DataActionType.Update:
            await bloc.updateGroupPerson(GroupPersonView(
              id: widget.groupPerson.id,
              groupId: widget.groupPerson.groupId,
              person: person,
              beginDate: stringToDate(_beginDateEdit.text),
              endDate: stringToDate(_endDateEdit.text),
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

  /// Проверка персоны
  String _validatePerson(String value) {
    if (isEmpty(value)) {
      return l10n.selectPerson;
    }
    return null;
  }

  /// Проверка даты
  String _validateDate(String value) {
    if (value.isNotEmpty && stringToDate(value) == null) {
      return l10n.invalidDate;
    }
    return null;
  }
}