import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/core/unload.dart';
import 'package:timesheets/core/load.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/home_drawer.dart';
import 'package:timesheets/ui/org_edit.dart';
import 'package:timesheets/ui/group_edit.dart';
import 'package:timesheets/ui/group_persons_dictionary.dart';
import 'package:timesheets/ui/person_edit.dart';
import 'package:timesheets/ui/help_page.dart';

/// Табели
class HomePage extends StatefulWidget {
  const HomePage({Key key}): super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

/// Состояние табелей
class HomePageState extends State<HomePage> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GroupPersonView> _groupPeriodPersons;
  List<Attendance> _groupAttendances;
  static const fixedColumnWidth = 150.0;
  static const rowHeight = 56.0;
  static const columnWidth = 56.0;
  static const leftPadding = 12.0;

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: _createAppBar(),
    drawer: HomeDrawer(),
    body: StreamBuilder<String>(
      stream: bloc.content,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _loadContent(snapshot.data);
        }
        return _createBody();
      },
    ),
  );

  Widget _createAppBar() {
    return AppBar(
      title: StreamBuilder<Group>(
        stream: bloc.activeGroup,
        builder: (context, snapshot) => snapshot.hasData
            ? InkWell(
              onTap: () async {
                await push(context, GroupPersonsDictionary());
              },
              child: text(snapshot.data.name),
            )
            : StreamBuilder<Org>(
            stream: bloc.activeOrg,
            builder: (context, snapshot) => snapshot.hasData
                ? InkWell(
                  onTap: () => editOrg(context, bloc.activeOrg.value),
                  child: text(snapshot.data.name),
                )
                : InkWell(
                  onTap: () => push(context, HelpPage()),
                  child: text(l10n.timesheets),
                )
        ),
      ),
      actions: <Widget>[
        // Выгрузка в файл
        StreamBuilder<List<GroupPersonView>>(
            stream: bloc.groupPeriodPersons,
            builder: (context, snapshot) {
              if (bloc.activeGroup.value != null && snapshot.hasData) {
                return IconButton(
                  icon: Icon(Icons.file_upload),
                  onPressed: _unloadToFile,
                );
              } else {
                return Text('');
              }
            }
        ),
        IconButton(
          icon: Icon(Icons.file_download),
          onPressed: _pickAndLoadFromFile,
        ),
      ],
    );
  }

  Widget _createBody() {
    return StreamBuilder<List<GroupPersonView>>(
        stream: bloc.groupPeriodPersons,
        builder: (context, snapshot) {
          // Добавить организацию
          if (bloc.activeOrg.value == null) {
            return centerButton(l10n.addOrg, onPressed: () => addOrg(context));
          } else {
            // Добавить группу
            if (bloc.activeGroup.value == null) {
              return centerButton(l10n.addGroup, onPressed: () => addGroup(context));
            } else {
              // Персоны группы загрузились
              if (snapshot.hasData) {
                _groupPeriodPersons = snapshot.data;
                return StreamBuilder<List<Attendance>>(
                    stream: bloc.attendances,
                    builder: (context, snapshot) {
                      // Посещаемость загрузилась
                      if (snapshot.hasData) {
                        _groupAttendances = snapshot.data;
                        return HorizontalDataTable(
                          leftHandSideColumnWidth: fixedColumnWidth,
                          rightHandSideColumnWidth: columnWidth * (bloc.activePeriod.value.day + 1),
                          isFixedHeader: true,
                          headerWidgets: _createTitleRow(),
                          leftSideItemBuilder: _createFixedColumn,
                          rightSideItemBuilder: _createTableRow,
                          itemCount: _groupPeriodPersons.length,
                          rowSeparatorWidget: const Divider(color: lineColor, height: 0.5),
                        );
                        // Посещаемость загружаются
                      } else {
                        return centerMessage(context, l10n.dataLoading);
                      }
                    }
                );
                // Персоны группы загружаются
              } else {
                return centerMessage(context, l10n.dataLoading);
              }
            }
          }
        }
    );
  }

  /// Загрузка из переданного контента
  Future _loadContent(String content) async {
    try {
      if (content != null) {
        if (content.contains('content://')) {
          final uri = Uri.parse(content);
          await loadFromFile(context, uriToString(uri));
        } else {
          parseContent(context, content);
        }
      }
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Загрузка из CSV файла
  Future _pickAndLoadFromFile() async {
    try {
      await pickAndLoadFromFile(context);
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Выгрузка в CSV файл
  Future _unloadToFile() async {
    try {
      await unloadToFile(
        context,
        bloc.activeOrg.value,
        bloc.activeGroup.value,
        bloc.activePeriod.value,
        _groupPeriodPersons,
        _groupAttendances,
      );
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

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
                      color: Colors.lightBlue,
                      fontSize: 14.0,
                    )
                  : Text('')
            ),
      ),
    ];
    // Дней посещения персоны за период
    rowCells.add(
        _createCell(
          l10n.days,
          width: columnWidth,
          alignment: Alignment.center,
          fontSize: 16.0,
        )
    );
    // Колонки по дням периода
    for (int day = 1; day <= period.day; day++) {
      final date = DateTime(period.year, period.month, day);
      final hoursNorm = getHoursNorm(bloc, date);
      // Количество присутствующих персон на дату
      final dateCount = _groupAttendances.where(
              (attendance) => attendance.date == date).toList().length;
      final dateCountStr = dateCount > 0.0
          ? dateCount.toString()
          : hoursNorm > 0.0 ? '0' : '';
      // Добавление ячейки в строку
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
                titleColor: isHoliday(bloc, date) ? Colors.red : Colors.black87,
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
  }) {
    final columnRows = <Widget>[];
    columnRows.add(text(title, fontSize: 16.0, color: titleColor,
        fontWeight: wrap ? FontWeight.bold : FontWeight.normal));
    if (!wrap) columnRows.add(divider(height: padding3));
    if (subtitle != null) columnRows.add(text(subtitle, fontSize: 16.0, color: subtitleColor));

    return InkWell(
      onTap: onTap ?? () => {},
      child: Container(
        child: wrap
            ? Wrap(children: columnRows)
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: crossAxisAlignment,
              children: columnRows,
            ),
        width: width,
        height: rowHeight,
        alignment: alignment,
        padding: EdgeInsets.fromLTRB(leftPadding, 0.0, 0.0, 0.0),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(
              color: lineColor, width: 0.5, style: borderStyle)),
        ),
      ),
    );
  }

  /// Создание фиксированной колонки
  Widget _createFixedColumn(BuildContext context, int index) {
    final person = _groupPeriodPersons[index].person;
    return _createFixedCell(
      '${person.family} ',
      personName(person, showMiddleName: false),
      width: fixedColumnWidth,
      alignment: Alignment.centerLeft,
      crossAxisAlignment: CrossAxisAlignment.start,
      leftPadding: leftPadding,
      onTap: () => editPerson(context, person),
    );
  }

  /// Создание строки таблицы
  Widget _createTableRow(BuildContext context, int index) {
    final groupPerson = _groupPeriodPersons[index];
    final personAttendances = _groupAttendances.where(
            (attendance) => attendance.groupPersonId == groupPerson.id);
    final dates = personAttendances.map((attendance) => attendance.date).toList();
    final period = bloc.activePeriod.value;
    final rowCells = <Widget>[];
    // Итог по персоне за период
    rowCells.add(_createCell(personAttendances.length.toString(),
        color: Colors.black54, fontSize: 16.0));
    // Цикл по дням текущего периода
    for (int day = 1; day <= period.day; day++) {
      final date = DateTime(period.year, period.month, day);
      // Есть посещаемость в этот день, её можно удалить
      if (dates.contains(date)) {
        final attendance = personAttendances.firstWhere(
                (attendance) => attendance.date == date);
        rowCells.add(
          InkWell(
            onTap: () => _deleteAttendance(attendance),
            child: _createCell(
              doubleToString(attendance.hoursFact),
              color: isBirthday(date, groupPerson.person.birthday) 
                  ? Colors.red : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      // Посещаемости нет, её можно добавить
      } else {
        // Норма часов на дату
        var hoursNorm = getHoursNorm(bloc, date);
        final hoursNormStr = (hoursNorm > 0.0 &&
            (groupPerson.beginDate == null || groupPerson.beginDate.compareTo(date) <= 0) &&
            (groupPerson.endDate == null || groupPerson.endDate.compareTo(date) >= 0))
            ? doubleToString(hoursNorm) : '';
        if (hoursNorm == 0.0) {
          hoursNorm = getFirstHoursNorm(bloc);
        }
        // Добавление ячейки в строку
        rowCells.add(
          InkWell(
            onTap: () => _insertAttendance(groupPerson, date, hoursNorm),
            child: _createCell(
              hoursNormStr,
              color: isBirthday(date, groupPerson.person.birthday)
                  ? Colors.red[200] : Colors.black12,
            ),
          ),
        );
      }
    }
    return Row(children: rowCells);
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
  Future _insertAttendance(GroupPersonView groupPerson, DateTime date, double hoursFact) async {
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