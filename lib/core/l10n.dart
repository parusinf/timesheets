import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class L10n {
  L10n(this.locale);

  final Locale locale;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  static const Map<String, Map<String, String>> _l10n = {
    'ru': {
      'title': 'Табели',
      'ok': 'OK',
      'cancel': 'ОТМЕНА',
      'groups': 'Группы',
      'addGroup': 'Добавить группу',
      'personCount': 'человек',
      'personCount234': 'человека',
      'deleting': 'Удаление',
      'deleteGroup': 'Удалить группу',
      'fio': 'ФИО',
      'addingOfGroup': 'Добавление группы',
      'groupName': 'Наименование группы',
    },
    'en': {
      'title': 'Timesheet',
      'ok': 'OK',
      'cancel': 'CANCEL',
      'groups': 'Groups',
      'addGroup': 'Add group',
      'personCount': 'persons',
      'personCount234': 'persons',
      'deleting': 'Deleting',
      'deleteGroup': 'Delete group',
      'fio': 'Family Name',
      'addingOfGroup': 'Adding of group',
      'groupName': 'Group name',
    },
  };

  get title => _l10n[locale.languageCode]['title'];
  get ok => _l10n[locale.languageCode]['ok'];
  get cancel => _l10n[locale.languageCode]['cancel'];
  get groups => _l10n[locale.languageCode]['groups'];
  get addGroup => _l10n[locale.languageCode]['addGroup'];
  get personCount => _l10n[locale.languageCode]['personCount'];
  get personCount234 => _l10n[locale.languageCode]['personCount234'];
  get deleting => _l10n[locale.languageCode]['deleting'];
  get deleteGroup => _l10n[locale.languageCode]['deleteGroup'];
  get fio => _l10n[locale.languageCode]['fio'];
  get addingOfGroup => _l10n[locale.languageCode]['addingOfGroup'];
  get groupName => _l10n[locale.languageCode]['groupName'];
}

class L10nDelegate extends LocalizationsDelegate<L10n> {
  const L10nDelegate();

  @override
  bool isSupported(Locale locale) => ['ru','en'].contains(locale.languageCode);

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(L10n(locale));
  }

  @override
  bool shouldReload(L10nDelegate old) => false;
}
