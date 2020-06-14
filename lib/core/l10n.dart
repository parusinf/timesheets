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
      'addGroup': 'Добавить группу',
      'addingOfGroup': 'Добавление группы',
      'cancel': 'ОТМЕНА',
      'deleteGroup': 'Удалить группу',
      'deleting': 'Удаление',
      'fio': 'ФИО',
      'groupName': 'Наименование группы',
      'groups': 'Группы',
      'inn': 'ИНН',
      'ok': 'OK',
      'organizations': 'ОРГАНИЗАЦИИ',
      'personCount': 'человек',
      'personCount234': 'человека',
      'title': 'Табели',
    }
  };

  get addGroup => _l10n[locale.languageCode]['addGroup'];
  get addingOfGroup => _l10n[locale.languageCode]['addingOfGroup'];
  get cancel => _l10n[locale.languageCode]['cancel'];
  get deleteGroup => _l10n[locale.languageCode]['deleteGroup'];
  get deleting => _l10n[locale.languageCode]['deleting'];
  get fio => _l10n[locale.languageCode]['fio'];
  get groupName => _l10n[locale.languageCode]['groupName'];
  get groups => _l10n[locale.languageCode]['groups'];
  get inn => _l10n[locale.languageCode]['inn'];
  get ok => _l10n[locale.languageCode]['ok'];
  get organizations => _l10n[locale.languageCode]['organizations'];
  get personCount => _l10n[locale.languageCode]['personCount'];
  get personCount234 => _l10n[locale.languageCode]['personCount234'];
  get title => _l10n[locale.languageCode]['title'];
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
