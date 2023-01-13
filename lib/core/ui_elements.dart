import 'package:flutter/material.dart';
import 'package:timesheets/core.dart';
import 'package:url_launcher/url_launcher.dart';

const lineColor = Colors.black12;
const activeColorOpacity = 0.3;
const passiveColorOpacity = 0.1;
const borderRadius = 8.0;
const padding1 = 16.0;
const padding2 = 8.0;
const padding3 = 6.0;
const dividerHeight = 22.0;


/// Наименования типов питания
final List<String> mealsNames = [L10n.meals0, L10n.meals1, L10n.meals2];


/// Сообщение в снакбаре
void showMessage(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  final context = scaffoldKey.currentContext;
  String newMessage = message;
  final uniqueRegexp = RegExp(r'UNIQUE constraint failed: ([a-z_]+)\.');
  if (uniqueRegexp.hasMatch(message)) {
    final tableName = uniqueRegexp.firstMatch(message)![1];
    switch (tableName) {
      case 'orgs':
        newMessage = L10n.dupOrgName;
        break;
      case 'schedules':
        newMessage = L10n.uniqueSchedule;
        break;
      case 'holidays':
        newMessage = L10n.uniqueDay;
        break;
      case 'groups':
        newMessage = L10n.uniqueGroup;
        break;
      case 'persons':
        newMessage = L10n.uniquePerson;
        break;
      case 'group_persons':
        newMessage = L10n.uniqueGroupPerson;
        break;
    }
  } else {
    newMessage = newMessage.replaceFirst('Invalid argument(s): ', '');
    newMessage = newMessage.replaceFirst('Exception: ', '');
  }
  ScaffoldMessenger.of(context!).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(newMessage)));
}


/// Текст
Widget text(
  String text, {
  Color? color,
  double? fontSize,
  FontWeight? fontWeight,
}) {
  return Text(
    text,
    style: TextStyle(color: color, fontSize: fontSize, fontWeight: fontWeight),
  );
}


/// Сообщение в центре страницы серым цветом
Widget centerMessage(BuildContext context, String message) =>
    Center(child: text(message));


/// Кнопка в центре
Widget centerButton(String label, {VoidCallback? onPressed}) => Center(
      child: button(label, onPressed: onPressed),
    );

/// Кнопка
Widget button(String label, {VoidCallback? onPressed, ButtonStyle? style}) =>
    ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: text(label, color: Colors.black87, fontSize: 16.0),
    );

/// Переход на страницу
Future<T?> push<T extends Object>(BuildContext context, Widget page) async {
  final result = await Navigator.push(
      context, MaterialPageRoute(builder: (context) => page));
  return result;
}


/// Вызов ссылки
Future launchUrl2(GlobalKey<ScaffoldState> scaffoldKey, String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    showMessage(scaffoldKey, L10n.linkNotStart);
  }
}


/// Получение нормы часов на дату по активному графику
double getHoursNorm(Bloc bloc, DateTime date) {
  final weekdayNumber = abbrWeekdays.indexOf(abbrWeekday(date));
  final scheduleDays = bloc.scheduleDays.value;
  var hoursNorm = 0.0;
  if (scheduleDays.isNotEmpty) {
    hoursNorm = scheduleDays[weekdayNumber].hoursNorm;
    // Обнуление нормы часов по графику для праздничного дня
    if (!isHoliday(bloc, date)) {
      // Добавление нормы часов для переноса рабочего дня
      if (isTransWorkday(bloc, date)) {
        // Поиск нормы часов первого дня графика
        hoursNorm = getFirstHoursNorm(bloc);
      }
    }
  }
  return hoursNorm;
}


/// Поиск нормы часов первого дня активного графика
double getFirstHoursNorm(Bloc bloc) {
  final days = bloc.scheduleDays.valueOrNull;
  if (days != null) {
    for (var day in days) {
      if (day.hoursNorm > 0.0) {
        return day.hoursNorm;
      }
    }
  }
  return 0.0;
}


/// Диалог подтверждения
showAlertDialog(BuildContext context, String title, VoidCallback action) {
  // set up the buttons
  Widget cancelButton =
      button(L10n.cancel, onPressed: () => Navigator.pop(context));
  Widget continueButton = button(
    L10n.continueAction,
    onPressed: () {
      action();
      Navigator.pop(context);
    },
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.red[500]!),
    ),
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
