import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Добавление организации
Future addOrg(BuildContext context) async =>
    push(context, OrgEdit(null));

/// Исправление организации
Future editOrg(BuildContext context, Org org) async =>
    push(context, OrgEdit(org));

/// Форма редактирования организации
class OrgEdit extends StatefulWidget {
  final Org org;
  final DataActionType actionType;
  const OrgEdit(this.org, {Key key})
      : this.actionType = org == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _OrgEditState createState() => _OrgEditState();
}

/// Состояние формы редактирования организации
class _OrgEditState extends State<OrgEdit> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameEdit = TextEditingController();
  final _innEdit = TextEditingController();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _nameEdit.text = widget.org?.name;
    _innEdit.text = widget.org?.inn;
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
      title: Text(L10n.org),
      actions: <Widget>[
        IconButton(icon: const Icon(Icons.done), onPressed: _handleSubmitted),
      ],
    ),
    body: Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Scrollbar(
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          padding: const EdgeInsets.symmetric(horizontal: padding1),
          child: Column(
            children: <Widget>[
              divider(height: padding2),
              // Наименование организации
              TextFormField(
                controller: _nameEdit,
                textCapitalization: TextCapitalization.words,
                autofocus: widget.actionType == DataActionType.Insert ? true : false,
                decoration: InputDecoration(
                  icon: const Icon(Icons.business),
                  labelText: L10n.name,
                ),
                validator: _validateName,
                maxLength: 20,
              ),
              // ИНН
              TextFormField(
                controller: _innEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.looks_one_outlined),
                  labelText: L10n.inn,
                ),
                validator: _validateInn,
                inputFormatters: IntFormatters.formatters,
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
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      try {
        switch (widget.actionType) {
          case DataActionType.Insert:
            final org = await bloc.insertOrg(
              name: trim(_nameEdit.text),
              inn: trim(_innEdit.text),
            );
            Navigator.of(context).pop(org);
            break;
          case DataActionType.Update:
            await bloc.updateOrg(Org(
              id: widget.org.id,
              name: trim(_nameEdit.text),
              inn: trim(_innEdit.text),
              activeGroupId: widget.org.activeGroupId,
            ));
            Navigator.of(context).pop();
            break;
          case DataActionType.Delete: break;
        }
      } catch(e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }

  /// Проверка наименования
  String _validateName(String value) {
    if (isEmpty(value)) {
      return L10n.noName;
    }
    return null;
  }

  /// Проверка ИНН
  String _validateInn(String value) {
    final regexp = RegExp(r'^\d{10}$');
    if (value.isNotEmpty && !regexp.hasMatch(value)) {
      return L10n.innLength;
    }
    return null;
  }
}