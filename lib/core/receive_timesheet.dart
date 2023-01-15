import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:http/http.dart' as http;

/// Выбор CSV файла и загрузка табеля посещаемости
Future pickAndReceiveFromFile(Bloc bloc) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv', 'txt'],
    allowMultiple: false,
  );
  if (result != null && result.files.isNotEmpty) {
    final file = File(result.files.first.path!);
    return await receiveFromFile(bloc, file);
  } else {
    return L10n.fileNotSelected;
  }
}

/// Загрузка CSV файла
Future receiveFromFile(Bloc bloc, File file) async {
  final bytes = file.readAsBytesSync();
  var content = decodeCp1251(bytes);
  var monthStr = content.substring(0, content.indexOf(' '));
  if (!isMonth(monthStr)) {
    content = utf8.decode(bytes);
    monthStr = content.substring(0, content.indexOf(' '));
    if (!isMonth(monthStr)) {
      throw L10n.fileFormatError;
    }
  }
  await receiveFromContent(bloc, content);
  return L10n.successLoadFromFile;
}

Future receiveFromParus(Bloc bloc) async {
  final org = bloc.activeOrg.valueOrNull;
  if (org == null) {
    throw L10n.addOrgWithInn;
  }
  if (isEmpty(org.inn)) {
    throw L10n.addInn;
  }
  final group = bloc.activeGroup.valueOrNull;
  if (group == null) {
    throw L10n.addGroupAsInParus;
  }
  final url = 'https://api.parusinf.ru/${getAppCode()}/receive?org_inn=${org.inn}&group=${group.name}';
  final uri = Uri.parse(url);
  final request = http.MultipartRequest('GET', uri);
  final response = await request.send();
  var result = '';
  if (response.statusCode == 200) {
    final encoded = await response.stream.toBytes();
    final lines = decodeCp1251(encoded).split('\n');
    final content = lines.getRange(5, lines.length-2).join('\n');
    await receiveFromContent(bloc, content);
    result = L10n.successLoadFromParus;
  } else {
    final responseText = await response.stream.bytesToString();
    result = '${L10n.receiveFromParusError}: $responseText';
  }
  return result;
}

bool isMonth(String str) {
  return ['ЯНВАРЬ', 'ФЕВРАЛЬ', 'МАРТ', 'АПРЕЛЬ', 'МАЙ', 'ИЮНЬ', 'ИЮЛЬ',
    'АВГУСТ', 'СЕНТЯБРЬ', 'ОКТЯБРЬ', 'НОЯБРЬ', 'ДЕКАБРЬ'].contains(str);
}

