import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Загрузка посещаемости группы за период из CSV файла
Future loadFile(BuildContext context) async {
  final l10n = L10n.of(context);
  FilePickerResult result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['csv'],
  );
  if (result == null) {
    throw l10n.fileNotSelected;
  }
  final file = File(result.files.single.path);
  final content = decodeCp1251(file.readAsBytesSync()).split('\n');
  if (content.length < 4) {
    throw l10n.fileFormatError;
  }
  final bloc = Provider.of<Bloc>(context, listen: false);

  // Организация
  final orgColumns = content[0].split(';');
  final orgName = orgColumns[0];
  final orgInn = orgColumns[1];
  if (orgName == null) {
    throw l10n.fileFormatError;
  }
  var org = await bloc.db.orgsDao.find(orgName);
  if (org == null) {
    org = await bloc.insertOrg(name: orgName, inn: orgInn);
  } else {
    if (org.inn != orgInn) {
      bloc.db.orgsDao.update2(Org(
          id: org.id,
          name: org.name,
          inn: orgInn
      ));
    }
  }

  // Группа
  final groupColumns = content[1].split(';');
  final groupName = groupColumns[0];
  final scheduleCode = groupColumns[1];
  final groupMeals = stringToInt(groupColumns[2]);
  if (groupName == null || scheduleCode == null || groupMeals == null) {
    throw l10n.fileFormatError;
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
    if (group.meals != groupMeals) {
      bloc.db.groupsDao.update2(Group(
          id: group.id,
          orgId: group.orgId,
          name: group.name,
          scheduleId: group.scheduleId,
          meals: groupMeals
      ));
    }
  }

  // Период
  final period = stringToPeriod(context, content[2].split(';')[0]);
  bloc.setActivePeriod(period);

  // Персоны
  for (int i = 4; i < content.length; i++) {
    if (trim(content[i]) == '') {
      break;
    }
    // Персона
    final personColumns = content[i].split(';');
    final personFamily = personColumns[0];
    final personName = personColumns[1];
    final personMiddleName = personColumns[2];
    final personBirthday = stringToDate(personColumns[3]);
    final personPhone = personColumns[4];
    final personPhone2 = personColumns[5];
    if (personFamily == null || personName == null) {
      throw l10n.fileFormatError;
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
      if (person.phone != personPhone || person.phone2 != personPhone2) {
        bloc.db.personsDao.update2(Person(
          id: person.id,
          family: person.family,
          name: person.name,
          middleName: person.middleName,
          birthday: person.birthday,
          phone: personPhone,
          phone2: personPhone2,
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
      if (groupPerson.beginDate != groupPersonBeginDate || groupPerson.endDate != groupPersonEndDate) {
        bloc.db.groupPersonsDao.update2(GroupPerson(
          id: groupPerson.id,
          groupId: groupPerson.groupId,
          personId: groupPerson.personId,
          beginDate: groupPersonBeginDate,
          endDate: groupPersonEndDate,
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
          if (!attendanceSpecified) {
            await bloc.deleteAttendance(attendance);
          } else {
            if (attendanceSpecified && attendance.hoursFact != hoursFact) {
              await bloc.db.attendancesDao.update2(attendance);
            }
          }
        }
      }
    }
  }
}