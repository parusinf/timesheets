import 'package:timesheets/db/db.dart';
import 'package:timesheets/core/l10n.dart';

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
  Insert,
  Update,
  Delete,
}

/// Последний день месяца
DateTime lastDayOfMonth(DateTime date) => date.month < 12
    ? DateTime(date.year, date.month + 1, 0)
    : DateTime(date.year + 1, 1, 0);

/// Фамилия Имя Отчество
String personFullName(Person person) =>
    person != null ? '${person.family} ${personName(person)}' : '';

/// Имя Отчество
String personName(Person person, {showMiddleName = true}) => person != null
    ? (person.middleName == null || !showMiddleName)
        ? person.name
        : '${person.name} ${person.middleName}'
    : '';

/// Заглавная первая буква в строке
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
