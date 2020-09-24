import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Добавление персоны
Future addPerson(BuildContext context) async =>
    push(context, PersonEdit(null));

/// Исправление персоны
Future editPerson(BuildContext context, Person person) async =>
    push(context, PersonEdit(person));

/// Форма редактирования персоны
class PersonEdit extends StatefulWidget {
  final Person person;
  final DataActionType actionType;
  const PersonEdit(this.person, {Key key})
      : this.actionType = person == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _PersonEditState createState() => _PersonEditState();
}

/// Состояние формы редактирования персоны
class _PersonEditState extends State<PersonEdit> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _familyEdit = TextEditingController();
  final _nameEdit = TextEditingController();
  final _middleNameEdit = TextEditingController();
  final _birthdayEdit = TextEditingController();
  bool _autoValidate = false;

  @override
  void initState() {
    _familyEdit.text = widget.person?.family;
    _nameEdit.text = widget.person?.name;
    _middleNameEdit.text = widget.person?.middleName;
    _birthdayEdit.text = dateToString(widget.person?.birthday);
    super.initState();
  }

  @override
  void dispose() {
    _familyEdit.dispose();
    _nameEdit.dispose();
    _middleNameEdit.dispose();
    _birthdayEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(widget.actionType == DataActionType.Insert
          ? l10n.personInserting
          : l10n.personUpdating
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
          padding: const EdgeInsets.symmetric(horizontal: padding1),
          child: Column(
            children: <Widget>[
              horizontalSpace(height: dividerHeight),
              // Фамилия
              TextFormField(
                controller: _familyEdit,
                textCapitalization: TextCapitalization.words,
                autofocus: widget.actionType == DataActionType.Insert ? true : false,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: l10n.personFamily,
                ),
                validator: _validateFamily,
              ),
              horizontalSpace(),
              // Имя
              TextFormField(
                controller: _nameEdit,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: l10n.personName,
                ),
                validator: _validateName,
              ),
              horizontalSpace(),
              // Отчество
              TextFormField(
                controller: _middleNameEdit,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: l10n.personMiddleName,
                ),
              ),
              horizontalSpace(),
              // Дата рождения
              TextFormField(
                controller: _birthdayEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.event),
                  labelText: l10n.personBirthday,
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

  /// Обработка формы
  Future _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      try {
        switch (widget.actionType) {
          case DataActionType.Insert:
            await bloc.insertPerson(
              family: trim(_familyEdit.text),
              name: trim(_nameEdit.text),
              middleName: trim(_middleNameEdit.text),
              birthday: stringToDate(_birthdayEdit.text),
            );
            break;
          case DataActionType.Update:
            await bloc.updatePerson(Person(
              id: widget.person.id,
              family: trim(_familyEdit.text),
              name: trim(_nameEdit.text),
              middleName: trim(_middleNameEdit.text),
              birthday: stringToDate(_birthdayEdit.text),
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

  /// Проверка фамилии
  String _validateFamily(String value) {
    if (isEmpty(value)) {
      return l10n.noPersonFamily;
    }
    return null;
  }

  /// Проверка имени
  String _validateName(String value) {
    if (isEmpty(value)) {
      return l10n.noPersonName;
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