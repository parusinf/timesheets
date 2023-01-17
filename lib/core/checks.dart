import 'package:intl/intl.dart';

import 'tools.dart';
import 'type_cast.dart';
import 'bloc.dart';

/// Удаление концевых пробелов из строки
String? trim(String? value) => isNotEmpty(value) ? value!.trim() : '';

/// Проверка строки на пустое значение
bool isEmpty(String? value) => value == null || value.trim().isEmpty;

/// Проверка строки на непустое значение
bool isNotEmpty(String? value) => !isEmpty(value);

/// Дата является днём рождения
bool isBirthday(DateTime date, DateTime? birthday) =>
    date.day == birthday?.day && date.month == birthday?.month;

/// Дата является праздничным или выходным днём
isDayOff(Bloc bloc, DateTime date) {
  final weekday = abbrWeekday(date);
  final weekdayIndex = abbrWeekdays.indexOf(weekday);
  String? yearDayOff = bloc.activeYearDayOff.valueOrNull;
  if (yearDayOff == null) {
    return [5, 6].contains(weekdayIndex);
  } else {
    final dayOfYear = int.parse(DateFormat('D').format(date));
    final isDayOff = yearDayOff.substring(dayOfYear + 3, dayOfYear + 4) == '1'? true : false;
    return isDayOff;
  }
}

/// Строка нуждается в исправлении
bool isEqual(String? oldValue, String? newValue) =>
    !(trim(oldValue) == '' && trim(newValue) != '' ||
      trim(oldValue) != '' && trim(newValue) != '' &&
      trim(oldValue) != trim(newValue));

/// Дата нуждается в исправлении
bool isDateEqual(DateTime? oldValue, DateTime? newValue) =>
    !(oldValue == null && newValue != null ||
      oldValue != null && newValue != null && oldValue != newValue);
