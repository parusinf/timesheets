import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/db/db.dart';

class OrgPage extends StatefulWidget {
  final Org entry;
  const OrgPage({Key key, this.entry}) : super(key: key);
  @override
  _OrgPageState createState() => _OrgPageState();
}

class _OrgPageState extends State<OrgPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final TextEditingController _nameEdit = TextEditingController();
  final TextEditingController _innEdit = TextEditingController();

  @override
  void initState() {
    _nameEdit.text = widget.entry?.name;
    _innEdit.text = widget.entry?.inn;
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
    appBar: AppBar(
      title: Text(widget.entry == null ?
          L10n.of(context).orgInserting : L10n.of(context).orgUpdating
      ),
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              TextFormField(
                controller: _innEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.dialpad),
                  labelText: L10n.of(context).inn,
                ),
                validator: _validateInn,
              ),
              const SizedBox(height: 16),
              ButtonBar(
                children: <Widget>[
                  RaisedButton(
                    child: Text(L10n.of(context).done),
                    onPressed: _handleSubmitted,
                  ),
                ],
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
      if (widget.entry == null) {
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

  /// Добавление
  void _insert() {
    if (_nameEdit.text.isNotEmpty) {
      bloc.insertOrg(name: _nameEdit.text, inn: _innEdit.text);
      Navigator.of(context).pop();
    }
  }
  
  /// Исправление
  void _update() {
    if (_nameEdit.text.isNotEmpty) {
      bloc.updateOrg(widget.entry.copyWith(
        name: _nameEdit.text,
        inn: _innEdit.text,
      ));
      Navigator.of(context).pop();
    }
  }
}
