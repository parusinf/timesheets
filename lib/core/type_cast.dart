import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timesheets/core.dart';
import 'checks.dart';

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

/// Преобразование строки периода в дату
DateTime stringToPeriod(BuildContext context, String period) {
  final monthList = dateTimeSymbolMap()[L10n.languageCode].STANDALONEMONTHS
      .map((month) => month.toLowerCase()).toList();
  final parts = period.split(' ');
  if (parts.length != 2) {
    return null;
  }
  final month = monthList.indexOf(parts[0].toLowerCase()) + 1;
  final year = stringToInt(parts[1]);
  if (month == 0 || year == null) {
    return null;
  }
  return lastDayOfMonth(DateTime(year, month, 1));
}

/// Преобразование диапазона дат в строку
String datesToString(BuildContext context, DateTime beginDate, DateTime endDate) {
  final begin = dateToString(beginDate);
  final end = dateToString(endDate);
  return begin != ''
      ? end != '' ? '${L10n.from} $begin ${L10n.to} $end' : '${L10n.from} $begin'
      : end != '' ? '${L10n.to} $end' : L10n.withoutTime;
}

// Преобразование ссылки в строку
String uriToString(Uri uri) {
  final encoded = uri?.path
      ?.replaceFirst('/external_files', externalFiles)
      ?.replaceFirst('/media', externalFiles);
  return encoded != null ? Uri.decodeFull(encoded) : null;
}
