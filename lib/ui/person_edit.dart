import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Форма редактирования персоны
class PersonEdit extends StatefulWidget {
  final Person person;
  final DataActionType actionType;
  const PersonEdit({Key key, this.person})
      : this.actionType = person == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _PersonEditState createState() => _PersonEditState();
}

/// Состояние формы редактирования персоны
class _PersonEditState extends State<PersonEdit> {
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
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
    _birthdayEdit.text = widget.person?.birthday?.toIso8601String();
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
          ? L10n.of(context).personInserting
          : L10n.of(context).personUpdating
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
              TextFormField(
                controller: _familyEdit,
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: L10n.of(context).personFamily,
                ),
                validator: _validateFamily,
              ),
              horizontalSpace,
              TextFormField(
                controller: _nameEdit,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: L10n.of(context).personName,
                ),
                validator: _validateName,
              ),
              horizontalSpace,
              TextFormField(
                controller: _middleNameEdit,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  labelText: L10n.of(context).personMiddleName,
                ),
              ),
              horizontalSpace,
              TextFormField(
                controller: _birthdayEdit,
                decoration: InputDecoration(
                  icon: const Icon(Icons.event),
                  labelText: L10n.of(context).personBirthday,
                ),
                validator: _validateDate,
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
              family: stringValue(_familyEdit.text),
              name: stringValue(_nameEdit.text),
              middleName: stringValue(_middleNameEdit.text),
              birthday: dateTimeValue(_birthdayEdit.text),
            );
            break;
          case DataActionType.Update:
            await bloc.updatePerson(Person(
              id: widget.person.id,
              family: stringValue(_familyEdit.text),
              name: stringValue(_nameEdit.text),
              middleName: stringValue(_middleNameEdit.text),
              birthday: dateTimeValue(_birthdayEdit.text),
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

  /// Проверка фамилиии
  String _validateFamily(String value) {
    if (isEmpty(value)) {
      return L10n.of(context).noPersonFamily;
    }
    return null;
  }

  /// Проверка имени
  String _validateName(String value) {
    if (isEmpty(value)) {
      return L10n.of(context).noPersonName;
    }
    return null;
  }

  /// Проверка даты
  String _validateDate(String value) {
    if (value.isNotEmpty) {
      final hoursNorm = DateTime.tryParse(value);
      if (hoursNorm == null) {
        return L10n.of(context).invalidDate;
      }
    }
    return null;
  }
}