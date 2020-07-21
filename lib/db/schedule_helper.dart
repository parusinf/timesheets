import 'dart:collection';

/// Формирование списка часов по коду графика
List<double> parseScheduleCode(String code) {
  var hours = List<double>();
  if (code.contains(_inWeekStr)) {
    hours = List<double>.generate(14, (i) => 0.0);
  } else {
    hours = List<double>.generate(7, (i) => 0.0);
  }
  final parts = code.split(';');
  if (parts.length > 1) { // пн,вт 1ч;чт 2ч
    parts.forEach((part) => _parseScheduleCode(hours, part));
  } else { // пн,вт 1ч
    _parseScheduleCode(hours, code);
  }
  return hours;
}

/// Формирование кода графика по списку часов
String createScheduleCode(List<double> hours) {
  assert(hours.every((e) => e != null));
  assert(hours.reduce((a, b) => a + b) != 0);
  final parts = List<String>();
  final week = _createOneWeekDays(hours, 0);
  if (hours.length == 7) {
    week.forEach((hour, days) {
      parts.add(days.join(',') + ' $hour$_hourStr');
    });
  } else {
    final week2 = _createOneWeekDays(hours, 7);
    week.forEach((hour, days) {
      week2.forEach((hour2, days2) {
        if (hour == hour2) {
          final daysStr = days.join(',');
          final days2Str = days2.join(',');
          if (daysStr == days2Str) {
            parts.add(daysStr + ' $hour$_hourStr');
          } else {
            parts.add(
                daysStr + '/' + days2Str + ' $_inWeekStr $hour$_hourStr');
          }
        }
      });
    });
  }
  return parts.join(';');
}

/// Формирование списка часов одному количеству часов
void _parseScheduleCode(List<double> hours, String code) {
  if (code.contains(_inWeekStr)) { // вт/ср чз/нед 1ч
    final daysHour = code.replaceFirst('$_inWeekStr ', '').split(
        ' '); // ['вт/ср','1ч']
    assert(daysHour.length == 2);
    final weeks = daysHour[0].split('/'); // ['вт','ср']
    assert(weeks.length == 2);
    _parseWeek(hours, weeks[0], daysHour[1], 0);
    _parseWeek(hours, weeks[1], daysHour[1], 7);
  } else { // пн,вт 1ч
    final daysHour = code.split(' '); // ['пн,вт','1ч']
    assert(daysHour.length == 2);
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
void _parseWeek(List<double> hours, String daysString,
    String hourString, int shift) {
  final hour = double.parse(
      hourString.replaceFirst(_hourStr, '').replaceFirst(',', '.'));
  for (int day = 0; day < 7; day++) {
    if (daysString == '' || daysString.contains(weekDays[day])) {
      hours[day + shift] = hour;
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
      hoursMap[hours[day]].add(weekDays[day % 7]);
    }
  }
  return hoursMap;
}

const List<String> weekDays = ['пн','вт','ср','чт','пт','сб','вс'];
const String _inWeekStr = 'чз/нед';
const String _hourStr = 'ч';
