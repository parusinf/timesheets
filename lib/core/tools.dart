import 'package:timesheets/db/db.dart';
import 'package:timesheets/core/l10n.dart';
import 'dart:convert' show base64;

const externalFiles = '/storage/emulated/0';
final List<String> abbrWeekdays = [
  L10n.mo,
  L10n.tu,
  L10n.we,
  L10n.th,
  L10n.fr,
  L10n.sa,
  L10n.su
];

/// Тип действия с данными
enum DataActionType {
  insert,
  update,
  delete,
}

/// Последний день месяца
DateTime lastDayOfMonth(DateTime date) => date.month < 12
    ? DateTime(date.year, date.month + 1, 0)
    : DateTime(date.year + 1, 1, 0);

/// Фамилия Имя Отчество
String? personFullName(Person? person) =>
    person != null ? '${person.family} ${personName(person)}' : '';

/// Имя Отчество
String personName(Person person, {showMiddleName = true}) =>
    (person.middleName == null || !showMiddleName)
        ? person.name
        : '${person.name} ${person.middleName}';

extension StringExtension on String {
  /// Заглавная первая буква в строке
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Вставка $sep через каждые $len символов
  String insertSep(int len, String sep) {
    return replaceAllMapped(RegExp('.{$len}'), (m) => '${m.group(0)}$sep');
  }
}

String getAppCode() {
  var c = base64.decode('HQWMERdItptZ9Zy/fTsuFvrO')
      .map((e) => e.toRadixString(16).padLeft(2, '0'))
      .join()
      .insertSep(8, ' ')
      .split(' ')
      .map((e) => int.parse(e, radix: 16))
      .map((e) => e ^ int.parse('daceface', radix: 16))
      .map((e) => e.toRadixString(16).padLeft(8, '0'));
  return '${c.elementAt(0)}-'
      '${c.elementAt(1).insertSep(4, '-')}'
      '${c.elementAt(2).insertSep(4, '-').substring(0, 9)}'
      '${c.elementAt(3)}';
}
