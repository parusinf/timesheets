import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/core.dart';
import 'package:http/http.dart' as http;


/// Отправка табеля в Парус или в файл
Future sendTimesheet(
    Org org,
    GroupView group,
    DateTime period,
    List<GroupPersonView> groupPersons,
    List<Attendance> attendances,
    bool parusIntegration,
    ) async
{
  final content = createContent(org, group, period, groupPersons, attendances);
  RegExp exp = RegExp(r'[\s.№]+');
  final periodString = periodToString(period);
  final filename = '${'${org.name}_${group.name}_$periodString'.replaceAll(exp, '_')}.csv';

  var result = '';
  if (parusIntegration) {
    const url = 'https://api.parusinf.ru/c7cb76df-cd86-4c55-833b-6671a7f5d4d8';
    final uri = Uri.parse(url);
    final encoded = encodeCp1251(content);
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
          'package', encoded, filename: filename,
          contentType: MediaType('application', 'octet-stream')));
    final response = await request.send();
    if (response.statusCode == 202) {
      result = await response.stream.bytesToString();
    } else {
      result = '${L10n.sendToParusError}: ${response.reasonPhrase}';
    }
  } else {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await Share.share(content);
    } else {
      final directory = await getTemporaryDirectory();
      final filepath = p.join(directory.path, filename);
      final file = File(filepath);
      final encoded = encodeCp1251(content);
      file.writeAsBytesSync(encoded, flush: true);
      await Share.shareFiles([file.path]);
      await file.delete();
    }
    result = L10n.successUnloadToFile;
  }

  return result;
}

/// Формирование табеля в CSV формате
String createContent(
    Org org,
    GroupView group,
    DateTime period,
    List<GroupPersonView> groupPersons,
    List<Attendance> attendances,
) {
  final buffer = StringBuffer();
  final periodString = periodToString(period);

  // Период
  buffer.write('$periodString;\n');

  // Организация
  buffer.write('${org.name};${trim(org.inn)};\n');

  // Группа
  buffer.write('${group.name};${group.schedule?.code};${group.meals ?? 0};\n');

  // Заголовок табеля
  buffer.write(
      '${L10n.personFamily};${L10n.personName};${L10n.personMiddleName};');
  buffer.write('${L10n.personBirthday};${L10n.phone} 1;${L10n.phone} 2;');
  buffer.write('${L10n.beginDate};${L10n.endDate};');
  for (int day = 1; day <= period.day; day++) {
    buffer.write('$day;');
  }
  buffer.write('\n');

  // Цикл по персонам в группе
  for (final groupPerson in groupPersons) {
    final person = groupPerson.person;
    final personAttendances = attendances
        .where((attendance) => attendance.groupPersonId == groupPerson.id);
    final dates =
    personAttendances.map((attendance) => attendance.date).toList();

    // Персона в группе
    buffer.write('${person.family};${person.name};${trim(person.middleName)};');
    buffer.write(
        '${dateToString(person.birthday)};${trim(person.phone)};${trim(person.phone2)};');
    buffer.write(
        '${dateToString(groupPerson.beginDate)};${dateToString(groupPerson.endDate)};');

    // Цикл по дням текущего периода
    for (int day = 1; day <= period.day; day++) {
      final date = DateTime(period.year, period.month, day);
      // Есть посещаемость в этот день
      if (dates.contains(date)) {
        final attendance = personAttendances
            .firstWhere((attendance) => attendance.date == date);
        buffer.write(doubleToString(attendance.hoursFact));
      }
      buffer.write(';');
    }
    buffer.write('\n');
  }
  return buffer.toString();
}
