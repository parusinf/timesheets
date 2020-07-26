import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/db/schedule_helper.dart';

/// Форма редактирования графика
class ScheduleEdit extends StatefulWidget {
  final Schedule schedule;
  const ScheduleEdit({Key key, this.schedule}) : super(key: key);
  @override
  _ScheduleEditState createState() => _ScheduleEditState(schedule);
}

/// Состояние формы редактирования графика
class _ScheduleEditState extends State<ScheduleEdit> {
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Schedule _schedule;
  DataActionType _actionType;

  _ScheduleEditState(this._schedule);

  @override
  void initState() {
    super.initState();
    if (_schedule == null) {
      _actionType = DataActionType.Insert;
      _insert();
    } else {
      _actionType = DataActionType.Update;
    }
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
    onWillPop: () async {
      if (_actionType == DataActionType.Insert) {
        bloc.deleteSchedule(_schedule);
      }
      return true;
    },
    child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_schedule == null
            ? L10n.of(context).scheduleInserting
            : L10n.of(context).scheduleUpdating
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.done),
            tooltip: L10n.of(context).done,
            onPressed: _handleSubmitted,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: StreamBuilder<List<ScheduleDay>>(
            stream: bloc.scheduleDayList,
            builder: (context, snapshot) => ListView.builder(
              itemBuilder: (context, index) => _scheduleDayCard(snapshot.data, index),
              itemCount: snapshot.data?.length ?? 0,
            ),
          ),
        ),
      ),
    ),
  );

  /// Карточка дня графика
  Widget _scheduleDayCard(List<ScheduleDay> scheduleDays, int index) => TextFormField(
    initialValue: format(scheduleDays[index].hoursNorm),
    keyboardType: TextInputType.numberWithOptions(),
    decoration: InputDecoration(
      icon: const Icon(Icons.watch_later),
      labelText: weekDays[scheduleDays[index].dayNumber],
    ),
    validator: _validateHoursNorm,
    onChanged: (value) {
      final hoursNorm = isNotEmpty(value) ? double.parse(value) : 0.0;
      scheduleDays[index] = scheduleDays[index].copyWith(hoursNorm: hoursNorm);
    },
  );

  /// Обработка формы
  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      _update();
    }
  }

  /// Проверка нормы часов
  String _validateHoursNorm(String value) {
    if (value.isNotEmpty) {
      final hoursNorm = double.tryParse(value);
      if (hoursNorm == null || hoursNorm > 24.0) {
        return L10n.of(context).invalidHoursNorm;
      }
    }
    return null;
  }

  /// Добавление графика
  Future _insert() async {
    try {
      _schedule = await bloc.insertSchedule(code: UniqueKey().toString());
      for (int dayNumber = 0; dayNumber < weekDays.length; dayNumber++) {
        await bloc.db.scheduleDaysDao.insert2(
          schedule: _schedule,
          dayNumber: dayNumber,
          hoursNorm: 0.0,
        );
      }
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Исправление графика
  Future _update() async {
    try {
      final hours = bloc.scheduleDayList.value.map((e) => e.hoursNorm).toList();
      if (_checkHoursNorm(hours)) {
        await bloc.updateSchedule(
            _schedule.copyWith(code: createScheduleCode(hours)));
        bloc.scheduleDayList.value.forEach((scheduleDay) =>
            bloc.db.scheduleDaysDao.update2(scheduleDay));
        Navigator.of(context).pop();
      }
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Проверка нормы часов
  bool _checkHoursNorm(List<double> hours) {
    final result = hours.reduce((a, b) => a + b) != 0.0;
    if (!result) {
      showMessage(_scaffoldKey, L10n.of(context).noHoursNorm);
    }
    return result;
  }
}