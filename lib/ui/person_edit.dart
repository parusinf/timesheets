import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Добавление персоны
Future addPerson(BuildContext context) async =>
    await push(context, PersonEdit(null));

/// Исправление персоны
Future editPerson(BuildContext context, Person person) async =>
    await push(context, PersonEdit(person));

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
  final _phoneEdit = TextEditingController();
  final _phone2Edit = TextEditingController();
  bool _autoValidate = false;

  @override
  void initState() {
    _familyEdit.text = widget.person?.family;
    _nameEdit.text = widget.person?.name;
    _middleNameEdit.text = widget.person?.middleName;
    _birthdayEdit.text = dateToString(widget.person?.birthday);
    _phoneEdit.text = widget.person?.phone;
    _phone2Edit.text = widget.person?.phone2;
    super.initState();
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
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(l10n.person),
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
              divider(height: padding2),
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
              divider(),
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
              divider(),
              // Отчество
              TextFormField(
                controller: _middleNameEdit,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: l10n.personMiddleName,
                ),
              ),
              divider(),
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
              // Телефон
              TextFormField(
                controller: _phoneEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.phone),
                  labelText: l10n.phone,
                  prefixText: l10n.countryPhoneCode,
                  suffix: IconButton(
                    icon: const Icon(Icons.phone_in_talk),
                    onPressed: () => _callPerson(_phoneEdit.text),
                    color: Colors.green,
                  ),
                ),
                validator: _validatePhone,
                inputFormatters: PhoneFormatters.formatters,
                maxLength: phoneLength,
              ),
              // Телефон 2
              TextFormField(
                controller: _phone2Edit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.phone),
                  labelText: l10n.phone,
                  prefixText: l10n.countryPhoneCode,
                  suffix: IconButton(
                    icon: const Icon(Icons.phone_in_talk),
                    onPressed: () => _callPerson(_phone2Edit.text),
                    color: Colors.green,
                  ),
                ),
                validator: _validatePhone,
                inputFormatters: PhoneFormatters.formatters,
                maxLength: phoneLength,
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
              phone: trim(_phoneEdit.text),
              phone2: trim(_phone2Edit.text),
            );
            break;
          case DataActionType.Update:
            await bloc.updatePerson(Person(
              id: widget.person.id,
              family: trim(_familyEdit.text),
              name: trim(_nameEdit.text),
              middleName: trim(_middleNameEdit.text),
              birthday: stringToDate(_birthdayEdit.text),
              phone: trim(_phoneEdit.text),
              phone2: trim(_phone2Edit.text),
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

  /// Звонок персоне
  Future _callPerson(String phone) async {
    if (phone.isNotEmpty && phone.length == phoneLength) {
      launchUrl(_scaffoldKey, 'tel:${l10n.countryPhoneCode}$phone');
    } else {
      showMessage(_scaffoldKey, l10n.invalidPhone);
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

  /// Проверка телефона
  String _validatePhone(String value) {
    if (value.isNotEmpty && value.length != phoneLength) {
      return l10n.invalidPhone;
    }
    return null;
  }
}