/// Разбор и загрузка контента
Future receiveFromContent(Bloc bloc, String content) async {
  final lines = content.split('\n');
  if (lines.length < 4) {
    throw L10n.fileFormatError;
  }

  // Период
  final period = stringToPeriod(lines[0].split(';')[0]);
  if (period == null) {
    throw L10n.fileFormatError;
  }
  bloc.setActivePeriod(period);

  // Организация
  final orgColumns = lines[1].split(';');
  final orgName = trim(orgColumns[0]);
  final orgInn = trim(orgColumns[1]);
  if (orgName == null) {
    throw L10n.fileFormatError;
  }
  var org = await bloc.db.orgsDao.findByInn(orgInn);
  if (org == null) {
    org = await bloc.insertOrg(name: orgName, inn: orgInn);
  } else {
    bloc.setActiveOrg(org);
    if (!isEqual(org.name, orgName)) {
      await bloc.db.orgsDao.update2(Org(id: org.id, name: orgName, inn: orgInn));
    }
  }

  // Группа
  final groupColumns = lines[2].split(';');
  final groupName = trim(groupColumns[0]);
  final scheduleCode = trim(groupColumns[1]);
  final groupMeals = stringToInt(groupColumns[2]);
  if (groupName == null || scheduleCode == null || groupMeals == null) {
    throw L10n.fileFormatError;
  }
  // График
  final schedule = await bloc.db.schedulesDao.find(scheduleCode) ??
      await bloc.insertSchedule(scheduleCode);
  var group = await bloc.db.groupsDao.find(groupName, org);
  if (group == null) {
    group = await bloc.insertGroup(
        name: groupName, schedule: schedule, meals: groupMeals);
  } else {
    await bloc.setActiveGroup(group);
    await bloc.setActiveSchedule(schedule);
    if (group.scheduleId != schedule.id || group.meals != groupMeals) {
      await bloc.db.groupsDao.update2(Group(
          id: group?.id,
          orgId: group.orgId,
          name: group.name,
          scheduleId: schedule.id,
          meals: groupMeals));
    }
  }

  // Персоны
  for (int i = 4; i < lines.length; i++) {
    if (trim(lines[i]) == '') {
      break;
    }
    // Персона
    final personColumns = lines[i].split(';');
    final personFamily = trim(personColumns[0]);
    final personName = trim(personColumns[1]);
    final personMiddleName = trim(personColumns[2]);
    final personBirthday = stringToDateOrNull(personColumns[3]);
    final personPhone = trim(personColumns[4]);
    final personPhone2 = trim(personColumns[5]);
    if (personFamily == null || personName == null) {
      throw L10n.fileFormatError;
    }
    var person = await bloc.db.personsDao
        .find(personFamily, personName, personMiddleName, personBirthday);
    if (person == null) {
      person = await bloc.insertPerson(
        family: personFamily,
        name: personName,
        middleName: personMiddleName,
        birthday: personBirthday,
        phone: personPhone,
        phone2: personPhone2,
      );
    } else {
      if (!isEqual(person.phone, personPhone) ||
          !isEqual(person.phone2, personPhone2) ||
          !isEqual(person.middleName, personMiddleName) ||
          !isDateEqual(person.birthday, personBirthday))
      {
        await bloc.db.personsDao.update2(Person(
          id: person.id,
          family: person.family,
          name: person.name,
          middleName: personMiddleName,
          birthday: personBirthday,
          phone: personPhone,
          phone2: personPhone2,
        ));
      }
    }

    // Персона в группе
    final groupPersonBeginDate = stringToDateOrNull(personColumns[6]);
    final groupPersonEndDate = stringToDateOrNull(personColumns[7]);
    var groupPerson = await bloc.db.groupPersonsDao.find(group, person);
    if (groupPerson == null) {
      groupPerson = await bloc.insertGroupPerson(
        group: group,
        person: person,
        beginDate: groupPersonBeginDate,
        endDate: groupPersonEndDate,
      );
    } else {
      if (!isDateEqual(groupPerson.beginDate, groupPersonBeginDate) ||
          !isDateEqual(groupPerson.endDate, groupPersonEndDate)) {
        await bloc.db.groupPersonsDao.update2(GroupPerson(
          id: groupPerson.id,
          groupId: groupPerson.groupId,
          personId: groupPerson.personId,
          beginDate:
              !isDateEqual(groupPerson.beginDate, groupPersonBeginDate)
                  ? groupPersonBeginDate
                  : groupPerson.beginDate,
          endDate: !isDateEqual(groupPerson.endDate, groupPersonEndDate)
              ? groupPersonEndDate
              : groupPerson.endDate,
        ));
      }
    }

    // Посещаемость персоны в группе
    for (int day = 1; day <= period.day; day++) {
      final date = DateTime(period.year, period.month, day);
      final attendanceValue = personColumns[7 + day];
      var attendance = await bloc.db.attendancesDao.find(groupPerson, date);

      // Посещаемость загружена
      if (isNotEmpty(attendanceValue)) {
        double hoursFact = 0.0;
        bool isIllness = false;

        // Пропуск по болезни
        if (attendanceValue == L10n.b) {
          isIllness = true;
        // Часы посещения
        } else {
          hoursFact = stringToDouble(attendanceValue)!;
        }

        // Посещаемости нет - добавляем
        if (attendance == null) {
          attendance = await bloc.insertAttendance(
            groupPerson: groupPerson,
            date: date,
            hoursFact: hoursFact,
            isIllness: isIllness,
          );
        // Посещаемость есть, но отличается - исправляем
        } else if (attendance.hoursFact != hoursFact) {
          await bloc.db.attendancesDao.update2(
            Attendance(
              id: attendance.id,
              groupPersonId: attendance.groupPersonId,
              date: date,
              hoursFact: hoursFact,
              isIllness: isIllness,
            )
          );
        }
      }
    }
  }
}
