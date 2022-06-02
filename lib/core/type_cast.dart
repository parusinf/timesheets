import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timesheets/core.dart';

/// Преобразование строки в дату либо null в случае ошибки преобразования
DateTime? stringToDateOrNull(String value) {
  DateTime? result = isNotEmpty(value) ? DateTime.tryParse(value.trim()) : null;
  if (result == null) {
    final parseFormat = RegExp(r'^(\d\d)\.(\d\d)\.(\d\d\d\d)$');
    RegExpMatch? match = parseFormat.firstMatch(value);
    if (match != null) {
      final dayStr = match[1];
      final monthStr = match[2];
      final yearStr = match[3];
      final day = dayStr != null ? int.parse(dayStr) : 0;
      final month = monthStr != null ? int.parse(monthStr) : 0;
      final year = yearStr != null ? int.parse(yearStr) : 0;
      if (day + month + year > 0) {
        result = DateTime(year, month, day);
      } else {
        result = null;
      }
    }
  }
  return result;
}


/// Преобразование строки в дату либо DateTime(1900, 1, 1)
DateTime stringToDate(String value) {
  return stringToDateOrNull(value) ?? DateTime(1900, 1, 1);
}

/// Преобразование строки в число
double? stringToDouble(String value) =>
    isNotEmpty(value) ? double.tryParse(value.trim()) : null;

/// Преобразование строки в целое
int? stringToInt(String value) =>
    isNotEmpty(value) ? int.tryParse(value.trim()) : null;

/// Преобразование числа с плавающей точкой в строку
String doubleToString(double number) {
  final stringNumber = NumberFormat('##.#', 'en_US').format(number);
  return stringNumber == '0' ? '' : stringNumber;
}

/// Преобразование даты в строку
String dateToString(DateTime? date) =>
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
DateTime? stringToPeriod(String period) {
  final monthList = dateTimeSymbolMap()[L10n.languageCode]
      .STANDALONEMONTHS
      .map((month) => month.toLowerCase())
      .toList();
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
String datesToString(
    BuildContext context, DateTime? beginDate, DateTime? endDate) {
  final begin = dateToString(beginDate);
  final end = dateToString(endDate);
  return begin != ''
      ? end != ''
          ? '${L10n.from} $begin ${L10n.to} $end'
          : '${L10n.from} $begin'
      : end != ''
          ? '${L10n.to} $end'
          : L10n.withoutTime;
}
