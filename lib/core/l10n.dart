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
      'addGroup': 'Добавьте группу',
      'addOrg': 'Добавьте организацию',
      'addPerson': 'Добавьте персону',
      'addPersonToGroup': 'Добавьте персону в группу',
      'beginDate': 'Дата поступления в группу',
      'bindingUpdating': 'Исправление привязки',
      'dataLoading': 'Загрузка данных',
      'endDate': 'Дата выбытия из группы',
      'from': 'с',
      'groupInserting': 'Добавление группы',
      'groupName': 'Наименование группы',
      'groupPersons': 'Персоны в группе',
      'groupUpdating': 'Исправление группы',
      'groups': 'Группы',
      'inn': 'ИНН',
      'innLength': 'ИНН должен состоять из 10 цифр',
      'insertingIntoGroup': 'Добавление в группу',
      'invalidDate': 'Дата должна быть в формате ДД.ММ.ГГГГ',
      'invalidHoursNorm': 'Некорректная норма часов',
      'noHoursNorm': 'Нет нормы часов',
      'noName': 'Нет наименования',
      'noPersonFamily': 'Нет фамилии',
      'noPersonName': 'Нет имени',
      'orgInserting': 'Добавление организации',
      'orgName': 'Наименование организации',
      'orgUpdating': 'Исправление организации',
      'orgs': 'Организации',
      'person': 'Персона',
      'personBirthday': 'Дата рождения',
      'personFamily': 'Фамилия',
      'personInserting': 'Добавление персоны',
      'personMiddleName': 'Отчество',
      'personName': 'Имя',
      'personUpdating': 'Исправление персоны',
      'persons': 'Персоны',
      'schedule': 'График',
      'scheduleInserting': 'Добавление графика',
      'scheduleUpdating': 'Исправление графика',
      'schedules': 'Графики',
      'selectPerson': 'Выберите персону',
      'selectSchedule': 'Выберите график',
      'title': 'Табели посещаемости',
      'to': 'по',
      'uniqueGroup': 'Уже есть такая группа',
      'uniqueGroupPerson': 'Уже есть такая персона в группе',
      'uniqueOrg': 'Уже есть такая организация',
      'uniquePerson': 'Уже есть такая персона',
      'uniqueSchedule': 'Уже есть такой график',
      'withoutInn': 'Без ИНН',
    }
  };

  get addGroup => _l10n[locale.languageCode]['addGroup'];
  get addOrg => _l10n[locale.languageCode]['addOrg'];
  get addPerson => _l10n[locale.languageCode]['addPerson'];
  get addPersonToGroup => _l10n[locale.languageCode]['addPersonToGroup'];
  get beginDate => _l10n[locale.languageCode]['beginDate'];
  get bindingUpdating => _l10n[locale.languageCode]['bindingUpdating'];
  get dataLoading => _l10n[locale.languageCode]['dataLoading'];
  get endDate => _l10n[locale.languageCode]['endDate'];
  get from => _l10n[locale.languageCode]['from'];
  get groupInserting => _l10n[locale.languageCode]['groupInserting'];
  get groupName => _l10n[locale.languageCode]['groupName'];
  get groupPersons => _l10n[locale.languageCode]['groupPersons'];
  get groupUpdating => _l10n[locale.languageCode]['groupUpdating'];
  get groups => _l10n[locale.languageCode]['groups'];
  get inn => _l10n[locale.languageCode]['inn'];
  get innLength => _l10n[locale.languageCode]['innLength'];
  get insertingIntoGroup => _l10n[locale.languageCode]['insertingIntoGroup'];
  get invalidDate => _l10n[locale.languageCode]['invalidDate'];
  get invalidHoursNorm => _l10n[locale.languageCode]['invalidHoursNorm'];
  get noHoursNorm => _l10n[locale.languageCode]['noHoursNorm'];
  get noName => _l10n[locale.languageCode]['noName'];
  get noPersonFamily => _l10n[locale.languageCode]['noPersonFamily'];
  get noPersonName => _l10n[locale.languageCode]['noPersonName'];
  get orgInserting => _l10n[locale.languageCode]['orgInserting'];
  get orgName => _l10n[locale.languageCode]['orgName'];
  get orgUpdating => _l10n[locale.languageCode]['orgUpdating'];
  get orgs => _l10n[locale.languageCode]['orgs'];
  get person => _l10n[locale.languageCode]['person'];
  get personBirthday => _l10n[locale.languageCode]['personBirthday'];
  get personFamily => _l10n[locale.languageCode]['personFamily'];
  get personInserting => _l10n[locale.languageCode]['personInserting'];
  get personMiddleName => _l10n[locale.languageCode]['personMiddleName'];
  get personName => _l10n[locale.languageCode]['personName'];
  get personUpdating => _l10n[locale.languageCode]['personUpdating'];
  get persons => _l10n[locale.languageCode]['persons'];
  get schedule => _l10n[locale.languageCode]['schedule'];
  get scheduleInserting => _l10n[locale.languageCode]['scheduleInserting'];
  get scheduleUpdating => _l10n[locale.languageCode]['scheduleUpdating'];
  get schedules => _l10n[locale.languageCode]['schedules'];
  get selectPerson => _l10n[locale.languageCode]['selectPerson'];
  get selectSchedule => _l10n[locale.languageCode]['selectSchedule'];
  get title => _l10n[locale.languageCode]['title'];
  get to => _l10n[locale.languageCode]['to'];
  get uniqueGroup => _l10n[locale.languageCode]['uniqueGroup'];
  get uniqueGroupPerson => _l10n[locale.languageCode]['uniqueGroupPerson'];
  get uniqueOrg => _l10n[locale.languageCode]['uniqueOrg'];
  get uniquePerson => _l10n[locale.languageCode]['uniquePerson'];
  get uniqueSchedule => _l10n[locale.languageCode]['uniqueSchedule'];
  get withoutInn => _l10n[locale.languageCode]['withoutInn'];
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
