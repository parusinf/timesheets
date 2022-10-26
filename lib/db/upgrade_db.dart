import 'package:drift/drift.dart';
import 'package:timesheets/core.dart';
import 'db.dart';
import 'value_type.dart';
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
        "valueType = ValueType.int WHERE name IN ('activeOrg', 'activeSchedule')");
    await db.customStatement("UPDATE settings SET isUserSetting = FALSE, "
        "valueType = ValueType.date WHERE name IN ('activePeriod')");
    await db.settingsDao.insert2(L10n.doubleTapInTimesheet, ValueType.bool,
        boolValue: false, isUserSetting: true);
  }
  if (from < 6) {
    await db.settingsDao.insert2(L10n.parusIntegration, ValueType.bool,
        boolValue: true, isUserSetting: true);
  }
  if (from < 7) {
    await createDefaultSchedule(db);
  }
  if (from < 8) {
    await m.addColumn(db.orgs, db.orgs.lastPay);
    await m.addColumn(db.orgs, db.orgs.totalSum);
  }
}
