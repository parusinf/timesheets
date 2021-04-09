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
  get _bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return form(
      title: L10n.settings,
      scaffoldKey: _scaffoldKey,
      formKey: _formKey,
      autovalidateMode: _autovalidateMode,
      child: StreamBuilder<List<Setting>>(
        stream: _bloc.userSettings,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final settings = snapshot.data;
            _addSetting(settings, L10n.eraseAllData);
            return ListView.builder(
              itemBuilder: (context, index) => _settingCard(settings, index),
              itemCount: settings.length,
            );
          } else {
            return centerMessage(context, L10n.dataLoading);
          }
        }
      ),
    );
  }

  /// Добавление настройки
  void _addSetting(List<Setting> settings, String name) {
    if (settings.where((e) => e.name == name).length == 0) {
      settings.add(Setting(
        id: 0,
        name: L10n.eraseAllData,
        valueType: null,
        isUserSetting: true,
      ));
    }
  }

  /// Карточка настройки
  Widget _settingCard(List<Setting> settings, int index) {
    final setting = settings[index];
    switch (setting.valueType) {
      case ValueType.text:
        return textFormField(
            initialValue: setting.textValue,
            labelText: setting.name,
            onChanged: (value) {
              settings[index] = settings[index].copyWith(textValue: value);
              _bloc.db.settingsDao.update2(settings[index]);
            },
          );
      case ValueType.bool:
        return boolFormField(
          initialValue: setting.boolValue,
          labelText: setting.name,
          onChanged: (value) {
            setState(() {
              settings[index] = settings[index].copyWith(boolValue: value);
              _bloc.db.settingsDao.update2(settings[index]);
            });
          },
        );
      case ValueType.int:
        return intFormField(
          initialValue: setting.intValue,
          labelText: setting.name,
          onChanged: (value) {
            settings[index] = settings[index].copyWith(intValue: stringToInt(value));
            _bloc.db.settingsDao.update2(settings[index]);
          },
        );
      case ValueType.real:
        return realFormField(
          initialValue: setting.realValue,
          labelText: setting.name,
          onChanged: (value) {
            settings[index] = settings[index].copyWith(realValue: stringToDouble(value));
            _bloc.db.settingsDao.update2(settings[index]);
          },
        );
      case ValueType.date:
        return dateFormField(
          initialValue: setting.dateValue,
          labelText: setting.name,
          onChanged: (value) {
            settings[index] = settings[index].copyWith(dateValue: stringToDate(value));
            _bloc.db.settingsDao.update2(settings[index]);
          },
        );
      default:
        if (setting.name == L10n.eraseAllData) {
          return button(setting.name,
            onPressed: () async {
              showAlertDialog(context, L10n.eraseAllData, () async {
                await _bloc.db.reset();
                Navigator.pop(context);
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red[500]),
            ),
          );
        }
    }
    return null;
  }
}