import 'package:intl/intl.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/db/schedule_helper.dart';

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
    isNotEmpty(value) ? value.trim() : '';

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
    date != null ? DateFormat('dd.MM.yyyy').format(date) : '';

/// Преобразование даты периода в строку
String periodToString(DateTime period) {
  final s = DateFormat(DateFormat.YEAR_MONTH).format(period);
  return s.toUpperCase().substring(0, s.length - 3);
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

/// Дата является днём рождения
bool isBirthday(DateTime date, DateTime birthday) =>
    date?.day == birthday?.day && date?.month == birthday?.month;

/// Фамилия Имя Отчество
String personFullName(Person person) => person != null
    ? '${person.family} ${personName(person)}' : '';

/// Имя Отчество
String personName(Person person) => person != null
    ? person.middleName == null ? person.name : '${person.name} ${person.middleName}'
    : '';

/// Заглавная первая буква в строке
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}