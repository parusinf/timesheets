import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Виджет сообщения
void showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String errorText) {
  final snackBar = SnackBar(content: Text(errorText));
  scaffoldKey.currentState.showSnackBar(snackBar);
}

/// Преобразование даты периода в строку
String periodString(DateTime period) {
  final s = DateFormat(DateFormat.YEAR_MONTH).format(period);
  return '${s[0].toUpperCase()}${s.substring(1)}';
}

/// Последний день месяца
DateTime lastDayOfMonth(DateTime date) =>
    date.month < 12 ?
    DateTime(date.year, date.month + 1, 0) :
    DateTime(date.year + 1, 1, 0);
