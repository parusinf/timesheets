import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/db/value_type.dart';

/// Исправление настроек
Future editSettings(BuildContext context) async {
  push(context, SettingsEdit());
}

/// Форма исправления настроек
class SettingsEdit extends StatefulWidget {
  const SettingsEdit({Key key}) : super(key: key);
  @override
  _SettingsEditState createState() => _SettingsEditState();
}

/// Состояние формы исправления настроек
class _SettingsEditState extends State<SettingsEdit> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(L10n.settings),
    ),
    body: Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(padding1, padding2, padding1, 0.0),
        child: StreamBuilder<List<Setting>>(
          stream: bloc.userSettings,
          builder: (context, snapshot) => ListView.builder(
            itemBuilder: (context, index) => _settingCard(snapshot.data, index),
            itemCount: snapshot.data?.length ?? 0,
          ),
        ),
      ),
    ),
  );

  /// Карточка настройки
  Widget _settingCard(List<Setting> settings, int index) {
    final setting = settings[index];
    switch (setting.valueType) {
      case ValueType.text:
        return Column(
          children: <Widget>[
            TextFormField(
              initialValue: setting.textValue,
              decoration: InputDecoration(
                icon: const Icon(Icons.text_fields),
                labelText: setting.name,
              ),
              onChanged: (value) {
                settings[index] = settings[index].copyWith(textValue: value);
                bloc.db.settingsDao.update2(settings[index]);
              },
            ),
            divider(),
          ],
        );
      case ValueType.bool:
        return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, padding2, 0.0, padding1),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, padding2, padding1, padding2),
                    child: Icon(Icons.done, color: Colors.black54)
                  ),
                  text(setting.name, fontSize: 16.0),
                  Spacer(),
                  CupertinoSwitch(
                    value: setting.boolValue,
                    onChanged: (bool value) {
                      setState(() {
                        settings[index] = settings[index].copyWith(boolValue: value);
                        bloc.db.settingsDao.update2(settings[index]);
                      });
                    },
                  ),
                ],
              ),
              divider(),
            ],
          ),
        );
      case ValueType.int:
        return Column(
          children: <Widget>[
            TextFormField(
              initialValue: setting.intValue.toString(),
              keyboardType: TextInputType.numberWithOptions(),
              inputFormatters: IntFormatters.formatters,
              decoration: InputDecoration(
                icon: const Icon(Icons.looks_one_outlined),
                labelText: setting.name,
              ),
              onChanged: (value) {
                settings[index] = settings[index].copyWith(intValue: stringToInt(value));
                bloc.db.settingsDao.update2(settings[index]);
              },
            ),
            divider(),
          ],
        );
      case ValueType.real:
        return Column(
          children: <Widget>[
            TextFormField(
              initialValue: setting.realValue.toString(),
              keyboardType: TextInputType.numberWithOptions(),
              decoration: InputDecoration(
                icon: const Icon(Icons.looks_one),
                labelText: setting.name,
              ),
              onChanged: (value) {
                settings[index] = settings[index].copyWith(realValue: stringToDouble(value));
                bloc.db.settingsDao.update2(settings[index]);
              },
            ),
            divider(),
          ],
        );
      case ValueType.date:
        return TextFormField(
          initialValue: dateToString(setting.dateValue),
          keyboardType: TextInputType.numberWithOptions(),
          inputFormatters: DateFormatters.formatters,
          validator: (value) => validateDate(context, value),
          decoration: InputDecoration(
            icon: const Icon(Icons.event),
            labelText: setting.name,
          ),
          maxLength: 10,
          onChanged: (value) {
            settings[index] = settings[index].copyWith(dateValue: stringToDate(value));
            bloc.db.settingsDao.update2(settings[index]);
          },
        );
      default:
        return null;
    }
  }
}