import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/packages/month_picker_dialog/month_picker_dialog.dart';
import 'package:timesheets/packages/horizontal_data_table/horizontal_data_table.dart';
import 'package:uri_to_file/uri_to_file.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/core/send_timesheet.dart';
import 'package:timesheets/core/receive_timesheet.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/home_drawer.dart';
import 'package:timesheets/ui/org_edit.dart';
import 'package:timesheets/ui/group_edit.dart';
import 'package:timesheets/ui/group_persons_dictionary.dart';
import 'package:timesheets/ui/person_edit.dart';
import 'package:timesheets/ui/help_page.dart';

/// Табели
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  HomePageState createState() => HomePageState();
}

/// Состояние табелей
class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  get _bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<GroupPersonView>? _groupPeriodPersons;
  List<Attendance>? _groupAttendances;
  static const fixedColumnWidth = 150.0;
  static const rowHeight = 56.0;
  static const columnWidth = 56.0;
  static const leftPadding = 12.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: createAppBar(),
      drawer: const HomeDrawer(),
      body: StreamBuilder<String?>(
        stream: _bloc.content,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            receiveContent(snapshot.data!);
          }
          return createBody();
        },
      ),
    );
  }

  PreferredSizeWidget? createAppBar() {
    return AppBar(
      title: StreamBuilder<GroupView?>(
        stream: _bloc.activeGroup,
        builder: (context, snapshot) => snapshot.hasData
            ? InkWell(
          onTap: () async {
            await push(context, const GroupPersonsDictionary());
          },
          child: text(snapshot.data!.name),
        )
            : StreamBuilder<OrgView?>(
            stream: _bloc.activeOrg,
            builder: (context, snapshot) => snapshot.hasData
                ? InkWell(
              onTap: () => editOrg(context, _bloc.activeOrg.valueWrapper?.value),
              child: text(snapshot.data!.name),
            )
                : InkWell(
              onTap: () => push(context, const HelpPage()),
              child: text(L10n.timesheets),
            )),
      ),
      actions: <Widget>[
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            items: [
              DropdownMenuItem(
                value: L10n.sendTimesheet,
                child: const Icon(Icons.file_upload),
              ),
              DropdownMenuItem(
                value: L10n.receiveTimesheet,
                child: const Icon(Icons.file_download),
              ),
            ],
            onChanged: (String? value) {
              setState(() {
                if (L10n.sendTimesheet == value) {
                  send();
                } else if (L10n.receiveTimesheet == value) {
                  receive();
                }
              });
            },
          ),
        ),
      ],
    );
  }

  Widget createBody() {
    return StreamBuilder<List<GroupPersonView>>(
        stream: _bloc.groupPeriodPersons,
        builder: (context, snapshot) {
          // Добавить организацию
          if (_bloc.activeOrg.valueWrapper?.value == null) {
            return centerButton(L10n.addOrg, onPressed: () => addOrg(context));
          } else {
            // Добавить группу
            if (_bloc.activeGroup.valueWrapper?.value == null) {
              return centerButton(L10n.addGroup,
                  onPressed: () => addGroup(context));
            } else {
              // Персоны группы загрузились
              if (snapshot.hasData) {
                _groupPeriodPersons = snapshot.data;
                return StreamBuilder<List<Attendance>>(
                    stream: _bloc.attendances,
                    builder: (context, snapshot) {
                      // Посещаемость загрузилась
                      if (snapshot.hasData) {
                        _groupAttendances = snapshot.data;
                        return HorizontalDataTable(
                          leftHandSideColumnWidth: fixedColumnWidth,
                          rightHandSideColumnWidth:
                          columnWidth * (_bloc.activePeriod.valueWrapper.value.day + 1),
                          isFixedHeader: true,
                          headerWidgets: createTitleRow(),
                          leftSideItemBuilder: createFixedColumn,
                          rightSideItemBuilder: createTableRow,
                          itemCount: _groupPeriodPersons!.length,
                          rowSeparatorWidget:
                          const Divider(color: lineColor, height: 0.5),
                        );
                        // Посещаемость загружаются
                      } else {
                        return centerMessage(context, L10n.dataLoading);
                      }
                    });
                // Персоны группы загружаются
              } else {
                return centerMessage(context, L10n.dataLoading);
              }
            }
          }
        });
  }

  /// Получение табеля из переданного контента
  Future receiveContent(String content) async {
    if (isNotEmpty(content) && content != 'null') {
      try {
        if (content.contains('content://')) {
          File file = await toFile(content);
          await receiveFromFile(_bloc, file);
        } else {
          await receiveFromContent(_bloc, content);
        }
      } catch (e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }

  /// Получение табеля
  Future receive() async {
    try {
      String result = '';
      if (_bloc.useParusIntegration) {
        result = await receiveFromParus(_bloc);
      } else {
        result = await pickAndReceiveFromFile(_bloc);
      }
      showMessage(_scaffoldKey, result);
    } catch (e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Отправка табеля
  Future send() async {
    final org = _bloc.activeOrg.valueWrapper?.value;
    final group = _bloc.activeGroup.valueWrapper?.value;
    if (org == null) {
      showMessage(_scaffoldKey, L10n.addOrg);
    }
    else if (group == null) {
      showMessage(_scaffoldKey, L10n.addGroup);
    }
    else {
      try {
        final result = await sendTimesheet(
          org,
          group,
          _bloc.activePeriod.valueWrapper?.value,
          _groupPeriodPersons!,
          _groupAttendances!,
          _bloc.useParusIntegration,
        );
        showMessage(_scaffoldKey, result);
      } catch (e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }

  /// Создание строки заголовка таблицы
  List<Widget> createTitleRow() {
    final DateTime period = _bloc.activePeriod.valueWrapper?.value;
    final rowCells = <Widget>[
      StreamBuilder<DateTime?>(
        stream: _bloc.activePeriod,
        builder: (context, snapshot) => InkWell(
            onTap: selectPeriod,
            child: snapshot.hasData
                ? createCell(
              periodToString(snapshot.data!),
              width: fixedColumnWidth,
              alignment: Alignment.centerLeft,
              leftPadding: leftPadding,
              color: Colors.lightBlue,
              fontSize: 14.0,
            )
                : const Text('')),
      ),
    ];
    // Количество присутствующих персон на период
    final daysCount =
        _groupAttendances?.where((e) => e.hoursFact > 0.0).toList().length;
    // Дней посещения персоны за период
    rowCells.add(
      StreamBuilder<DateTime?>(
          stream: _bloc.activePeriod,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return createFixedCell(
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
              return const Text('');
            }
          }),
    );
    // Колонки по дням периода
    for (int day = 1; day <= period.day; day++) {
      final date = DateTime(period.year, period.month, day);
      final hoursNorm = getHoursNorm(_bloc, date);
      // Количество присутствующих персон на дату
      final dateCount = _groupAttendances
          ?.where((e) => e.date == date && e.hoursFact > 0.0)
          .toList()
          .length;
      final dateCountStr = dateCount! > 0.0
          ? dateCount.toString()
          : hoursNorm > 0.0
          ? '0'
          : '';
      // Добавление ячейки в строку
      rowCells.add(
        StreamBuilder<DateTime?>(
            stream: _bloc.activePeriod,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return createFixedCell(
                  '${abbrWeekday(date).capitalize()} ${day.toString()}',
                  dateCountStr,
                  width: columnWidth,
                  alignment: Alignment.center,
                  borderStyle: BorderStyle.solid,
                  titleColor:
                  isHoliday(_bloc, date) ? Colors.red : Colors.black87,
                  subtitleColor: Colors.black54,
                  wrap: false,
                  onTap: () => { fillPresenceOfAllPersonsOnDate(date, hoursNorm) },
                );
              } else {
                return const Text('');
              }
            }),
      );
    }
    return rowCells;
  }

  /// Создание ячейки таблицы
  Widget createCell(
      String title, {
        width = columnWidth,
        alignment = Alignment.center,
        leftPadding = 0.0,
        borderStyle = BorderStyle.solid,
        color = Colors.black87,
        fontSize = 14.0,
        fontWeight = FontWeight.normal,
      }) {
    return Container(
      width: width,
      height: rowHeight,
      padding: EdgeInsets.fromLTRB(leftPadding, 0.0, 0.0, 0.0),
      alignment: alignment,
      decoration: BoxDecoration(
        border: Border(
            left:
            BorderSide(color: lineColor, width: 0.5, style: borderStyle)),
      ),
      child: text(title,
          color: color, fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  /// Создание фиксированной ячейки
  Widget createFixedCell(
      String title,
      String? subtitle, {
        double width = columnWidth,
        alignment = Alignment.center,
        crossAxisAlignment = CrossAxisAlignment.center,
        titleColor = Colors.black87,
        subtitleColor = Colors.black54,
        leftPadding = 0.0,
        borderStyle = BorderStyle.none,
        Function()? onTap,
        wrap = true,
      }) {
    final columnRows = <Widget>[];
    columnRows.add(text(title,
        fontSize: 16.0,
        color: titleColor,
        fontWeight: wrap ? FontWeight.bold : FontWeight.normal));
    if (!wrap) columnRows.add(divider(height: padding3));
    if (subtitle != null) {
      columnRows.add(text(subtitle, fontSize: 16.0, color: subtitleColor));
    }

    return InkWell(
      onTap: onTap ?? () => {},
      child: Container(
        width: width,
        height: rowHeight,
        alignment: alignment,
        padding: EdgeInsets.fromLTRB(leftPadding, 0.0, 0.0, 0.0),
        decoration: BoxDecoration(
          border: Border(
              left:
              BorderSide(color: lineColor, width: 0.5, style: borderStyle)),
        ),
        child: wrap
            ? Wrap(children: columnRows)
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: crossAxisAlignment,
          children: columnRows,
        ),
      ),
    );
  }

  /// Создание фиксированной колонки
  Widget createFixedColumn(BuildContext context, int index) {
    final person = _groupPeriodPersons![index].person;
    return createFixedCell(
      '${index + 1}. ${person.family} ',
      personName(person, showMiddleName: false),
      width: fixedColumnWidth,
      alignment: Alignment.centerLeft,
      crossAxisAlignment: CrossAxisAlignment.start,
      leftPadding: leftPadding,
      onTap: () => editPerson(context, person),
    );
  }

  /// Создание строки таблицы
  Widget createTableRow(BuildContext context, int index) {
    final groupPerson = _groupPeriodPersons![index];
    final personAttendances = _groupAttendances
        ?.where((attendance) => attendance.groupPersonId == groupPerson.id);
    final period = _bloc.activePeriod.valueWrapper?.value;
    final rowCells = <Widget>[];
    // Итог по персоне за период
    final daysCount =
        personAttendances?.where((e) => e.hoursFact > 0.0).toList().length;
    rowCells.add(createCell(daysCount.toString(),
        color: Colors.black54, fontSize: 16.0));
    // Цикл по дням текущего периода
    for (int day = 1; day <= period.day; day++) {
      final date = DateTime(period.year, period.month, day);
      Attendance? attendance;
      if (personAttendances != null) {
        for (var a in personAttendances) {
          if (date == a.date) {
            attendance = a;
            break;
          }
        }
      }
      // Посещаемости нет в этот день, её можно добавить
      if (attendance == null) {
        // Норма часов на дату
        var hoursNorm = getHoursNorm(_bloc, date);
        final hoursNormStr = (hoursNorm > 0.0 &&
            (groupPerson.beginDate == null ||
                groupPerson.beginDate!.compareTo(date) <= 0) &&
            (groupPerson.endDate == null ||
                groupPerson.endDate!.compareTo(date) >= 0))
            ? doubleToString(hoursNorm)
            : '';
        if (hoursNorm == 0.0) {
          hoursNorm = getFirstHoursNorm(_bloc);
        }
        // Добавление ячейки в строку
        rowCells.add(
          InkWell(
            onTap: () {
              if (!_bloc.doubleTapInTimesheet) {
                insertAttendance(groupPerson, date, hoursNorm, false);
              }
            },
            onDoubleTap: () {
              if (_bloc.doubleTapInTimesheet) {
                insertAttendance(groupPerson, date, hoursNorm, false);
              }
            },
            child: createCell(
              hoursNormStr,
              color: isBirthday(date, groupPerson.person.birthday)
                  ? Colors.red[200]
                  : Colors.black12,
            ),
          ),
        );
      // Включена настройка типа дня
      } else if (_bloc.useIsIllness) {
        // Есть посещаемость, её можно переключить на отсутствие по болезни
        if (attendance.hoursFact > 0.0) {
          rowCells.add(
            InkWell(
              onTap: () {
                if (!_bloc.doubleTapInTimesheet) {
                  switchToIllness(attendance!);
                }
              },
              onDoubleTap: () {
                if (_bloc.doubleTapInTimesheet) {
                  switchToIllness(attendance!);
                }
              },
              child: createCell(
                doubleToString(attendance.hoursFact),
                color: isBirthday(date, groupPerson.person.birthday)
                    ? Colors.red
                    : Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        // Есть отсутствие по болезни, его можно удалить
        } else {
          rowCells.add(
            InkWell(
              onTap: () {
                if (!_bloc.doubleTapInTimesheet) {
                  deleteAttendance(attendance!);
                }
              },
              onDoubleTap: () {
                if (_bloc.doubleTapInTimesheet) {
                  deleteAttendance(attendance!);
                }
              },
              child: createCell(
                L10n.b,
                color: isBirthday(date, groupPerson.person.birthday)
                    ? Colors.red
                    : Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }
      // Настройка типа дня выключена, посещаемость можно удалить
      } else {
        rowCells.add(
          InkWell(
            onTap: () {
              if (!_bloc.doubleTapInTimesheet) {
                deleteAttendance(attendance!);
              }
            },
            onDoubleTap: () {
              if (_bloc.doubleTapInTimesheet) {
                deleteAttendance(attendance!);
              }
            },
            child: createCell(
              doubleToString(attendance.hoursFact),
              color: isBirthday(date, groupPerson.person.birthday)
                  ? Colors.red
                  : Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
    }
    return Row(children: rowCells);
  }

  /// Выбор активного периода
  selectPeriod() async {
    final period = await showMonthPicker(
      context: context,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
      initialDate: _bloc.activePeriod.valueWrapper?.value,
    );
    if (period != null) {
      await _bloc.setActivePeriod(lastDayOfMonth(period));
    }
  }

  /// Добавление посещаемости
  insertAttendance(
      GroupPersonView groupPerson,
      DateTime date,
      double hoursFact,
      bool isIllness,
      ) async {
    try {
      await _bloc.insertAttendance(
        groupPerson: groupPerson,
        date: date,
        hoursFact: hoursFact,
        isIllness: isIllness,
      );
    } catch (e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Переключение на тип дня Б
  switchToIllness(Attendance attendance) async {
    try {
      final newAttendance = Attendance(
        id: attendance.id,
        groupPersonId: attendance.groupPersonId,
        date: attendance.date,
        hoursFact: 0.0,
        isIllness: true,
      );
      await _bloc.updateAttendance(newAttendance);
    } catch (e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Удаление посещаемости
  deleteAttendance(Attendance attendance) async {
    try {
      await _bloc.deleteAttendance(attendance);
    } catch (e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Заполнение присутствия всех персон на дату
  fillPresenceOfAllPersonsOnDate(DateTime date, double hoursNorm) {
    if (_groupPeriodPersons != null) {
      final alertMessage = '${L10n.fillPresenceOfAllPersons} ${dateToString(date)}';
      showAlertDialog(context, alertMessage, () async {
        for (var groupPerson in _groupPeriodPersons!) {
          insertAttendance(groupPerson, date, hoursNorm, false);
        }
      });
    }
  }
}
