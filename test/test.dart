import 'package:timesheets/database/database.dart';
import 'package:timesheets/database/schedule_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Тесты', () {
    test('Графики', () {
      var schedule = Schedule(id: 1, code: 'вт,чт 1ч');
      var hours = parseScheduleCode(schedule.code);
      expect(schedule.code, createScheduleCode(hours));
      expect(hours[0], 0.0);
      expect(hours[1], 1.0);
      expect(hours[2], 0.0);
      expect(hours[3], 1.0);

      schedule = Schedule(id: 2, code: 'вт 0.5ч;пн,ср 1ч');
      hours = parseScheduleCode(schedule.code);
      expect(schedule.code, createScheduleCode(hours));
      expect(hours[0], 1.0);
      expect(hours[1], 0.5);
      expect(hours[2], 1.0);

      schedule = Schedule(id: 3, code: 'пн,вт/ср,чт чз/нед 1ч;пт,сб 2ч');
      hours = parseScheduleCode(schedule.code);
      expect(schedule.code, createScheduleCode(hours));
      expect(hours[0], 1.0);
      expect(hours[1], 1.0);
      expect(hours[2], 0.0);
      expect(hours[3], 0.0);
      expect(hours[4], 2.0);
      expect(hours[5], 2.0);
      expect(hours[6], 0.0);
      expect(hours[7], 0.0);
      expect(hours[8], 0.0);
      expect(hours[9], 1.0);
      expect(hours[10], 1.0);
      expect(hours[11], 2.0);
      expect(hours[12], 2.0);
      expect(hours[13], 0.0);
    });

    /*test('Посещаемость', () {
      final days = Days();
      days[31 - 1] = true;
      expect(days[31 - 1], true);
      expect(days.toString(), '1'.padLeft(31, '0'));

      final timesheet1 = Timesheet(days: days);
      final timesheet2 = Timesheet.fromMap(timesheet1.toMap());
      expect(timesheet1.days.toString(), timesheet2.days.toString());
    });*/
  });
}