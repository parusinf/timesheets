import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Виджет ошибки
Widget errorView(BuildContext context, String text) =>
  Center(
    child: Text(text, style: Theme.of(context).textTheme.caption),
  );

/// Виджет прогресса
Widget loadingView() =>
  Center(
    child: CircularProgressIndicator(),
  );

/// Виджет сообщения
showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String errorText) {
  final snackBar = SnackBar(content: Text(errorText));
  scaffoldKey.currentState.showSnackBar(snackBar);
}

/// Преобразование даты периода в строку
periodString(DateTime period) {
  final s = DateFormat(DateFormat.YEAR_MONTH).format(period);
  return '${s[0].toUpperCase()}${s.substring(1)}';
}
