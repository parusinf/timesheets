import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/core/tools.dart';

const lineColor = Colors.black12;
const activeColorOpacity = 0.3;
const passiveColorOpacity = 0.1;
const borderRadius = 8.0;
const padding1 = 16.0;
const padding2 = 8.0;
const padding3 = 6.0;
const dividerHeight = 20.0;
const phoneLength = 15;

/// Сообщение в снакбаре
void showMessage(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  final context = scaffoldKey.currentContext;
  String newMessage = message;
  final uniqueRegexp = RegExp(r'UNIQUE constraint failed: ([a-z_]+)\.');
  if (uniqueRegexp.hasMatch(message)) {
    final tableName = uniqueRegexp.firstMatch(message)[1];
    switch (tableName) {
      case 'orgs': newMessage = L10n.of(context).uniqueOrg; break;
      case 'schedules': newMessage = L10n.of(context).uniqueSchedule; break;
      case 'groups': newMessage = L10n.of(context).uniqueGroup; break;
      case 'persons': newMessage = L10n.of(context).uniquePerson; break;
      case 'group_persons': newMessage = L10n.of(context).uniqueGroupPerson; break;
    }
  } else {
    newMessage = newMessage.replaceFirst('Invalid argument(s): ', '');
  }
  scaffoldKey.currentState.hideCurrentSnackBar();
  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(newMessage)));
}

/// Текст
Widget text(String text, {
  Color color,
  double fontSize,
  FontWeight fontWeight,
  spacer: false,
}) {
  return Text(text,
    style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
  );
}

/// Сообщение в центре страницы серым цветом
Widget centerMessage(BuildContext context, String message) =>
    Center(child: text(message));

Widget centerButton(String label, {Function() onPressed}) =>
    Center(
      child: RaisedButton(
        onPressed: onPressed,
        child: text(label, color: Colors.black87, fontSize: 16.0),
      ),
    );

/// Разделитель между контролами формы
Widget divider({height = dividerHeight}) => SizedBox(height: height);

/// Форматировщики целых чисел
class IntFormatters {
  static final formatters = <TextInputFormatter>[
    WhitelistingTextInputFormatter.digitsOnly,
  ];
}

/// Форматировщики даты
class DateFormatters {
  static final _dateDMYFormatter = _DateDMYFormatter();
  static final formatters = <TextInputFormatter>[
    WhitelistingTextInputFormatter.digitsOnly,
    _dateDMYFormatter,
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

/// Форматировщики телефона
class PhoneFormatters {
  static final _phoneFormatter = _PhoneFormatter();
  static final formatters = <TextInputFormatter>[
    WhitelistingTextInputFormatter.digitsOnly,
    _phoneFormatter,
  ];
}

/// Форматировщик телефона в формате (###) ###-#### ##
class _PhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final newTextLength = newValue.text.length;
    final newText = StringBuffer();
    var selectionIndex = newValue.selection.end;
    var usedSubstringIndex = 0;
    if (newTextLength >= 1) {
      newText.write('(');
      if (newValue.selection.end >= 1) selectionIndex++;
    }
    if (newTextLength >= 4) {
      newText.write(newValue.text.substring(0, usedSubstringIndex = 3) + ') ');
      if (newValue.selection.end >= 3) selectionIndex += 2;
    }
    if (newTextLength >= 7) {
      newText.write(newValue.text.substring(3, usedSubstringIndex = 6) + '-');
      if (newValue.selection.end >= 6) selectionIndex++;
    }
    if (newTextLength >= 9) {
      newText.write(newValue.text.substring(6, usedSubstringIndex = 8) + '-');
      if (newValue.selection.end >= 8) selectionIndex++;
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

/// Заголовок списка с кнопкой добавления
Widget listHeater(BuildContext context, IconData icon, String title, {Function() onAddPressed, Function() onHeaderTap}) {
  final items = formElement(context, icon, text(title.toUpperCase())).children;
  if (onAddPressed != null) {
    items.addAll(<Widget>[
      const Spacer(),
      IconButton(icon: const Icon(Icons.add), color: Colors.black54, onPressed: onAddPressed),
    ]);
  }
  return onHeaderTap != null
    ? InkWell(onTap: onHeaderTap, child: Row(children: items))
    : Row(children: items);
}

/// Элемент формы
Row formElement(BuildContext context, IconData icon, Widget widget) {
  return Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(0.0, padding2, padding1, padding2),
        child: Icon(icon, color: Colors.black54)
      ),
      widget,
    ]
  );
}

/// Переход на страницу
Future<T> push<T extends Object>(BuildContext context, Widget page) async =>
    await Navigator.push(context, MaterialPageRoute(builder: (context) => page));

/// Вызов ссылки
Future launchUrl(GlobalKey<ScaffoldState> scaffoldKey, String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    showMessage(scaffoldKey, L10n.of(scaffoldKey.currentContext).linkNotStart);
  }
}

/// Преобразование строки периода в дату
DateTime stringToPeriod(BuildContext context, String period) {
  final l10n = L10n.of(context);
  final monthList = dateTimeSymbolMap()[l10n.locale.languageCode].STANDALONEMONTHS
      .map((month) => month.toLowerCase()).toList();
  final parts = period.split(' ');
  final month = monthList.indexOf(parts[0].toLowerCase()) + 1;
  final year = stringToInt(parts[1]);
  return lastDayOfMonth(DateTime(year, month, 1));
}

/// Преобразование диапазона дат в строку
String datesToString(BuildContext context, DateTime beginDate, DateTime endDate) {
  final l10n = L10n.of(context);
  final begin = dateToString(beginDate);
  final end = dateToString(endDate);
  return begin != ''
      ? end != '' ? '${l10n.from} $begin ${l10n.to} $end' : '${l10n.from} $begin'
      : end != '' ? '${l10n.to} $end' : l10n.withoutTime;
}