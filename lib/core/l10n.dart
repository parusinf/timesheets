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
      'addSchedule': 'Добавьте график',
      'beginDate': 'Дата поступления',
      'binding': 'Прикрепление',
      'countryPhoneCode': '+7 ',
      'dataLoading': 'Загрузка данных',
      'endDate': 'Дата выбытия',
      'from': 'с',
      'group': 'Группа',
      'groupName': 'Наименование группы',
      'groupPersons': 'Персоны в группе',
      'groupUpdating': 'Исправление группы',
      'groups': 'Группы',
      'help': 'Справка',
      'inn': 'ИНН',
      'innLength': 'ИНН должен состоять из 10 цифр',
      'invalidDate': 'Формат даты ДД.ММ.ГГГГ',
      'invalidHoursNorm': 'Некорректная норма часов',
      'invalidPhone': 'Формат телефона (###) ###-##-##',
      'linkNotStart': 'Ссылка не запускается',
      'noHoursNorm': 'Нет нормы часов',
      'noName': 'Нет наименования',
      'noPersonFamily': 'Нет фамилии',
      'noPersonName': 'Нет имени',
      'org': 'Организация',
      'orgName': 'Наименование организации',
      'orgs': 'Организации',
      'person': 'Персона',
      'personBirthday': 'Дата рождения',
      'personFamily': 'Фамилия',
      'personMiddleName': 'Отчество',
      'personName': 'Имя',
      'persons': 'Персоны',
      'phone': 'Телефон',
      'schedule': 'График',
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
      'withoutTime': 'без срока',
    }
  };

  get addGroup => _l10n[locale.languageCode]['addGroup'];
  get addOrg => _l10n[locale.languageCode]['addOrg'];
  get addPerson => _l10n[locale.languageCode]['addPerson'];
  get addPersonToGroup => _l10n[locale.languageCode]['addPersonToGroup'];
  get addSchedule => _l10n[locale.languageCode]['addSchedule'];
  get beginDate => _l10n[locale.languageCode]['beginDate'];
  get binding => _l10n[locale.languageCode]['binding'];
  get countryPhoneCode => _l10n[locale.languageCode]['countryPhoneCode'];
  get dataLoading => _l10n[locale.languageCode]['dataLoading'];
  get endDate => _l10n[locale.languageCode]['endDate'];
  get from => _l10n[locale.languageCode]['from'];
  get group => _l10n[locale.languageCode]['group'];
  get groupName => _l10n[locale.languageCode]['groupName'];
  get groupPersons => _l10n[locale.languageCode]['groupPersons'];
  get groups => _l10n[locale.languageCode]['groups'];
  get help => _l10n[locale.languageCode]['help'];
  get inn => _l10n[locale.languageCode]['inn'];
  get innLength => _l10n[locale.languageCode]['innLength'];
  get invalidDate => _l10n[locale.languageCode]['invalidDate'];
  get invalidHoursNorm => _l10n[locale.languageCode]['invalidHoursNorm'];
  get invalidPhone => _l10n[locale.languageCode]['invalidPhone'];
  get linkNotStart => _l10n[locale.languageCode]['linkNotStart'];
  get noHoursNorm => _l10n[locale.languageCode]['noHoursNorm'];
  get noName => _l10n[locale.languageCode]['noName'];
  get noPersonFamily => _l10n[locale.languageCode]['noPersonFamily'];
  get noPersonName => _l10n[locale.languageCode]['noPersonName'];
  get org => _l10n[locale.languageCode]['org'];
  get orgName => _l10n[locale.languageCode]['orgName'];
  get orgs => _l10n[locale.languageCode]['orgs'];
  get person => _l10n[locale.languageCode]['person'];
  get personBirthday => _l10n[locale.languageCode]['personBirthday'];
  get personFamily => _l10n[locale.languageCode]['personFamily'];
  get personMiddleName => _l10n[locale.languageCode]['personMiddleName'];
  get personName => _l10n[locale.languageCode]['personName'];
  get persons => _l10n[locale.languageCode]['persons'];
  get phone => _l10n[locale.languageCode]['phone'];
  get schedule => _l10n[locale.languageCode]['schedule'];
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
  get withoutTime => _l10n[locale.languageCode]['withoutTime'];
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
