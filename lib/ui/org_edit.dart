import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Форма редактирования организации
class OrgEdit extends StatefulWidget {
  final Org org;
  final DataActionType actionType;
  const OrgEdit({Key key, this.org})
      : this.actionType = org == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _OrgEditState createState() => _OrgEditState();
}

/// Состояние формы редактирования организации
class _OrgEditState extends State<OrgEdit> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);
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
      title: Text(widget.actionType == DataActionType.Insert
          ? l10n.orgInserting
          : l10n.orgUpdating
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
          padding: const EdgeInsets.symmetric(horizontal: padding),
          child: Column(
            children: <Widget>[
              // Наименование организации
              TextFormField(
                controller: _nameEdit,
                textCapitalization: TextCapitalization.words,
                autofocus: widget.actionType == DataActionType.Insert ? true : false,
                decoration: InputDecoration(
                  icon: const Icon(Icons.business),
                  labelText: l10n.orgName,
                ),
                validator: _validateName,
              ),
              horizontalSpace(),
              // ИНН
              TextFormField(
                controller: _innEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.dialpad),
                  labelText: l10n.inn,
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
      _autoValidate = true;
    } else {
      try {
        switch (widget.actionType) {
          case DataActionType.Insert:
            await bloc.insertOrg(
              name: trim(_nameEdit.text),
              inn: trim(_innEdit.text),
            );
            break;
          case DataActionType.Update:
            await bloc.updateOrg(Org(
              id: widget.org.id,
              name: trim(_nameEdit.text),
              inn: trim(_innEdit.text),
              activeGroupId: widget.org.activeGroupId,
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

  /// Проверка наименования
  String _validateName(String value) {
    if (isEmpty(value)) {
      return l10n.noName;
    }
    return null;
  }

  /// Проверка ИНН
  String _validateInn(String value) {
    final regexp = RegExp(r'^\d{10}$');
    if (value.isNotEmpty && !regexp.hasMatch(value)) {
      return l10n.innLength;
    }
    return null;
  }
}