import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return form(
      title: L10n.org,
      scaffoldKey: _scaffoldKey,
      formKey: _formKey,
      autovalidateMode: _autovalidateMode,
      onSubmit: _onSubmit,
      fields: <Widget>[
        // Наименование организации
        textFormField(
          controller: _nameEdit,
          labelText: L10n.name,
          icon: Icons.business,
          validator: validateEmpty,
          textCapitalization: TextCapitalization.words,
          autofocus: widget.actionType == DataActionType.Insert ? true : false,
          maxLength: 20,
        ),
        // ИНН
        intFormField(
          controller: _innEdit,
          labelText: L10n.inn,
          validator: (value) {
            final regexp = RegExp(r'^\d{10}$');
            if (value.isNotEmpty && !regexp.hasMatch(value)) {
              return L10n.innLength;
            }
            return null;
          },
          maxLength: 10,
        ),
      ],
    );
  }

  /// Обработка формы
  Future _onSubmit() async {
    if (!_formKey.currentState.validate()) {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      try {
        if (widget.actionType == DataActionType.Insert) {
          final org = await bloc.insertOrg(
            name: trim(_nameEdit.text),
            inn: trim(_innEdit.text),
          );
          Navigator.of(context).pop(org);
        } else {
          await bloc.updateOrg(Org(
            id: widget.org?.id,
            name: trim(_nameEdit.text),
            inn: trim(_innEdit.text),
            activeGroupId: widget.org.activeGroupId,
          ));
          Navigator.of(context).pop();
        }
      } catch(e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }
}