import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_share_content/flutter_share_content.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/core/tools.dart';
import 'package:timesheets/core/cp1251.dart';

/// Выгрузка посещаемости группы за период в CSV файл
Future unloadFile(
  Org org,
  GroupView group,
  DateTime period,
  List<GroupPersonView> groupPersons,
  List<Attendance> attendances
) async {
  if (await Permission.storage.request().isGranted) {
    var buffer = new StringBuffer();

    // Заголовок
    buffer.write('${periodToString(period)};');
    for (int day = 1; day <= period.day; day++) {
      buffer.write('$day;');
    }
    buffer.write('\n');

    // Цикл по персонам в группе
    for (final groupPerson in groupPersons) {
      final personAttendances = attendances.where(
              (attendance) => attendance.groupPersonId == groupPerson.person.id);
      final dates = personAttendances.map((attendance) => attendance.date).toList();

      // ФИО
      buffer.write('${fio(groupPerson.person)};');

      // Цикл по дням текущего периода
      for (int day = 1; day <= period.day; day++) {
        final date = DateTime(period.year, period.month, day);
        // Есть посещаемость в этот день
        if (dates.contains(date)) {
          final attendance = personAttendances.firstWhere((attendance) => attendance.date == date);
          buffer.write(attendance.hoursFact.toString());
        }
        buffer.write(';');
      }
      buffer.write('\n');
    }

    // Запись файла
    final filename = '${group.name}~${org.name}.csv'.replaceAll(' ', '_');
    final dbFolder = await getExternalStorageDirectory();
    final file = File(p.join(dbFolder.path, filename));
    file.writeAsBytesSync(encodeCp1251(buffer.toString()), flush: true);

    // Отправка файла
    FlutterShareContent.shareContent(imageUrl: file.path, msg: 'Табель посещаемости');
  }
}