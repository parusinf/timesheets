import 'package:timesheets/db/db.dart';
import 'package:timesheets/core/tools.dart';

final initHolidays = <Holiday>[
  Holiday(id: 0, date: stringToDate('01.01.2021')),
  Holiday(id: 0, date: stringToDate('02.01.2021')),
  Holiday(id: 0, date: stringToDate('03.01.2021')),
  Holiday(id: 0, date: stringToDate('04.01.2021')),
  Holiday(id: 0, date: stringToDate('05.01.2021')),
  Holiday(id: 0, date: stringToDate('06.01.2021')),
  Holiday(id: 0, date: stringToDate('07.01.2021')),
  Holiday(id: 0, date: stringToDate('08.01.2021')),
  Holiday(id: 0, date: stringToDate('22.02.2021'), workday: stringToDate('20.02.2021')),
  Holiday(id: 0, date: stringToDate('23.02.2021')),
  Holiday(id: 0, date: stringToDate('08.03.2021')),
  Holiday(id: 0, date: stringToDate('01.05.2021')),
  Holiday(id: 0, date: stringToDate('03.05.2021')),
  Holiday(id: 0, date: stringToDate('09.05.2021')),
  Holiday(id: 0, date: stringToDate('10.05.2021')),
  Holiday(id: 0, date: stringToDate('12.06.2021')),
  Holiday(id: 0, date: stringToDate('14.06.2021')),
  Holiday(id: 0, date: stringToDate('04.11.2021')),
  Holiday(id: 0, date: stringToDate('05.11.2021')),
  Holiday(id: 0, date: stringToDate('31.12.2021')),
];