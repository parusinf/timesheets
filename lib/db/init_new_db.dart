import 'db.dart';
import 'package:timesheets/core.dart';
import 'schedule_helper.dart';

/// Создание пользовательских настроек
Future initUserSettings(Db db) async {
  await db.settingsDao.insert2(L10n.doubleTapInTimesheet, 1,
      boolValue: false, isUserSetting: true);
  await db.settingsDao.insert2(L10n.useParusIntegration, 1,
      boolValue: true, isUserSetting: true);
  await db.settingsDao.insert2(L10n.isNoShow, 1,
      boolValue: true, isUserSetting: true);
  await db.settingsDao.insert2('activeYearDayOff', 0,
      textValue: null, isUserSetting: false);
}

/// Создание графика по умолчанию
Future createDefaultSchedule(Db db) async {
  await db.schedulesDao.insert2(code: defaultScheduleCode, createDays: true);
}

/// Инициализация новой базы данных
Future initNewDb(Db db) async {
  await db.settingsDao.setActivePeriod(lastDayOfMonth(DateTime.now()));
  await initUserSettings(db);
  await createDefaultSchedule(db);
}
