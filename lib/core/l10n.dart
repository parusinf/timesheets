import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class L10n {
  final Locale locale;

  L10n(this.locale);

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
      'errorInData': 'Ошибка в данных',
      'fio': 'ФИО',
      'groupDeleted': 'Группа удалена',
      'groupInserted': 'Группа добавлена',
      'groupInserting': 'Добавление группы',
      'groupName': 'Наименование группы',
      'groupUpdated': 'Группа исправлена',
      'groupUpdating': 'Исправление группы',
      'groups': 'ГРУППЫ',
      'inn': 'ИНН',
      'innLength': 'ИНН должен состоять из 10 цифр',
      'invalidHoursNorm': 'Некорректная норма часов',
      'noCode': 'Нет мнемокода',
      'noGroups': 'Групп нет',
      'noName': 'Нет наименования',
      'noOrgs': 'Организаций нет',
      'noPersons': 'Персон нет',
      'noSchedule': 'Нет графика',
      'orgDeleted': 'Организация удалена',
      'orgInserted': 'Организация добавлена',
      'orgInserting': 'Добавление организации',
      'orgName': 'Наименование организации',
      'orgUpdated': 'Организация исправлена',
      'orgUpdating': 'Исправление организации',
      'orgs': 'ОРГАНИЗАЦИИ',
      'schedule': 'График',
      'scheduleCode': 'Мнемокод графика',
      'scheduleInserting': 'Добавление графика',
      'scheduleUpdating': 'Исправление графика',
      'schedules': 'Графики',
      'title': 'Табели',
      'uniqueGroup': 'Уже есть такая группа',
      'uniqueOrg': 'Уже есть такая организация',
      'uniqueSchedule': 'Уже есть такой график',
      'withoutInn': 'Без ИНН',
      'noHoursNorm': 'Нет нормы часов',
      'addPersonToGroup': 'Добавить персону в группу',
      'personInserting': 'Добавление персоны',
      'personUpdating': 'Исправление персоны',
      'personFamily': 'Фамилия',
      'personName': 'Имя',
      'personMiddleName': 'Отчество',
      'personBirthday': 'Дата рождения',
      'noPersonFamily': 'Нет фамилии',
      'noPersonName': 'Нет имени',
      'invalidDate': 'Некорректная дата',
      'persons': 'Персоны',
      'uniquePerson': 'Уже есть такая персона',
      'uniqueGroupPerson': 'Уже есть такая персона в группе',
    }
  };

  get cancel => _l10n[locale.languageCode]['cancel'];
  get dataLoading => _l10n[locale.languageCode]['dataLoading'];
  get deleteGroup => _l10n[locale.languageCode]['deleteGroup'];
  get deleting => _l10n[locale.languageCode]['deleting'];
  get done => _l10n[locale.languageCode]['done'];
  get errorInData => _l10n[locale.languageCode]['errorInData'];
  get fio => _l10n[locale.languageCode]['fio'];
  get groupDeleted => _l10n[locale.languageCode]['groupDeleted'];
  get groupInserted => _l10n[locale.languageCode]['groupInserted'];
  get groupInserting => _l10n[locale.languageCode]['groupInserting'];
  get groupName => _l10n[locale.languageCode]['groupName'];
  get groupUpdated => _l10n[locale.languageCode]['groupUpdated'];
  get groupUpdating => _l10n[locale.languageCode]['groupUpdating'];
  get groups => _l10n[locale.languageCode]['groups'];
  get inn => _l10n[locale.languageCode]['inn'];
  get innLength => _l10n[locale.languageCode]['innLength'];
  get invalidHoursNorm => _l10n[locale.languageCode]['invalidHoursNorm'];
  get noCode => _l10n[locale.languageCode]['noCode'];
  get noGroups => _l10n[locale.languageCode]['noGroups'];
  get noName => _l10n[locale.languageCode]['noName'];
  get noOrgs => _l10n[locale.languageCode]['noOrgs'];
  get noPersons => _l10n[locale.languageCode]['noPersons'];
  get noSchedule => _l10n[locale.languageCode]['noSchedule'];
  get orgDeleted => _l10n[locale.languageCode]['orgDeleted'];
  get orgInserted => _l10n[locale.languageCode]['orgInserted'];
  get orgInserting => _l10n[locale.languageCode]['orgInserting'];
  get orgName => _l10n[locale.languageCode]['orgName'];
  get orgUpdated => _l10n[locale.languageCode]['orgUpdated'];
  get orgUpdating => _l10n[locale.languageCode]['orgUpdating'];
  get orgs => _l10n[locale.languageCode]['orgs'];
  get schedule => _l10n[locale.languageCode]['schedule'];
  get scheduleCode => _l10n[locale.languageCode]['scheduleCode'];
  get scheduleInserting => _l10n[locale.languageCode]['scheduleInserting'];
  get scheduleUpdating => _l10n[locale.languageCode]['scheduleUpdating'];
  get schedules => _l10n[locale.languageCode]['schedules'];
  get title => _l10n[locale.languageCode]['title'];
  get uniqueGroup => _l10n[locale.languageCode]['uniqueGroup'];
  get uniqueOrg => _l10n[locale.languageCode]['uniqueOrg'];
  get uniqueSchedule => _l10n[locale.languageCode]['uniqueSchedule'];
  get withoutInn => _l10n[locale.languageCode]['withoutInn'];
  get noHoursNorm => _l10n[locale.languageCode]['noHoursNorm'];
  get addPersonToGroup => _l10n[locale.languageCode]['addPersonToGroup'];
  get personInserting => _l10n[locale.languageCode]['personInserting'];
  get personUpdating => _l10n[locale.languageCode]['personUpdating'];
  get personFamily => _l10n[locale.languageCode]['personFamily'];
  get personName => _l10n[locale.languageCode]['personName'];
  get personMiddleName => _l10n[locale.languageCode]['personMiddleName'];
  get personBirthday => _l10n[locale.languageCode]['personBirthday'];
  get noPersonFamily => _l10n[locale.languageCode]['noPersonFamily'];
  get noPersonName => _l10n[locale.languageCode]['noPersonName'];
  get invalidDate => _l10n[locale.languageCode]['invalidDate'];
  get persons => _l10n[locale.languageCode]['persons'];
  get uniquePerson => _l10n[locale.languageCode]['uniquePerson'];
  get uniqueGroupPerson => _l10n[locale.languageCode]['uniqueGroupPerson'];
}

class L10nDelegate extends LocalizationsDelegate<L10n> {
  const L10nDelegate();

  @override
  bool isSupported(Locale locale) => ['ru'].contains(locale.languageCode);

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(L10n(locale));
  }

  @override
  bool shouldReload(L10nDelegate old) => false;
}
