import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/core.dart';

/// Отправка табеля в Парус или вфайл
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

  // Запись файла
  RegExp exp = RegExp(r'[\s.№]+');
  final periodString = periodToString(period);
  final filename = '${'${org.name}_${group.name}_${periodString}_Приложение'
      .replaceAll(exp, '_')}.csv';
  final directory = await getTemporaryDirectory();
  final filepath = p.join(directory.path, filename);
  final file = File(filepath);
  file.writeAsBytesSync(content, flush: true);

  var result = '';
  if (parusIntegration) {
    final uri = Uri.parse('https://api.parusinf.ru/c7cb76df-cd86-4c55-833b-6671a7f5d4d8');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
          'package', filepath,
          contentType: MediaType('application', 'octet-stream')));
    final response = await request.send();
    if (response.statusCode == 202) {
      result = await response.stream.bytesToString();
    } else {
      result = 'Ошибка отправки табеля посещаемости в Парус: ${response.reasonPhrase}';
    }
  } else {
    // Отправка файла
    await Share.shareFiles([file.path]);
    result = 'Табель посещаемости успешно выгружен в файл';
  }

  // Удаление файла
  await file.delete();

  return result;
}

/// Формирование табеля в CSV формате
createContent(
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
  return encodeCp1251(buffer.toString());
}
