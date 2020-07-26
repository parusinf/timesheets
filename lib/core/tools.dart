import 'package:flutter/material.dart';
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
    }
  } else {
    message = message.replaceFirst('Invalid argument(s): ', '');
  }
  scaffoldKey.currentState.hideCurrentSnackBar();
  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
}

/// Текст серого цвета
Widget text(BuildContext context, String text, {color: Colors.black54, fontSize: 14.0}) => Text(
  text,
  style: TextStyle(
    color: color,
    fontSize: fontSize,
  ),
);

/// Сообщение в центре страницы серым цветом
Widget centerMessage(BuildContext context, String message) =>
    Center(child: text(context, message));

/// Преобразование даты периода в строку
String periodString(DateTime period) {
  final s = DateFormat(DateFormat.YEAR_MONTH).format(period);
  return '${s[0].toUpperCase()}${s.substring(1)}';
}

/// Последний день месяца
DateTime lastDayOfMonth(DateTime date) => date.month < 12
    ? DateTime(date.year, date.month + 1, 0)
    : DateTime(date.year + 1, 1, 0);

/// Проверка строки на пустоту
bool isEmpty(String value) => value == null || value.isEmpty;

/// Проверка строки на непустоту
bool isNotEmpty(String value) => !isEmpty(value);

/// Горизонтальный разделитель пространства между контролами
const horizontalSpace = SizedBox(height: 16);

/// Форматирование числа с плавающей точкой
String format(double number) {
  final stringNumber = NumberFormat('##.#', 'en_US').format(number);
  return stringNumber == '0' ? '' : stringNumber;
}

