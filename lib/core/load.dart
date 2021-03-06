import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Выбор CSV файла и загрузка табеля посещаемости
Future pickAndLoadFromFile(BuildContext context) async {
  if (!(await Permission.storage.request().isGranted)) {
    throw L10n.permissionDenied;
  }
  FilePickerResult result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );
  if (result == null) {
    throw L10n.fileNotSelected;
  }
  await loadFromFile(context, result.files.single.path);
}

/// Загрузка CSV файла
Future loadFromFile(BuildContext context, String fileName) async {
  if (!(await Permission.storage.request().isGranted)) {
    throw L10n.permissionDenied;
  }
  final file = File(fileName);
  final content = decodeCp1251(file.readAsBytesSync());
  await parseContent(context, content);
}

/// Разбор и загрузка контента
Future parseContent(BuildContext context, String content) async {
  final bloc = Provider.of<Bloc>(context, listen: false);
  final lines = content.split('\n');
  if (lines.length < 4) {
    throw L10n.fileFormatError;
  }

  // Период
  final period = stringToPeriod(context, lines[0].split(';')[0]);
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
  var org = await bloc.db.orgsDao.find(orgName);
  if (org == null) {
    org = await bloc.insertOrg(name: orgName, inn: orgInn);
  } else {
    bloc.setActiveOrg(org);
    if (isNeedStringUpdate(org.inn, orgInn)) {
      bloc.db.orgsDao.update2(Org(
          id: org?.id,
          name: org.name,
          inn: orgInn
      ));
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
  var schedule = await bloc.db.schedulesDao.find(scheduleCode);
  if (schedule == null) {
    schedule = await bloc.insertSchedule(code: scheduleCode, createDays: true);
  }
  var group = await bloc.db.groupsDao.find(groupName, org, schedule);
  if (group == null) {
    group = await bloc.insertGroup(name: groupName, schedule: schedule, meals: groupMeals);
  } else {
    bloc.setActiveGroup(group);
    if (group.meals != groupMeals) {
      bloc.db.groupsDao.update2(Group(
          id: group?.id,
          orgId: group.orgId,
          name: group.name,
          scheduleId: group.scheduleId,
          meals: groupMeals
      ));
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
    final personBirthday = stringToDate(personColumns[3]);
    final personPhone = trim(personColumns[4]);
    final personPhone2 = trim(personColumns[5]);
    if (personFamily == null || personName == null) {
      throw L10n.fileFormatError;
    }
    var person = await bloc.db.personsDao.find(personFamily, personName, personMiddleName, personBirthday);
    if (person == null) {
      person = await bloc.insertPerson(
        family: personFamily,
        name: personName,
        middleName:
        personMiddleName,
        birthday: personBirthday,
        phone: personPhone,
        phone2: personPhone2,
      );
    } else {
      if (isNeedStringUpdate(person.phone, personPhone) ||
          isNeedStringUpdate(person.phone2, personPhone2)) {
        bloc.db.personsDao.update2(Person(
          id: person?.id,
          family: person.family,
          name: person.name,
          middleName: person.middleName,
          birthday: person.birthday,
          phone: isNeedStringUpdate(person.phone, personPhone) ? personPhone : person.phone,
          phone2: isNeedStringUpdate(person.phone2, personPhone2) ? personPhone2 : person.phone2,
        ));
      }
    }

    // Персона в группе
    final groupPersonBeginDate = stringToDate(personColumns[6]);
    final groupPersonEndDate = stringToDate(personColumns[7]);
    var groupPerson = await bloc.db.groupPersonsDao.find(group, person);
    if (groupPerson == null) {
      groupPerson = await bloc.insertGroupPerson(
        group: group,
        person: person,
        beginDate: groupPersonBeginDate,
        endDate: groupPersonEndDate,
      );
    } else {
      if (isNeedDateUpdate(groupPerson.beginDate, groupPersonBeginDate) ||
          isNeedDateUpdate(groupPerson.endDate, groupPersonEndDate)) {
        bloc.db.groupPersonsDao.update2(GroupPerson(
          id: groupPerson.id,
          groupId: groupPerson.groupId,
          personId: groupPerson.personId,
          beginDate: isNeedDateUpdate(groupPerson.beginDate, groupPersonBeginDate) ? groupPersonBeginDate : groupPerson.beginDate,
          endDate: isNeedDateUpdate(groupPerson.endDate, groupPersonEndDate) ? groupPersonEndDate : groupPerson.endDate,
        ));
      }
    }

    // Посещаемость персоны в группе
    for (int day = 1; day <= period.day; day++) {
      final date = DateTime(period.year, period.month, day);
      final hoursFact = stringToDouble(personColumns[7 + day]);
      final attendanceSpecified = hoursFact != null && hoursFact > 0.0;
      var attendance = await bloc.db.attendancesDao.find(groupPerson, date);
      if (attendance == null && attendanceSpecified) {
        attendance = await bloc.insertAttendance(
          groupPerson: groupPerson,
          date: date,
          hoursFact: hoursFact,
        );
      } else {
        if (attendance != null) {
          if (attendanceSpecified && attendance.hoursFact != hoursFact) {
            await bloc.db.attendancesDao.update2(attendance);
          }
        }
      }
    }
  }
}