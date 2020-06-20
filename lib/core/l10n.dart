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
      'cancel': 'ОТМЕНА',
      'dataLoading': 'Загрузка данных',
      'deleteGroup': 'Удалить группу',
      'deleting': 'Удаление',
      'done': 'ГОТОВО',
      'fio': 'ФИО',
      'groupDeleted': 'Группа удалена',
      'groupInserting': 'Добавление группы',
      'groupName': 'Наименование группы',
      'groupUpdating': 'Исправление группы',
      'groups': 'ГРУППЫ',
      'inn': 'ИНН',
      'noGroups': 'Групп нет',
      'noOrgs': 'Организаций нет',
      'noPersons': 'Персон нет',
      'orgDeleted': 'Организация удалена',
      'orgInserting': 'Добавление организации',
      'orgName': 'Наименование организации',
      'orgUpdating': 'Исправление организации',
      'organizations': 'ОРГАНИЗАЦИИ',
      'title': 'Табели',
      'withoutInn': 'Без ИНН',
    }
  };

  get cancel => _l10n[locale.languageCode]['cancel'];
  get dataLoading => _l10n[locale.languageCode]['dataLoading'];
  get deleteGroup => _l10n[locale.languageCode]['deleteGroup'];
  get deleting => _l10n[locale.languageCode]['deleting'];
  get done => _l10n[locale.languageCode]['done'];
  get fio => _l10n[locale.languageCode]['fio'];
  get groupDeleted => _l10n[locale.languageCode]['groupDeleted'];
  get groupInserting => _l10n[locale.languageCode]['groupInserting'];
  get groupName => _l10n[locale.languageCode]['groupName'];
  get groupUpdating => _l10n[locale.languageCode]['groupUpdating'];
  get groups => _l10n[locale.languageCode]['groups'];
  get inn => _l10n[locale.languageCode]['inn'];
  get noGroups => _l10n[locale.languageCode]['noGroups'];
  get noOrgs => _l10n[locale.languageCode]['noOrgs'];
  get noPersons => _l10n[locale.languageCode]['noPersons'];
  get orgDeleted => _l10n[locale.languageCode]['orgDeleted'];
  get orgInserting => _l10n[locale.languageCode]['orgInserting'];
  get orgName => _l10n[locale.languageCode]['orgName'];
  get orgUpdating => _l10n[locale.languageCode]['orgUpdating'];
  get organizations => _l10n[locale.languageCode]['organizations'];
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
