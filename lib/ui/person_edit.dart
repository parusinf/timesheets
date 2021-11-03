import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Добавление персоны
Future addPerson(BuildContext context) async => push(context, PersonEdit(null));

/// Исправление персоны
Future editPerson(BuildContext context, Person person) async =>
    push(context, PersonEdit(person));

/// Форма редактирования персоны
class PersonEdit extends StatefulWidget {
  final Person person;
  final DataActionType actionType;
  const PersonEdit(this.person, {Key key})
      : this.actionType =
            person == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _PersonEditState createState() => _PersonEditState();
}

/// Состояние формы редактирования персоны
class _PersonEditState extends State<PersonEdit> {
  final _familyEdit = TextEditingController();
  final _nameEdit = TextEditingController();
  final _middleNameEdit = TextEditingController();
  final _birthdayEdit = TextEditingController();
  final _phoneEdit = TextEditingController();
  final _phone2Edit = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _familyEdit.text = widget.person?.family;
    _nameEdit.text = widget.person?.name;
    _middleNameEdit.text = widget.person?.middleName;
    _birthdayEdit.text = dateToString(widget.person?.birthday);
    _phoneEdit.text = widget.person?.phone;
    _phone2Edit.text = widget.person?.phone2;
  }

  @override
  void dispose() {
    _familyEdit.dispose();
    _nameEdit.dispose();
    _middleNameEdit.dispose();
    _birthdayEdit.dispose();
    _phoneEdit.dispose();
    _phone2Edit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return form(
      title: L10n.person,
      scaffoldKey: _scaffoldKey,
      formKey: _formKey,
      autovalidateMode: _autovalidateMode,
      onSubmit: _onSubmit,
      fields: <Widget>[
        // Фамилия
        textFormField(
          controller: _familyEdit,
          labelText: L10n.personFamily,
          icon: Icons.person,
          validator: validateEmpty,
          textCapitalization: TextCapitalization.words,
          autofocus: widget.actionType == DataActionType.Insert ? true : false,
        ),
        // Имя
        textFormField(
          controller: _nameEdit,
          labelText: L10n.personName,
          icon: Icons.person,
          validator: validateEmpty,
          textCapitalization: TextCapitalization.words,
        ),
        // Отчество
        textFormField(
          controller: _middleNameEdit,
          labelText: L10n.personMiddleName,
          icon: Icons.person,
          textCapitalization: TextCapitalization.words,
        ),
        // Дата рождения
        dateFormField(
          controller: _birthdayEdit,
          labelText: L10n.personBirthday,
        ),
        // Телефон 1
        phoneFormField(
          controller: _phoneEdit,
          labelText: '${L10n.phone} 1',
          scaffoldKey: _scaffoldKey,
        ),
        // Телефон 2
        phoneFormField(
          controller: _phone2Edit,
          labelText: '${L10n.phone} 2',
          scaffoldKey: _scaffoldKey,
        ),
      ],
    );
  }

  /// Обработка формы
  Future _onSubmit() async {
    if (!_formKey.currentState.validate()) {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      final bloc = Provider.of<Bloc>(context, listen: false);
      try {
        if (widget.actionType == DataActionType.Insert) {
          await bloc.insertPerson(
            family: trim(_familyEdit.text),
            name: trim(_nameEdit.text),
            middleName: trim(_middleNameEdit.text),
            birthday: stringToDate(_birthdayEdit.text),
            phone: trim(_phoneEdit.text),
            phone2: trim(_phone2Edit.text),
          );
        } else {
          await bloc.updatePerson(Person(
            id: widget.person?.id,
            family: trim(_familyEdit.text),
            name: trim(_nameEdit.text),
            middleName: trim(_middleNameEdit.text),
            birthday: stringToDate(_birthdayEdit.text),
            phone: trim(_phoneEdit.text),
            phone2: trim(_phone2Edit.text),
          ));
        }
        Navigator.of(context).pop();
      } catch (e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }
}
