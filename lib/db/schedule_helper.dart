import 'dart:collection';
import 'package:timesheets/core.dart';

const defaultScheduleCode = 'пн-вс 1ч';

/// Формирование списка часов по коду графика
List<double> parseScheduleCode(String code) {
  var hours = <double>[];
  if (code.contains(L10n.everyOtherWeek)) {
    hours = List<double>.generate(14, (i) => 0.0);
  } else {
    hours = List<double>.generate(7, (i) => 0.0);
  }
  final parts = code.split(';');
  if (parts.length > 1) {
    // пн,вт 1ч;чт 2ч
    for (var part in parts) {
      _parseScheduleCode(hours, part);
    }
  } else {
    // пн,вт 1ч
    _parseScheduleCode(hours, code);
  }
  return hours;
}

/// Формирование кода графика по списку часов
String createScheduleCode(List<double> hours) {
  if (hours.reduce((a, b) => a + b) == 0.0) {
    throw FormatException(L10n.scheduleHourSumException);
  }
  final parts = <String>[];
  final week = _createOneWeekDays(hours, 0);
  if (hours.length == 7) {
    week.forEach((hour, days) {
      parts.add(days.join(',') + ' ${doubleToString(hour)}${L10n.hourLetter}');
    });
  } else {
    final week2 = _createOneWeekDays(hours, 7);
    week.forEach((hour, days) {
      week2.forEach((hour2, days2) {
        if (hour == hour2) {
          final daysStr = days.join(',');
          final days2Str = days2.join(',');
          if (daysStr == days2Str) {
            parts.add('$daysStr $hour${L10n.hourLetter}');
          } else {
            parts.add(
                '$daysStr/$days2Str ${L10n.everyOtherWeek} ${doubleToString(hour)}${L10n.hourLetter}');
          }
        }
      });
    });
  }
  return parts.join(';');
}

/// Формирование списка часов одному количеству часов
void _parseScheduleCode(List<double> hours, String code) {
  if (code.contains(L10n.everyOtherWeek)) {
    // вт/ср чз/нед 1ч
    final daysHour = code
        .replaceFirst('${L10n.everyOtherWeek} ', '')
        .split(' '); // ['вт/ср','1ч']
    if (daysHour.length != 2) {
      throw FormatException('${L10n.scheduleCodeException}: $code');
    }
    final weeks = daysHour[0].split('/'); // ['вт','ср']
    if (weeks.length != 2) {
      throw FormatException('${L10n.scheduleCodeException}: $code');
    }
    _parseWeek(hours, weeks[0], daysHour[1], 0);
    _parseWeek(hours, weeks[1], daysHour[1], 7);
  } else {
    // пн,вт 1ч
    final daysHour = code.split(' '); // ['пн,вт','1ч']
    if (daysHour.length != 2) {
      throw FormatException('${L10n.scheduleCodeException}: $code');
    }
    if (daysHour.length == 1) {
      _parseWeek(hours, '', daysHour[1], 0);
    } else {
      _parseWeek(hours, daysHour[0], daysHour[1], 0);
      if (hours.length == 14) {
        _parseWeek(hours, daysHour[0], daysHour[1], 7);
      }
    }
  }
}

/// Разбор строки с днями недели и строки с часами с учётом чередования недель
void _parseWeek(
    List<double> hours, String daysString, String hourString, int shift) {
  final hour = double.parse(
      hourString.replaceFirst(L10n.hourLetter, '').replaceFirst(',', '.'));
  // пн-вс
  if (daysString.contains('-')) {
    final dayRange = daysString.split('-');
    final startDay = abbrWeekdays.indexOf(dayRange[0]);
    final endDay = abbrWeekdays.indexOf(dayRange[1]);
    if (startDay <= endDay) {
      for (int day = startDay; day <= endDay; day++) {
        hours[day + shift] = hour;
      }
    // вс-пн
    } else {
      for (int day = startDay; day < 7; day++) {
        hours[day + shift] = hour;
      }
      for (int day = 0; day <= endDay; day++) {
        hours[day + shift] = hour;
      }
    }
  // пн,вт,ср
  } else {
    for (int day = 0; day < 7; day++) {
      if (daysString == '' || daysString.contains(abbrWeekdays[day])) {
        hours[day + shift] = hour;
      }
    }
  }
}

/// Формирование дней одной недели
_createOneWeekDays(List<double> hours, int offset) {
  final hoursMap = SplayTreeMap<double, List<String>>();
  hours.sublist(offset, offset + 7).where((e) => e > 0).toSet().forEach((hour) {
    hoursMap[hour] = [];
  });
  for (int day = offset; day < offset + 7; day++) {
    if (hoursMap.containsKey(hours[day])) {
      hoursMap[hours[day]]?.add(abbrWeekdays[day % 7]);
    }
  }
  return hoursMap;
}
