class L10n {
  static String languageCode = 'ru';

  static const Map<String, Map<String, String>> _l10n = {
    'ru': {
      'addGroup': 'Добавьте группу',
      'addGroupAsInParus': 'Добавьте группу с мнемокодом в точности как в Парусе',
      'addInn': 'Добавьте ИНН организации',
      'addOrg': 'Добавьте организацию',
      'addOrgWithInn': 'Добавьте организацию с ИНН',
      'addPerson': 'Добавьте персону',
      'addPersonToGroup': 'Добавьте персону в группу',
      'addSchedule': 'Добавьте график',
      'beginDate': 'Дата поступления',
      'binding': 'Прикрепление',
      'cancel': 'Отмена',
      'continueAction': 'Продолжить',
      'countryPhoneCode': '+7 ',
      'dataLoading': 'Загрузка данных',
      'days': 'Дней',
      'doubleTapInTimesheet': 'Двойное нажатие в табеле',
      'dupOrgInn': 'Организация с таким ИНН уже добавлена',
      'dupOrgName': 'Организация с таким наименованием уже добавлена',
      'endDate': 'Дата выбытия',
      'eraseAllData': 'Стереть все данные',
      'everyOtherWeek': 'чз/нед',
      'failedToGetInitialLink': 'Не удалось получить начальную ссылку',
      'failedToParseInitialLink': 'Не удалось разобрать начальную ссылку',
      'fileEmptyTimesheetError': 'Начиная с 5-й строки файла должен быть табель посещаемости по одному ребёнку на строку',
      'fileFormatError': 'Ошибка в формате файла',
      'fileGroupError': 'В 3-й строке файла должен быть мнемокод группы, графика и код типа питания',
      'fileHeaderError': 'В заголовке файла должно быть 4 строки',
      'fileNotSelected': 'Файл не выбран',
      'fileOrgError': 'Во 2-й строке файла должен быть мнемокод учреждения и ИНН',
      'filePeriodError': 'В 1-й строке файла должен быть период в формате МЕСЯЦ ГОД',
      'fillPresenceOfAllPersons': 'Заполнить присутствие всех персон',
      'fr': 'пт',
      'from': 'с',
      'group': 'Группа',
      'groupPersons': 'Персоны в группе',
      'groupUpdating': 'Исправление группы',
      'groups': 'Группы',
      'help': 'Справка',
      'hourLetter': 'ч',
      'illness': 'Б',
      'inn': 'ИНН',
      'innLength': 'ИНН должен состоять из 10 цифр',
      'invalidDate': 'Формат даты ДД.ММ.ГГГГ',
      'invalidHoursNorm': 'Некорректная норма часов',
      'invalidPhone': 'Формат телефона (###) ###-##-##',
      'isIllness': 'Отсутствие по болезни',
      'isNoShowGoodReason': 'Неявка по уважительной причине',
      'linkNotStart': 'Ссылка не запускается',
      'meals': 'Питание',
      'meals0': 'Без питания',
      'meals1': 'До 2 лет',
      'meals2': 'От 3 лет',
      'mo': 'пн',
      'name': 'Наименование',
      'noHoursNorm': 'Нет нормы часов',
      'noName': 'Нет наименования',
      'noPersonFamily': 'Нет фамилии',
      'noPersonName': 'Нет имени',
      'noShowGoodReason': 'НУ',
      'noValue': 'Отсутствует значение',
      'org': 'Организация',
      'orgs': 'Организации',
      'permissionDenied': 'Разрешение не получено',
      'person': 'Персона',
      'personBirthday': 'Дата рождения',
      'personFamily': 'Фамилия',
      'personMiddleName': 'Отчество',
      'personName': 'Имя',
      'persons': 'Персоны',
      'phone': 'Телефон',
      'receiveFromParusError': 'Ошибка получения табеля посещаемости из Паруса',
      'receiveTimesheet': 'Получить табель',
      'sa': 'сб',
      'schedule': 'График',
      'scheduleCodeException': 'Ошибка разбора мнемокода графика',
      'scheduleHourSumException': 'Сумма часов в графике должна быть больше ноля',
      'schedules': 'Графики',
      'selectPerson': 'Выберите персону',
      'selectSchedule': 'Выберите график',
      'sendTimesheet': 'Отправить табель',
      'sendToParusError': 'Ошибка отправки табеля посещаемости в Парус',
      'setInn': 'Для оплаты требуется ИНН организации',
      'settings': 'Настройки',
      'su': 'вс',
      'successLoadFromFile': 'Табель посещаемости успешно загружен из файла',
      'successLoadFromParus': 'Табель посещаемости успешно загружен из Паруса',
      'successUnloadToFile': 'Табель посещаемости успешно выгружен в файл',
      'support': 'Техподдержка',
      'supportPayment': 'Оплата техподдержки',
      'th': 'чт',
      'timesheet': 'Табель посещаемости',
      'timesheets': 'Табели посещаемости',
      'to': 'по',
      'tu': 'вт',
      'uniqueDay': 'Уже есть такой день',
      'uniqueGroup': 'Уже есть такая группа',
      'uniqueGroupPerson': 'Уже есть такая персона в группе',
      'uniquePerson': 'Уже есть такая персона',
      'uniqueSchedule': 'Уже есть такой график',
      'unknown': 'Неизвестно',
      'useParusIntegration': 'Интеграция с Парусом',
      'we': 'ср',
      'withoutInn': 'Без ИНН',
      'withoutTime': 'без срока',
      'workday': 'Перенос рабочего дня на',
    }
  };
  static get addGroup => _l10n[languageCode]!['addGroup'];
  static get addGroupAsInParus => _l10n[languageCode]!['addGroupAsInParus'];
  static get addInn => _l10n[languageCode]!['addInn'];
  static get addOrg => _l10n[languageCode]!['addOrg'];
  static get addOrgWithInn => _l10n[languageCode]!['addOrgWithInn'];
  static get addPerson => _l10n[languageCode]!['addPerson'];
  static get addPersonToGroup => _l10n[languageCode]!['addPersonToGroup'];
  static get addSchedule => _l10n[languageCode]!['addSchedule'];
  static get beginDate => _l10n[languageCode]!['beginDate'];
  static get binding => _l10n[languageCode]!['binding'];
  static get cancel => _l10n[languageCode]!['cancel'];
  static get continueAction => _l10n[languageCode]!['continueAction'];
  static get countryPhoneCode => _l10n[languageCode]!['countryPhoneCode'];
  static get dataLoading => _l10n[languageCode]!['dataLoading'];
  static get days => _l10n[languageCode]!['days'];
  static get doubleTapInTimesheet => _l10n[languageCode]!['doubleTapInTimesheet'];
  static get dupOrgInn => _l10n[languageCode]!['dupOrgInn'];
  static get dupOrgName => _l10n[languageCode]!['dupOrgName'];
  static get endDate => _l10n[languageCode]!['endDate'];
  static get eraseAllData => _l10n[languageCode]!['eraseAllData'];
  static get everyOtherWeek => _l10n[languageCode]!['everyOtherWeek'];
  static get failedToGetInitialLink => _l10n[languageCode]!['failedToGetInitialLink'];
  static get failedToParseInitialLink => _l10n[languageCode]!['failedToParseInitialLink'];
  static get fileEmptyTimesheetError => _l10n[languageCode]!['fileEmptyTimesheetError'];
  static get fileFormatError => _l10n[languageCode]!['fileFormatError'];
  static get fileGroupError => _l10n[languageCode]!['fileGroupError'];
  static get fileHeaderError => _l10n[languageCode]!['fileHeaderError'];
  static get fileNotSelected => _l10n[languageCode]!['fileNotSelected'];
  static get fileOrgError => _l10n[languageCode]!['fileOrgError'];
  static get filePeriodError => _l10n[languageCode]!['filePeriodError'];
  static get fillPresenceOfAllPersons => _l10n[languageCode]!['fillPresenceOfAllPersons'];
  static get fr => _l10n[languageCode]!['fr'];
  static get from => _l10n[languageCode]!['from'];
  static get group => _l10n[languageCode]!['group'];
  static get groupPersons => _l10n[languageCode]!['groupPersons'];
  static get groups => _l10n[languageCode]!['groups'];
  static get help => _l10n[languageCode]!['help'];
  static get hourLetter => _l10n[languageCode]!['hourLetter'];
  static get illness => _l10n[languageCode]!['illness'];
  static get inn => _l10n[languageCode]!['inn'];
  static get innLength => _l10n[languageCode]!['innLength'];
  static get invalidDate => _l10n[languageCode]!['invalidDate'];
  static get invalidHoursNorm => _l10n[languageCode]!['invalidHoursNorm'];
  static get invalidPhone => _l10n[languageCode]!['invalidPhone'];
  static get isIllness => _l10n[languageCode]!['isIllness'];
  static get isNoShowGoodReason => _l10n[languageCode]!['isNoShowGoodReason'];
  static get linkNotStart => _l10n[languageCode]!['linkNotStart'];
  static get meals => _l10n[languageCode]!['meals'];
  static get meals0 => _l10n[languageCode]!['meals0'];
  static get meals1 => _l10n[languageCode]!['meals1'];
  static get meals2 => _l10n[languageCode]!['meals2'];
  static get mo => _l10n[languageCode]!['mo'];
  static get name => _l10n[languageCode]!['name'];
  static get noHoursNorm => _l10n[languageCode]!['noHoursNorm'];
  static get noName => _l10n[languageCode]!['noName'];
  static get noPersonFamily => _l10n[languageCode]!['noPersonFamily'];
  static get noPersonName => _l10n[languageCode]!['noPersonName'];
  static get noShowGoodReason => _l10n[languageCode]!['noShowGoodReason'];
  static get noValue => _l10n[languageCode]!['noValue'];
  static get org => _l10n[languageCode]!['org'];
  static get orgs => _l10n[languageCode]!['orgs'];
  static get permissionDenied => _l10n[languageCode]!['permissionDenied'];
  static get person => _l10n[languageCode]!['person'];
  static get personBirthday => _l10n[languageCode]!['personBirthday'];
  static get personFamily => _l10n[languageCode]!['personFamily'];
  static get personMiddleName => _l10n[languageCode]!['personMiddleName'];
  static get personName => _l10n[languageCode]!['personName'];
  static get persons => _l10n[languageCode]!['persons'];
  static get phone => _l10n[languageCode]!['phone'];
  static get receiveFromParusError => _l10n[languageCode]!['receiveFromParusError'];
  static get receiveTimesheet => _l10n[languageCode]!['receiveTimesheet'];
  static get sa => _l10n[languageCode]!['sa'];
  static get schedule => _l10n[languageCode]!['schedule'];
  static get scheduleCodeException => _l10n[languageCode]!['scheduleCodeException'];
  static get scheduleHourSumException => _l10n[languageCode]!['scheduleHourSumException'];
  static get schedules => _l10n[languageCode]!['schedules'];
  static get selectPerson => _l10n[languageCode]!['selectPerson'];
  static get selectSchedule => _l10n[languageCode]!['selectSchedule'];
  static get sendTimesheet => _l10n[languageCode]!['sendTimesheet'];
  static get sendToParusError => _l10n[languageCode]!['sendToParusError'];
  static get setInn => _l10n[languageCode]!['setInn'];
  static get settings => _l10n[languageCode]!['settings'];
  static get su => _l10n[languageCode]!['su'];
  static get successLoadFromFile => _l10n[languageCode]!['successLoadFromFile'];
  static get successLoadFromParus => _l10n[languageCode]!['successLoadFromParus'];
  static get successUnloadToFile => _l10n[languageCode]!['successUnloadToFile'];
  static get support => _l10n[languageCode]!['support'];
  static get supportPayment => _l10n[languageCode]!['supportPayment'];
  static get th => _l10n[languageCode]!['th'];
  static get timesheet => _l10n[languageCode]!['timesheet'];
  static get timesheets => _l10n[languageCode]!['timesheets'];
  static get to => _l10n[languageCode]!['to'];
  static get tu => _l10n[languageCode]!['tu'];
  static get uniqueDay => _l10n[languageCode]!['uniqueDay'];
  static get uniqueGroup => _l10n[languageCode]!['uniqueGroup'];
  static get uniqueGroupPerson => _l10n[languageCode]!['uniqueGroupPerson'];
  static get uniquePerson => _l10n[languageCode]!['uniquePerson'];
  static get uniqueSchedule => _l10n[languageCode]!['uniqueSchedule'];
  static get unknown => _l10n[languageCode]!['unknown'];
  static get useParusIntegration => _l10n[languageCode]!['useParusIntegration'];
  static get we => _l10n[languageCode]!['we'];
  static get withoutInn => _l10n[languageCode]!['withoutInn'];
  static get withoutTime => _l10n[languageCode]!['withoutTime'];
  static get workday => _l10n[languageCode]!['workday'];
}
