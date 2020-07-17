import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Сообщение в снакбаре
void snackBarMessage(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  final snackBar = SnackBar(content: Text(message));
  scaffoldKey.currentState.showSnackBar(snackBar);
}

/// Текст серого цвета
Widget greyText(BuildContext context, String text) => Text(text,
  style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.black38));

/// Сообщение в центре страницы серым цветом
Widget centerMessage(BuildContext context, String message) =>
    Center(child: greyText(context, message));

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