import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/db/schedule_helper.dart';
import 'package:timesheets/ui/home_drawer.dart';
import 'package:timesheets/ui/persons_dictionary.dart';

/// Табели
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

/// Состояние табелей
class HomePageState extends State<HomePage> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GroupPerson> groupPersons;
  static const fixedColumnWidth = 130.0;
  static const rowHeight = 56.0;
  static const columnWidth = 56.0;
  static const leftPadding = 12.0;
  static const lineColor = Colors.black12;
  
  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: StreamBuilder<Group>(
        stream: bloc.activeGroup,
        builder: (context, snapshot) => snapshot.hasData
            ? Text(snapshot.data.name) : Text('')
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.person_add),
          tooltip: l10n.addPersonToGroup,
          onPressed: () {
            _addPersonToGroup();
          },
        ),
      ],
    ),
    drawer: HomeDrawer(),
    body: StreamBuilder<List<GroupPerson>>(
      stream: bloc.groupPersons,
      builder: (context, snapshot) {
        // Организаций нет
        if (bloc.activeOrg.value == null) {
          return centerMessage(context, l10n.noOrgs);
        } else {
          // Групп нет
          if (bloc.activeGroup.value == null) {
            return centerMessage(context, l10n.noGroups);
          } else {
            // Данные загрузились
            if (snapshot.hasData) {
              groupPersons = snapshot.data;
              // Персон нет
              if (groupPersons.length == 0) {
                return centerMessage(context, l10n.noPersons);
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: HorizontalDataTable(
                    leftHandSideColumnWidth: fixedColumnWidth,
                    rightHandSideColumnWidth: columnWidth * bloc.activePeriod.value.day,
                    isFixedHeader: true,
                    headerWidgets: _createTitleRow(),
                    leftSideItemBuilder: _createFixedColumn,
                    rightSideItemBuilder: _createTableRow,
                    itemCount: groupPersons.length,
                    rowSeparatorWidget: const Divider(
                      color: lineColor,
                      height: 0.5,
                    ),
                  ),
                );
              }
            // Данные загружаются
            } else {
              return centerMessage(context, l10n.dataLoading);
            }
          }
        }
      }
    ),
  );

  /// Создание строки заголовка таблицы
  List<Widget> _createTitleRow() {
    final DateTime period = bloc.activePeriod.value;
    final rowCells = <Widget>[
      StreamBuilder<DateTime>(
        stream: bloc.activePeriod,
        builder: (context, snapshot) => InkWell(
          onTap: _selectPeriod,
          child: snapshot.hasData
              ? _createCell(
                  periodToString(snapshot.data),
                  width: fixedColumnWidth,
                  alignment: Alignment.centerLeft,
                  leftPadding: leftPadding,
                  borderStyle: BorderStyle.none,
                )
              : Text('')
          ),
      ),
    ];
    for (int day = 1; day <= period.day; day++) {
      final period = bloc.activePeriod.value;
      final date = DateTime(period.year, period.month, day);
      rowCells.add(
        StreamBuilder<DateTime>(
          stream: bloc.activePeriod,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _createFixedCell(
                day.toString(),
                abbrWeekday(date),
                width: columnWidth,
                alignment: Alignment.center,
                borderStyle: BorderStyle.solid,
                titleColor: isHoliday(date) ? Colors.red : Colors.black87,
                subtitleColor: isHoliday(date) ? Colors.red : Colors.black54,
              );
            } else {
              return Text('');
            }
          }
        ),
      );
    }
    return rowCells;
  }

  /// Создание ячейки таблицы
  Widget _createCell(
    String title, {
    double width = columnWidth,
    alignment: Alignment.center,
    leftPadding = 0.0,
    borderStyle = BorderStyle.solid,
    color = Colors.lightBlue,
    fontWeight = FontWeight.normal,
  }) => Container(
    child: text(title, color: color, fontWeight: fontWeight),
    width: width,
    height: rowHeight,
    padding: EdgeInsets.fromLTRB(leftPadding, 0.0, 0.0, 0.0),
    alignment: alignment,
    decoration: BoxDecoration(
      border: Border(left: BorderSide(color: lineColor, width: 0.5, style: borderStyle)),
    ),
  );

  /// Создание фиксированной ячейки
  Widget _createFixedCell(
    String title,
    String subtitle, {
    double width = columnWidth,
    alignment: Alignment.center,
    crossAxisAlignment = CrossAxisAlignment.center,
    titleColor = Colors.black87,
    subtitleColor = Colors.black54,
    leftPadding = 0.0,
    borderStyle = BorderStyle.none,
  }) => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: crossAxisAlignment,
      children: <Widget>[
        text(title, fontSize: 16.0, color: titleColor),
        horizontalSpace(height: 4.0),
        text(subtitle, fontSize: 14.0, color: subtitleColor),
      ],
    ),
    width: width,
    height: rowHeight,
    alignment: alignment,
    padding: EdgeInsets.fromLTRB(leftPadding, 0.0, 0.0, 0.0),
    decoration: BoxDecoration(
      border: Border(left: BorderSide(color: lineColor, width: 0.5, style: borderStyle)),
    ),
  );

  /// Создание фиксированной колонки
  Widget _createFixedColumn(BuildContext context, int index) => _createFixedCell(
    groupPersons[index].family,
    groupPersons[index].name,
    width: fixedColumnWidth,
    alignment: Alignment.centerLeft,
    crossAxisAlignment: CrossAxisAlignment.start,
    leftPadding: leftPadding,
  );

  /// Создание строки таблицы
  Widget _createTableRow(BuildContext context, int index) {
    return StreamBuilder<List<Attendance>>(
      stream: bloc.attendances,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final attendances = snapshot.data.where((attendance) =>
              attendance.groupPersonLinkId == groupPersons[index].groupPersonLinkId);
          final dates = attendances.map((attendance) => attendance.date).toList();
          final period = bloc.activePeriod.value;
          final rowCells = List<Widget>();
          // Цикл по дням текущего периода
          for (int day = 1; day <= period.day; day++) {
            final date = DateTime(period.year, period.month, day);
            // Есть посещаемость в этот день, её можно удалить
            if (dates.contains(date)) {
              final attendance = attendances.firstWhere((attendance) => attendance.date == date);
              rowCells.add(
                InkWell(
                  onTap: () => _deleteAttendance(attendance),
                  child: _createCell(doubleToString(attendance.hoursFact), color: Colors.green, fontWeight: FontWeight.bold),
                ),
              );
            // Посещаемости нет, её можно добавить
            } else {
              final hoursNorm = _getHoursNorm(date);
              if (hoursNorm > 0.0) {
                rowCells.add(
                  InkWell(
                    onTap: () => _insertAttendance(groupPersons[index], date, hoursNorm),
                    child: _createCell(doubleToString(hoursNorm), color: Colors.black12),
                  ),
                );
              } else {
                rowCells.add(_createCell(''));
              }
            }
          }
          return Row(children: rowCells);
        } else {
          return Text('');
        }
      }
    );
  }

  /// Получение нормы часов на дату по активному графику
  double _getHoursNorm(DateTime date) {
    final weekdayNumber = abbrWeekdays.indexOf(abbrWeekday(date));
    return bloc.scheduleDays.value[weekdayNumber].hoursNorm;
  }

  /// Добавление персоны в группу
  Future _addPersonToGroup() async {
    try {
      final person = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => PersonsDictionary()));
      if (person != null) {
        await bloc.addPersonToGroup(bloc.activeGroup.value, person);
      }
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Выбор активного периода
  Future _selectPeriod() async {
    final period = await showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: bloc.activePeriod.value,
      locale: Locale('ru'),
    );
    if (period != null) {
      bloc.setActivePeriod(lastDayOfMonth(period));
    }
  }

  /// Добавление посещаемости
  Future _insertAttendance(GroupPerson groupPerson, DateTime date, double hoursFact) async {
    try {
      bloc.insertAttendance(groupPerson: groupPerson, date: date, hoursFact: hoursFact);
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Удаление посещаемости
  Future _deleteAttendance(Attendance attendance) async {
    try {
      bloc.deleteAttendance(attendance);
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }
}