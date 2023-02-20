import 'package:drift/drift.dart';
import 'package:timesheets/core.dart';
import 'db.dart';
import 'init_new_db.dart';

Future upgradeDb(Db db, Migrator m, int from, int to) async {
  if (from < 2) {
    await m.addColumn(db.groups, db.groups.meals);
    await m.addColumn(db.persons, db.persons.phone);
    await m.addColumn(db.persons, db.persons.phone2);
  }
  if (from < 3) {
    await db.customStatement('DROP INDEX groups_index');
    await db.customStatement(
        'CREATE UNIQUE INDEX groups_index ON "groups" (orgId, name)');
  }
  if (from < 4) {
    await db.customStatement('''
CREATE TABLE holidays (
  id                 INT NOT NULL PRIMARY KEY AUTOINCREMENT,
  date               DATE NOT NULL,
  workday            DATE
);
CREATE UNIQUE INDEX holidays_index ON holidays (date);
CREATE UNIQUE INDEX holidays_workday_index ON holidays (workday);
''');
  }
  if (from < 5) {
    await m.addColumn(db.settings, db.settings.valueType);
    await m.addColumn(db.settings, db.settings.boolValue);
    await m.addColumn(db.settings, db.settings.realValue);
    await m.addColumn(db.settings, db.settings.isUserSetting);
    await db.customStatement("UPDATE settings SET isUserSetting = FALSE, "
        "valueType = 2 WHERE name IN ('activeOrg', 'activeSchedule')");
    await db.customStatement("UPDATE settings SET isUserSetting = FALSE, "
        "valueType = 4 WHERE name IN ('activePeriod')");
    await db.settingsDao.insert2(L10n.doubleTapInTimesheet, 1,
        boolValue: false, isUserSetting: true);
  }
  if (from < 6) {
    await db.settingsDao.insert2(L10n.useParusIntegration, 1,
        boolValue: true, isUserSetting: true);
  }
  if (from < 7) {
    await createDefaultSchedule(db);
  }
  if (from < 8) {
    await m.addColumn(db.orgs, db.orgs.lastPay);
    await m.addColumn(db.orgs, db.orgs.totalSum);
  }
  if (from < 9) {
    await db.customStatement('ALTER TABLE attendances ADD COLUMN isIllness BOOL NOT NULL DEFAULT FALSE;');
    await db.settingsDao.insert2(L10n.isIllness, 1,
        boolValue: true, isUserSetting: true);
  }
  if (from < 10) {
    await db.customStatement('DROP TABLE holidays;');
    await db.settingsDao.insert2('activeYearDayOff', 0,
        textValue: null, isUserSetting: false);
  }
  if (from < 11) {
    await db.customStatement('ALTER TABLE attendances RENAME COLUMN isIllness TO isNoShowGoodReason;');
    await db.customStatement("UPDATE settings SET name='${L10n.isNoShowGoodReason}' WHERE name='${L10n.isIllness}';");
  }
  if (from < 12) {
    await db.customStatement('ALTER TABLE attendances RENAME COLUMN isNoShowGoodReason TO isNoShow;');
    await db.customStatement("UPDATE settings SET name='${L10n.isNoShow}' WHERE name='${L10n.isNoShowGoodReason}';");
  }
  if (from < 13) {
    await m.addColumn(db.attendances, db.attendances.dayType);
    await db.customStatement("UPDATE settings SET name='${L10n.dayType}' WHERE name='${L10n.isNoShow}';");
  }
  if (from < 14) {
    await db.settingsDao.insert2(L10n.resultsWithoutNoShow, 1,
        boolValue: true, isUserSetting: true);
  }
}
