import 'db.dart';
import 'value_type.dart';
import 'package:timesheets/core.dart';

/// Список праздников и переносов выходных дней
final _initHolidays = <Holiday>[
  Holiday(id: 0, date: stringToDate('01.01.2022')),
  Holiday(id: 0, date: stringToDate('02.01.2022')),
  Holiday(id: 0, date: stringToDate('03.01.2022')),
  Holiday(id: 0, date: stringToDate('04.01.2022')),
  Holiday(id: 0, date: stringToDate('05.01.2022')),
  Holiday(id: 0, date: stringToDate('06.01.2022')),
  Holiday(id: 0, date: stringToDate('07.01.2022')),
  Holiday(id: 0, date: stringToDate('08.01.2022')),
  Holiday(id: 0, date: stringToDate('09.01.2022')),
  Holiday(id: 0, date: stringToDate('23.02.2022')),
  Holiday(
      id: 0,
      date: stringToDate('07.03.2022'),
      workday: stringToDate('05.03.2022')),
  Holiday(id: 0, date: stringToDate('08.03.2022')),
  Holiday(id: 0, date: stringToDate('01.05.2022')),
  Holiday(id: 0, date: stringToDate('02.05.2022')),
  Holiday(id: 0, date: stringToDate('03.05.2022')),
  Holiday(id: 0, date: stringToDate('09.05.2022')),
  Holiday(id: 0, date: stringToDate('10.05.2022')),
  Holiday(id: 0, date: stringToDate('12.06.2022')),
  Holiday(id: 0, date: stringToDate('13.06.2022')),
  Holiday(id: 0, date: stringToDate('04.11.2022')),
];

/// Создание пользовательских настроек
Future _initUserSettings(Db db) async {
  await db.settingsDao.insert2(L10n.doubleTapInTimesheet, ValueType.bool,
      boolValue: false, isUserSetting: true);
  await db.settingsDao.insert2(L10n.parusIntegration, ValueType.bool,
      boolValue: true, isUserSetting: true);
}

/// Инициализация новой базы данных
Future initNewDb(Db db) async {
  await db.settingsDao.setActivePeriod(lastDayOfMonth(DateTime.now()));
  for (final holiday in _initHolidays) {
    await db.holidaysDao.insert2(date: holiday.date, workday: holiday.workday);
  }
  await _initUserSettings(db);
}
