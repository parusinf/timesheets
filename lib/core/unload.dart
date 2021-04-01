import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/core.dart';

/// Выгрузка посещаемости группы за период в CSV файл
Future unloadToFile(
  BuildContext context,
  Org org,
  GroupView group,
  DateTime period,
  List<GroupPersonView> groupPersons,
  List<Attendance> attendances
) async {
  final buffer = new StringBuffer();
  final periodString = periodToString(period);

  // Период
  buffer.write('$periodString;\n');

  // Организация
  buffer.write('${org.name};${trim(org.inn)};\n');

  // Группа
  buffer.write('${group.name};${group.schedule.code};${group.meals ?? 0};\n');

  // Заголовок табеля
  buffer.write('${L10n.personFamily};${L10n.personName};${L10n.personMiddleName};');
  buffer.write('${L10n.personBirthday};${L10n.phone} 1;${L10n.phone} 2;');
  buffer.write('${L10n.beginDate};${L10n.endDate};');
  for (int day = 1; day <= period.day; day++) {
    buffer.write('$day;');
  }
  buffer.write('\n');

  // Цикл по персонам в группе
  for (final groupPerson in groupPersons) {
    final person = groupPerson.person;
    final personAttendances = attendances.where(
            (attendance) => attendance.groupPersonId == groupPerson.id);
    final dates = personAttendances.map((attendance) => attendance.date).toList();

    // Персона в группе
    buffer.write('${person.family};${person.name};${trim(person.middleName)};');
    buffer.write('${dateToString(person.birthday)};${trim(person.phone)};${trim(person.phone2)};');
    buffer.write('${dateToString(groupPerson.beginDate)};${dateToString(groupPerson.endDate)};');

    // Цикл по дням текущего периода
    for (int day = 1; day <= period.day; day++) {
      final date = DateTime(period.year, period.month, day);
      // Есть посещаемость в этот день
      if (dates.contains(date)) {
        final attendance = personAttendances.firstWhere((attendance) => attendance.date == date);
        buffer.write(doubleToString(attendance.hoursFact));
      }
      buffer.write(';');
    }
    buffer.write('\n');
  }

  // Запись файла
  final filename = '${group.name}.csv'.replaceAll(' ', '_');
  final directory = await getTemporaryDirectory();
  final file = File(p.join(directory.path, filename));
  file.writeAsBytesSync(encodeCp1251(buffer.toString()), flush: true);

  // Отправка файла
  Share.shareFiles([file.path], text: '${L10n.timesheet} ${group.name} $periodString');
}