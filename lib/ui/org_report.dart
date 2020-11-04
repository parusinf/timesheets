import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/db/schedule_helper.dart';
import 'package:timesheets/ui/org_edit.dart';

/// Отчёт по организации
class OrgReport extends StatefulWidget {
  const OrgReport({Key key}): super(key: key);
  @override
  OrgReportState createState() => OrgReportState();
}

/// Состояние отчёта по организации
class OrgReportState extends State<OrgReport> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<ActiveGroup> _activeGroups;
  List<GroupView> _orgMeals;
  List<AttendanceView> _orgAttendances;
  static const fixedColumnWidth = 140.0;
  static const rowHeight = 56.0;
  static const columnWidth = 56.0;
  static const leftPadding = 12.0;
  int _grouping = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: StreamBuilder<Org>(
        stream: bloc.activeOrg,
        builder: (context, snapshot) => snapshot.hasData
          ? InkWell(
            onTap: () async => await editOrg(context, snapshot.data),
            child: text(snapshot.data.name),
          )
          : text(''),
      ),
      actions: <Widget>[
        // Выгрузка отчёта в файл
        StreamBuilder<List<GroupPersonView>>(
            stream: bloc.groupPeriodPersons,
            builder: (context, snapshot) {
              if (bloc.activeGroup.value != null && snapshot.hasData) {
                return IconButton(
                  icon: Icon(Icons.file_upload),
                  onPressed: () => {},
                );
              } else {
                return Text('');
              }
            }
        ),
      ],
    ),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        divider(height: padding3),
        // Группировка
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding2),
          child: formElement(
            context,
            Icons.storage,
            Wrap(
              children: [
                ChoiceChip(
                  label: Text(l10n.groups),
                  selected: _grouping == 0,
                  onSelected: (value) {
                    setState(() {
                      _grouping = value ? 0 : -1;
                    });
                  },
                ),
                const SizedBox(width: padding2),
                ChoiceChip(
                  label: Text(l10n.meals),
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
          stream: bloc.activeGroups,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _activeGroups = snapshot.data;
              return Flexible(
                child: StreamBuilder<List<AttendanceView>>(
                  stream: bloc.orgAttendances,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _orgAttendances = snapshot.data;
                      return HorizontalDataTable(
                        leftHandSideColumnWidth: fixedColumnWidth,
                        rightHandSideColumnWidth: columnWidth * bloc.activePeriod.value.day,
                        isFixedHeader: true,
                        headerWidgets: _createTitleRow(),
                        leftSideItemBuilder: _createFixedColumn,
                        rightSideItemBuilder: _createTableRow,
                        itemCount: _activeGroups.length,
                        rowSeparatorWidget: const Divider(color: lineColor, height: 0.5),
                      );
                    } else {
                      return centerMessage(context, l10n.dataLoading);
                    }
                  }
                )
              );
            } else {
              return centerMessage(context, l10n.dataLoading);
            }
          }
        )
        :
        StreamBuilder<List<GroupView>>(
          stream: bloc.meals,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _orgMeals = snapshot.data;
              return Flexible(
                child: StreamBuilder<List<AttendanceView>>(
                  stream: bloc.orgAttendances,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      _orgAttendances = snapshot.data;
                      return HorizontalDataTable(
                        leftHandSideColumnWidth: fixedColumnWidth,
                        rightHandSideColumnWidth: columnWidth * bloc.activePeriod.value.day,
                        isFixedHeader: true,
                        headerWidgets: _createTitleRow(),
                        leftSideItemBuilder: _createFixedColumn,
                        rightSideItemBuilder: _createTableRow,
                        itemCount: _orgMeals.length,
                        rowSeparatorWidget: const Divider(color: lineColor, height: 0.5),
                      );
                    } else {
                      return centerMessage(context, l10n.dataLoading);
                    }
                  }
                )
              );
            } else {
              return centerMessage(context, l10n.dataLoading);
            }
          }
        ),
      ],
    ),
  );

  /// Создание строки заголовка таблицы
  List<Widget> _createTitleRow() {
    final DateTime period = bloc.activePeriod.value;
    final rowCells = <Widget>[
      StreamBuilder<DateTime>(
        stream: bloc.activePeriod,
        builder: (context, snapshot) =>
            InkWell(
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
      final date = DateTime(period.year, period.month, day);
      final hoursNorm = _getHoursNorm(date);
      // Количество присутствующих персон на дату
      final dateCountStr = hoursNorm > 0.0
          ? _orgAttendances.where(
              (attendance) => attendance.date == date).toList().length.toString()
          : '';
      rowCells.add(
        StreamBuilder<DateTime>(
            stream: bloc.activePeriod,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _createFixedCell(
                  '${abbrWeekday(date).capitalize()} ${day.toString()}',
                  dateCountStr,
                  width: columnWidth,
                  alignment: Alignment.center,
                  borderStyle: BorderStyle.solid,
                  titleColor: isHoliday(date) ? Colors.red : Colors.black87,
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
    color: Colors.lightBlue,
    fontWeight: FontWeight.normal,
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
        : mealsName(context, _orgMeals[index].meals);
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
        ? _orgAttendances.where((attendance) => attendance.groupId == _activeGroups[index].groupView.id)
        : _orgAttendances.where((attendance) => attendance.meals == _orgMeals[index].meals);
    final period = bloc.activePeriod.value;
    final rowCells = List<Widget>();
    // Цикл по дням текущего периода
    for (int day = 1; day <= period.day; day++) {
      final date = DateTime(period.year, period.month, day);
      final hoursNorm = _getHoursNorm(date);
      final dateCountStr = hoursNorm > 0.0
          ? attendances.where((attendance) => attendance.date == date).toList().length.toString()
          : '';
      rowCells.add(
        _createCell(
          dateCountStr,
          color: Colors.black87,
        ),
      );
    }
    return Row(children: rowCells);
  }

  /// Получение нормы часов на дату по активному графику
  double _getHoursNorm(DateTime date) {
    final weekdayNumber = abbrWeekdays.indexOf(abbrWeekday(date));
    return bloc.scheduleDays.value[weekdayNumber].hoursNorm;
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