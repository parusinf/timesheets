import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/ui/group_edit.dart';

const lineColor = Colors.black12;
const activeColorOpacity = 0.3;
const passiveColorOpacity = 0.1;
const borderRadius = 8.0;
const dividerHeight = 8.0;
const padding = 16.0;
const horizontalSpaceHeight = 20.0;

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
      case 'group_persons': message = L10n.of(context).uniqueGroupPerson; break;
    }
  } else {
    message = message.replaceFirst('Invalid argument(s): ', '');
  }
  scaffoldKey.currentState.hideCurrentSnackBar();
  scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
}

/// Текст
Widget text(
    String text, {
      color: Colors.black54,
      fontSize: 14.0,
      fontWeight = FontWeight.normal,
    }) => Text(text, style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight));

/// Сообщение в центре страницы серым цветом
Widget centerMessage(BuildContext context, String message) =>
    Center(child: text(message));

/// Горизонтальный разделитель пространства между контролами
Widget horizontalSpace({height = horizontalSpaceHeight}) => SizedBox(height: height);

/// Горизонтальная линия
Widget divider() => const Divider(color: lineColor, height: 0.5);

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

/// Заголовок списка с кнопкой добавления
Widget listHeater(BuildContext context, IconData icon, String title, Function() onPressed) {
  final items = <Widget>[
    Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 16.0, 0.0),
      child: Icon(icon, color: Colors.black54)
    ),
    text(title.toUpperCase()),
  ];
  if (onPressed != null) {
    items.addAll(<Widget>[
      const Spacer(),
      IconButton(icon: const Icon(Icons.add), color: Colors.black54, onPressed: onPressed),
    ]);
  }
  return Row(children: items);
}

/// Переход на страницу
Future<T> push<T extends Object>(BuildContext context, Widget page) async =>
    await Navigator.push(context, MaterialPageRoute(builder: (context) => page));

/// Добавление группы
Future addGroup(BuildContext context) async {
  // Добавление группы
  final groupView = await push(context, GroupEdit());
  // Исправление группы для добавляения в неё персон
  if (groupView != null) {
    push(context, GroupEdit(groupView: groupView));
  }
}