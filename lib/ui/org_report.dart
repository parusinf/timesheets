import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/org_edit.dart';

/// Отчёт по организации
class OrgReport extends StatefulWidget {
  const OrgReport({Key key}): super(key: key);
  @override
  OrgReportState createState() => OrgReportState();
}

/// Состояние отчёта по организации
class OrgReportState extends State<OrgReport> {
  get _bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ActiveGroup> _activeGroups;
  List<GroupView> _orgMeals;
  List<AttendanceView> _orgAttendances;
  static const fixedColumnWidth = 150.0;
  static const rowHeight = 56.0;
  static const columnWidth = 56.0;
  static const leftPadding = 12.0;
  int _grouping = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: StreamBuilder<Org>(
        stream: _bloc.activeOrg,
        builder: (context, snapshot) => snapshot.hasData
          ? InkWell(
            onTap: () async => await editOrg(context, snapshot.data),
            child: text(snapshot.data.name),
          )
          : text(''),
      ),
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        divider(height: padding3),
        // Группировка
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding2),
          child: formElement(
            Icons.storage,
            Wrap(
              children: [
                ChoiceChip(
                  label: Text(L10n.groups),
                  selected: _grouping == 0,
                  onSelected: (value) {
                    setState(() {
                      _grouping = value ? 0 : -1;
                    });
                  },
                ),
                const SizedBox(width: padding2),
                ChoiceChip(
                  label: Text(L10n.meals),
                  selected: _grouping == 1,
                  onSelected: (value) {
                    setState(() {
                      _grouping = value ? 1 : -1;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        divider(height: padding3),
        // Посещаемость
        _grouping == 0
        ?
        StreamBuilder<List<ActiveGroup>>(
          stream: _bloc.activeGroups,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _activeGroups = snapshot.data;
              return Flexible(
                child: StreamBuilder<List<AttendanceView>>(
                  stream: _bloc.orgAttendances,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _orgAttendances = snapshot.data;
                      return HorizontalDataTable(
                        leftHandSideColumnWidth: fixedColumnWidth,
                        rightHandSideColumnWidth: columnWidth * (_bloc.activePeriod.value.day + 1),
                        isFixedHeader: true,
                        headerWidgets: _createTitleRow(),
                        leftSideItemBuilder: _createFixedColumn,
                        rightSideItemBuilder: _createTableRow,
                        itemCount: _activeGroups.length,
                        rowSeparatorWidget: const Divider(color: lineColor, height: 0.5),
                      );
                    } else {
                      return centerMessage(context, L10n.dataLoading);
                    }
                  }
                )
              );
            } else {
              return centerMessage(context, L10n.dataLoading);
            }
          }
        )
        :
        StreamBuilder<List<GroupView>>(
          stream: _bloc.meals,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _orgMeals = snapshot.data;
              return Flexible(
                child: StreamBuilder<List<AttendanceView>>(
                  stream: _bloc.orgAttendances,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _orgAttendances = snapshot.data;
                      return HorizontalDataTable(
                        leftHandSideColumnWidth: fixedColumnWidth,
                        rightHandSideColumnWidth: columnWidth * (_bloc.activePeriod.value.day + 1),
                        isFixedHeader: true,
                        headerWidgets: _createTitleRow(),
                        leftSideItemBuilder: _createFixedColumn,
                        rightSideItemBuilder: _createTableRow,
                        itemCount: _orgMeals.length,
                        rowSeparatorWidget: const Divider(color: lineColor, height: 0.5),
                      );
                    } else {
                      return centerMessage(context, L10n.dataLoading);
                    }
                  }
                )
              );
            } else {
              return centerMessage(context, L10n.dataLoading);
            }
          }
        ),
      ],
    ),
  );

  /// Создание строки заголовка таблицы
  List<Widget> _createTitleRow() {
    final DateTime period = _bloc.activePeriod.value;
    final rowCells = <Widget>[
      StreamBuilder<DateTime>(
        stream: _bloc.activePeriod,
        builder: (context, snapshot) =>
            InkWell(
                onTap: _selectPeriod,
                child: snapshot.hasData
                    ? _createCell(
                      periodToString(snapshot.data),
                      width: fixedColumnWidth,
                      alignment: Alignment.centerLeft,
                      leftPadding: leftPadding,
                      color: Colors.lightBlue,
                      fontSize: 14.0,
                    )
                    : Text('')
            ),
      ),
    ];
    // Количество присутствующих персон на период
    final daysCount = _orgAttendances.where(
            (e) => e.hoursFact > 0.0).toList().length;
    // Дней посещения персоны за период
    rowCells.add(
      StreamBuilder<DateTime>(
          stream: _bloc.activePeriod,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _createFixedCell(
                L10n.days,
                daysCount.toString(),
                width: columnWidth,
                alignment: Alignment.center,
                borderStyle: BorderStyle.solid,
                titleColor: Colors.black87,
                subtitleColor: Colors.black54,
                wrap: false,
              );
            } else {
              return Text('');
            }
          }
      ),
    );
    // Колонки по дням периода
    for (int day = 1; day <= period.day; day++) {
      final date = DateTime(period.year, period.month, day);
      final hoursNorm = getHoursNorm(_bloc, date);
      // Количество присутствующих персон на дату
      final dateCount = _orgAttendances.where(
              (attendance) => attendance.date == date).toList().length;
      final dateCountStr = dateCount > 0.0
          ? dateCount.toString()
          : hoursNorm > 0.0 ? '0' : '';
      // Добавление ячейки в строку
      rowCells.add(
        StreamBuilder<DateTime>(
            stream: _bloc.activePeriod,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _createFixedCell(
                  '${abbrWeekday(date).capitalize()} ${day.toString()}',
                  dateCountStr,
                  width: columnWidth,
                  alignment: Alignment.center,
                  borderStyle: BorderStyle.solid,
                  titleColor: isHoliday(_bloc, date) ? Colors.red : Colors.black87,
                  subtitleColor: Colors.black54,
                  wrap: false,
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
        width: columnWidth,
        alignment: Alignment.center,
        leftPadding: 0.0,
        borderStyle: BorderStyle.solid,
        color: Colors.black87,
        fontSize: 14.0,
        fontWeight: FontWeight.normal,
      }) => Container(
    child: text(title, color: color, fontSize: fontSize, fontWeight: fontWeight),
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
      double width: columnWidth,
      alignment: Alignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      titleColor: Colors.black87,
      subtitleColor: Colors.black54,
      leftPadding: 0.0,
      borderStyle: BorderStyle.none,
      Function() onTap,
      wrap = true,
  }) => InkWell(
    onTap: onTap ?? () => {},
    child: Container(
      child: wrap
          ? Wrap(
            children: <Widget>[
              text(title, fontSize: 16.0, color: titleColor),
              text(subtitle, fontSize: 16.0, color: subtitleColor),
            ],
          )
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
          text(title, fontSize: 16.0, color: titleColor),
          divider(height: padding3),
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
    ),
  );

  /// Создание фиксированной колонки
  Widget _createFixedColumn(BuildContext context, int index) {
    final name = _grouping == 0
        ? _activeGroups[index].groupView.name
        : mealsNames[_orgMeals[index].meals];
    return _createFixedCell(
      name,
      '',
      width: fixedColumnWidth,
      alignment: Alignment.centerLeft,
      crossAxisAlignment: CrossAxisAlignment.start,
      leftPadding: leftPadding,
    );
  }

  /// Создание строки таблицы
  Widget _createTableRow(BuildContext context, int index) {
    final attendances = _grouping == 0
        ? _orgAttendances
            .where((attendance) => attendance.groupId == _activeGroups[index].groupView?.id)
        : _orgAttendances
            .where((attendance) => attendance.meals == _orgMeals[index].meals);
    final period = _bloc.activePeriod.value;
    final rowCells = <Widget>[];
    // Итог по персоне за период
    rowCells.add(_createCell(attendances.length.toString(),
        color: Colors.black54, fontSize: 16.0));
    // Цикл по дням текущего периода
    for (int day = 1; day <= period.day; day++) {
      final date = DateTime(period.year, period.month, day);
      final hoursNorm = getHoursNorm(_bloc, date);
      final hoursFact = attendances.where(
              (attendance) => attendance.date == date).toList().length;
      final dateCountStr = hoursFact > 0.0
          ? hoursFact.toString()
          : hoursNorm > 0.0 ? '0' : '';
      rowCells.add(
        _createCell(
          dateCountStr,
          color: Colors.black87,
        ),
      );
    }
    return Row(children: rowCells);
  }

  /// Выбор активного периода
  Future _selectPeriod() async {
    final period = await showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: _bloc.activePeriod.value,
    );
    if (period != null) {
      _bloc.setActivePeriod(lastDayOfMonth(period));
    }
  }
}