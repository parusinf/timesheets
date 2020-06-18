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
      'addingOfGroup': 'Добавление группы',
      'addingOfOrg': 'Добавление организации',
      'cancel': 'ОТМЕНА',
      'dataLoading': 'Загрузка данных',
      'deleteGroup': 'Удалить группу',
      'deleting': 'Удаление',
      'done': 'ГОТОВО',
      'fio': 'ФИО',
      'groupName': 'Наименование группы',
      'groups': 'ГРУППЫ',
      'inn': 'ИНН',
      'noPersons': 'Персон в группе нет',
      'organizations': 'ОРГАНИЗАЦИИ',
      'orgName': 'Наименование организации',
      'title': 'Табели',
      'withoutInn': 'Без ИНН',
    }
  };

  get addingOfGroup => _l10n[locale.languageCode]['addingOfGroup'];
  get addingOfOrg => _l10n[locale.languageCode]['addingOfOrg'];
  get cancel => _l10n[locale.languageCode]['cancel'];
  get dataLoading => _l10n[locale.languageCode]['dataLoading'];
  get deleteGroup => _l10n[locale.languageCode]['deleteGroup'];
  get deleting => _l10n[locale.languageCode]['deleting'];
  get done => _l10n[locale.languageCode]['done'];
  get fio => _l10n[locale.languageCode]['fio'];
  get groupName => _l10n[locale.languageCode]['groupName'];
  get groups => _l10n[locale.languageCode]['groups'];
  get inn => _l10n[locale.languageCode]['inn'];
  get noPersons => _l10n[locale.languageCode]['noPersons'];
  get organizations => _l10n[locale.languageCode]['organizations'];
  get orgName => _l10n[locale.languageCode]['orgName'];
  get title => _l10n[locale.languageCode]['title'];
  get withoutInn => _l10n[locale.languageCode]['withoutInn'];
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
