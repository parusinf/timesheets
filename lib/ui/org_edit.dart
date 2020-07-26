import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Форма редактирования организации
class OrgEdit extends StatefulWidget {
  final Org org;
  const OrgEdit({Key key, this.org}) : super(key: key);
  @override
  _OrgEditState createState() => _OrgEditState();
}

/// Состояние формы редактирования организации
class _OrgEditState extends State<OrgEdit> {
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameEdit = TextEditingController();
  final _innEdit = TextEditingController();
  bool _autoValidate = false;

  @override
  void initState() {
    _nameEdit.text = widget.org?.name;
    _innEdit.text = widget.org?.inn;
    super.initState();
  }

  @override
  void dispose() {
    _nameEdit.dispose();
    _innEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(widget.org == null
          ? L10n.of(context).orgInserting : L10n.of(context).orgUpdating
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
                controller: _nameEdit,
                textCapitalization: TextCapitalization.words,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.business),
                  labelText: L10n.of(context).orgName,
                ),
                validator: _validateName,
              ),
              horizontalSpace,
              TextFormField(
                controller: _innEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.dialpad),
                  labelText: L10n.of(context).inn,
                ),
                validator: _validateInn,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Обработка формы
  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      if (widget.org == null) {
        _insert();
      } else {
        _update();
      }
    }
  }

  /// Проверка наименования
  String _validateName(String value) {
    if (value.isEmpty) {
      return L10n.of(context).noName;
    }
    return null;
  }

  /// Проверка ИНН
  String _validateInn(String value) {
    final regexp = RegExp(r'^\d{10}$');
    if (value.isNotEmpty && !regexp.hasMatch(value)) {
      return L10n.of(context).innLength;
    }
    return null;
  }

  /// Добавление организации
  Future _insert() async {
    try {
      await bloc.insertOrg(name: _nameEdit.text, inn: _innEdit.text);
      Navigator.of(context).pop();
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }
  
  /// Исправление организации
  Future _update() async {
    try {
      await bloc.updateOrg(widget.org.copyWith(
          name: _nameEdit.text, inn: _innEdit.text));
      Navigator.of(context).pop();
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }
}