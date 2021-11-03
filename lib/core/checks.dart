import 'tools.dart';
import 'type_cast.dart';
import 'bloc.dart';

/// Удаление концевых пробелов из строки
String trim(String value) => isNotEmpty(value) ? value.trim() : '';

/// Проверка строки на пустое значение
bool isEmpty(String value) => value == null || value.trim().isEmpty;

/// Проверка строки на непустое значение
bool isNotEmpty(String value) => !isEmpty(value);

/// Дата является днём рождения
bool isBirthday(DateTime date, DateTime birthday) =>
    date?.day == birthday?.day && date?.month == birthday?.month;

/// Дата является праздничным или выходным днём
bool isHoliday(Bloc bloc, DateTime date) {
  final weekday = abbrWeekday(date);
  final weekdayIndex = abbrWeekdays.indexOf(weekday);
  return !isTransWorkday(bloc, date) &&
      ([5, 6].contains(weekdayIndex) ||
          bloc.holidaysDateList.value.contains(date));
}

/// Дата является переносом рабочего дня
bool isTransWorkday(Bloc bloc, DateTime date) =>
    bloc.workdaysDateList.value.contains(date);

/// Строка нуждается в исправлении
bool isNeedStringUpdate(String oldValue, String newValue) =>
    trim(oldValue) == '' && trim(newValue) != '' ||
    trim(oldValue) != '' &&
        trim(newValue) != '' &&
        trim(oldValue) != trim(newValue);

/// Дата нуждается в исправлении
bool isNeedDateUpdate(DateTime oldValue, DateTime newValue) =>
    oldValue == null && newValue != null ||
    oldValue != null && newValue != null && oldValue != newValue;
