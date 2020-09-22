import 'package:intl/intl.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/db/schedule_helper.dart';
import 'package:timesheets/core/l10n.dart';

/// Тип действия с данными
enum DataActionType {
  Insert,
  Update,
  Delete
}

/// Последний день месяца
DateTime lastDayOfMonth(DateTime date) => date.month < 12
    ? DateTime(date.year, date.month + 1, 0)
    : DateTime(date.year + 1, 1, 0);

/// Проверка строки на пустоту
bool isEmpty(String value) => value == null || value.trim().isEmpty;

/// Проверка строки на непустоту
bool isNotEmpty(String value) => !isEmpty(value);

/// Преобразование строки в дату
DateTime stringToDate(String value) {
  DateTime result = isNotEmpty(value) ? DateTime.tryParse(value.trim()) : null;
  if (result == null) {
    final _parseFormat = RegExp(r'^(\d\d)\.(\d\d)\.(\d\d\d\d)$');
    Match match = _parseFormat.firstMatch(value);
    if (match != null) {
      final day = int.parse(match[1]);
      final month = int.parse(match[2]);
      final year = int.parse(match[3]);
      result = DateTime(year, month, day);
    }
  }
  return result;
}

/// Удаление концевых пробелов из строки
String trim(String value) =>
    isNotEmpty(value) ? value.trim() : null;

/// Преобразование строки в число
double stringToDouble(String value) =>
    isNotEmpty(value) ? double.tryParse(value.trim()) : null;

/// Преобразование строки в целое
int stringToInt(String value) =>
    isNotEmpty(value) ? int.tryParse(value.trim()) : null;

/// Преобразование числа с плавающей точкой в строку
String doubleToString(double number) {
  final stringNumber = NumberFormat('##.#', 'en_US').format(number);
  return stringNumber == '0' ? '' : stringNumber;
}

/// Преобразование даты в строку
String dateToString(DateTime date) =>
    date != null ? DateFormat('dd.MM.yyyy').format(date) : null;

/// Преобразование даты периода в строку
String periodToString(DateTime period) {
  final s = DateFormat(DateFormat.YEAR_MONTH).format(period);
  return s.toUpperCase().substring(0, s.length - 3);
}

/// Преобразование диапазона дат в строку
String datesToString(L10n l10n, DateTime beginDate, DateTime endDate) {
  final begin = dateToString(beginDate);
  final end = dateToString(endDate);
  return begin != null
      ? end != null
          ? '${l10n.from} $begin ${l10n.to} $end' : '${l10n.from} $begin'
      : end != null
          ? '${l10n.to} $end' : l10n.withoutTime;
}

/// Преобразование даты периода в строку
String abbrWeekday(DateTime date) {
  final s = DateFormat(DateFormat.ABBR_WEEKDAY).format(date);
  return s;
}

/// Дата является выходным днём
bool isHoliday(DateTime date) {
  final weekday = abbrWeekday(date);
  final weekdayIndex = abbrWeekdays.indexOf(weekday);
  return [5,6].contains(weekdayIndex);
}

String fio(Person person) => person != null
    ? '${person.family} ${person.name} ${person.middleName ?? ''}' : '';