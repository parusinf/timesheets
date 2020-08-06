import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'l10n.dart';

/// Тип действия с данными
enum DataActionType {
  Insert,
  Update,
  Delete
}

/// Сообщение в снакбаре
void showMessage(GlobalKey<ScaffoldState> scaffoldKey, String originalMessage) {
  final context = scaffoldKey.currentContext;
  String message = originalMessage;
  final uniqueRegexp = RegExp(r'UNIQUE constraint failed: ([a-z_]+)\.');
  if (uniqueRegexp.hasMatch(originalMessage)) {
    final tableName = uniqueRegexp.firstMatch(originalMessage)[1];
    switch (tableName) {
      case 'orgs': message = L10n.of(context).uniqueOrg; break;
      case 'schedules': message = L10n.of(context).uniqueSchedule; break;
      case 'groups': message = L10n.of(context).uniqueGroup; break;
      case 'persons': message = L10n.of(context).uniquePerson; break;
      case 'group_person_links': message = L10n.of(context).uniqueGroupPerson; break;
    }
  } else {
    message = message.replaceFirst('Invalid argument(s): ', '');
  }
  scaffoldKey.currentState.hideCurrentSnackBar();
  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
}

/// Текст серого цвета
Widget text(BuildContext context, String text, {color: Colors.black54, fontSize: 14.0}) =>
    Text(text, style: TextStyle(color: color, fontSize: fontSize));

/// Сообщение в центре страницы серым цветом
Widget centerMessage(BuildContext context, String message) =>
    Center(child: text(context, message));

/// Последний день месяца
DateTime lastDayOfMonth(DateTime date) => date.month < 12
    ? DateTime(date.year, date.month + 1, 0)
    : DateTime(date.year + 1, 1, 0);

/// Проверка строки на пустоту
bool isEmpty(String value) => value == null || value.trim().isEmpty;

/// Проверка строки на непустоту
bool isNotEmpty(String value) => !isEmpty(value);

/// Горизонтальный разделитель пространства между контролами
Widget horizontalSpace({height = 16.0}) => SizedBox(height: height);

/// Преобразование строки в дату
DateTime dateValue(String value) {
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

/// Преобразование строки
String stringValue(String value) =>
    isNotEmpty(value) ? value.trim() : null;

/// Преобразование строки в число
double doubleValue(String value) =>
    isNotEmpty(value) ? double.tryParse(value.trim()) : null;

/// Преобразование строки в целое
int intValue(String value) =>
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

/// Преобразование даты периода в строку
String dayToString(DateTime day) {
  final s = DateFormat(DateFormat.ABBR_WEEKDAY).format(day);
  return s;
}

/// Форматировщики даты
class DateFormatters {
  static final _dateDMYFormatter = _DateDMYFormatter();
  static final formatters = <TextInputFormatter>[
    WhitelistingTextInputFormatter.digitsOnly,
    _dateDMYFormatter,
  ];
}

/// Форматировщики целых чисел
class IntFormatters {
  static final formatters = <TextInputFormatter>[
    WhitelistingTextInputFormatter.digitsOnly,
  ];
}

/// Форматировщик даты в формате ДД.ММ.ГГГГ
class _DateDMYFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue _, TextEditingValue newValue) {
    final newTextLength = newValue.text.length;
    final newText = StringBuffer();
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    if (newTextLength >= 3) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 2) + '.');
      if (newValue.selection.end >= 2) selectionIndex++;
    }
    if (newTextLength >= 5) {
      newText.write(newValue.text.substring(2, usedSubstringIndex = 4) + '.');
      if (newValue.selection.end >= 4) selectionIndex++;
    }
    if (newTextLength >= usedSubstringIndex) {
      newText.write(newValue.text.substring(usedSubstringIndex));
    }
    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}