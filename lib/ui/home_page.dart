import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
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
  static const fixedColumnWidth = 124.0;
  static const rowHeight = 56.0;
  static const columnWidth = 56.0;
  static const leftPadding = 12.0;
  
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
                      color: Colors.black54,
                      height: 1.0,
                      thickness: 0.0,
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
          onTap: () => _selectPeriod(),
          child: snapshot.hasData
              ? _createCell(
                  periodToString(snapshot.data),
                  width: fixedColumnWidth,
                  alignment: Alignment.centerLeft,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue,
                )
              : _createCell('')
          ),
      ),
    ];
    for (int day = 1; day <= period.day; day++) {
      rowCells.add(
        StreamBuilder<DateTime>(
          stream: bloc.activePeriod,
          builder: (context, snapshot) => snapshot.hasData
              ? _createCell(
                  '${dayToString(DateTime(snapshot.data.year, snapshot.data.month, day))} $day',
                  fontWeight: FontWeight.bold,
                )
              : _createCell('')
        ),
      );
    }
    return rowCells;
  }

  /// Создание ячейки таблицы
  Widget _createCell(String label, {
    double width = columnWidth,
    alignment: Alignment.center,
    fontWeight = FontWeight.normal,
    color = Colors.black54
  }) => Container(
    child: Text(label, style: TextStyle(fontWeight: fontWeight, color: color)),
    width: width,
    height: rowHeight,
    padding: EdgeInsets.fromLTRB(leftPadding, 0.0, 0.0, 0.0),
    alignment: alignment,
  );

  /// Создание фиксированной колонки
  Widget _createFixedColumn(BuildContext context, int index) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          text(context, groupPersons[index].family, fontSize: 16.0, color: Colors.black87),
          horizontalSpace(height: 4.0),
          text(context, groupPersons[index].name, fontSize: 14.0),
        ],
      ),
      width: fixedColumnWidth,
      height: rowHeight,
      padding: EdgeInsets.fromLTRB(leftPadding, 0.0, 0.0, 0.0),
      alignment: Alignment.centerLeft,
    );
  }

  /// Создание строки таблицы
  Widget _createTableRow(BuildContext context, int index) {
    return StreamBuilder<List<Timesheet>>(
      stream: bloc.timesheets,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final timesheets = snapshot.data.where((timesheet) =>
              timesheet.groupPersonLinkId == groupPersons[index].groupPersonLinkId);
          final timesheetDates = timesheets.map((timesheet) => timesheet.attendanceDate).toList();
          final period = bloc.activePeriod.value;
          final rowCells = List<Widget>();
          for (int day = 1; day <= period.day; day++) {
            final date = DateTime(period.year, period.month, day);
            if (timesheetDates.contains(date)) {
              final hoursNumber = timesheets.firstWhere((timesheet) =>
              timesheet.attendanceDate == date).hoursNumber;
              rowCells.add(_createCell(doubleToString(hoursNumber)));
            } else {
              rowCells.add(_createCell(''));
            }
          }
          return Row(children: rowCells);
        } else {
          return _createCell('');
        }
      }
    );
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
}