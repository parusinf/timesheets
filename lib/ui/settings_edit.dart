import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Исправление настроек
Future editSettings(BuildContext context) async {
  push(context, const SettingsEdit());
}

/// Форма исправления настроек
class SettingsEdit extends StatefulWidget {
  const SettingsEdit({Key? key}) : super(key: key);
  @override
  SettingsEditState createState() => SettingsEditState();
}

/// Состояние формы исправления настроек
class SettingsEditState extends State<SettingsEdit> {
  get _bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _autovalidateMode = AutovalidateMode.disabled;

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
              _addSetting(settings!, L10n.eraseAllData);
              return ListView.builder(
                itemBuilder: (context, index) => _settingCard(settings, index),
                itemCount: settings.length,
              );
            } else {
              return centerMessage(context, L10n.dataLoading);
            }
          }),
    );
  }

  /// Добавление настройки
  void _addSetting(List<Setting> settings, String name) {
    if (settings.where((e) => e.name == name).isEmpty) {
      settings.add(Setting(
        id: 0,
        name: L10n.eraseAllData,
        valueType: 5,
        isUserSetting: true,
      ));
    }
  }

  /// Карточка настройки
  Widget _settingCard(List<Setting> settings, int index) {
    final setting = settings[index];
    switch (setting.valueType) {
      case 0:
        return textFormField(
          initialValue: setting.textValue,
          labelText: setting.name,
          onChanged: (value) {
            settings[index] = settings[index].copyWith(textValue: Value(value));
            _bloc.db.settingsDao.update2(settings[index]);
          },
        );
      case 1:
        return boolFormField(
          initialValue: setting.boolValue,
          labelText: setting.name,
          onChanged: (value) {
            setState(() {
              settings[index] = settings[index].copyWith(boolValue: Value(value));
              _bloc.db.settingsDao.update2(settings[index]);
            });
          },
        );
      case 2:
        return intFormField(
          initialValue: setting.intValue,
          labelText: setting.name,
          onChanged: (value) {
            settings[index] =
                settings[index].copyWith(intValue: Value(stringToInt(value)));
            _bloc.db.settingsDao.update2(settings[index]);
          },
        );
      case 3:
        return realFormField(
          initialValue: setting.realValue,
          labelText: setting.name,
          onChanged: (value) {
            settings[index] =
                settings[index].copyWith(realValue: Value(stringToDouble(value)));
            _bloc.db.settingsDao.update2(settings[index]);
          },
        );
      case 4:
        return dateFormField(
          initialValue: setting.dateValue,
          labelText: setting.name,
          onChanged: (value) {
            settings[index] =
                settings[index].copyWith(dateValue: Value(stringToDateOrNull(value)));
            _bloc.db.settingsDao.update2(settings[index]);
          },
        );
      case 5:
        if (setting.name == L10n.eraseAllData) {
          return button(
            setting.name,
            onPressed: () async {
              showAlertDialog(context, L10n.eraseAllData, () async {
                await _bloc.reset();
                if (!mounted) return;
                Navigator.pop(context);
              });
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.red[500]!),
            ),
          );
        }
    }
    throw UnsupportedError(setting.valueType.toString());
  }
}
