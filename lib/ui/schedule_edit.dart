import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/db/schedule_helper.dart';

/// Добавление графика
Future addSchedule(BuildContext context) async =>
    push(context, ScheduleEdit(null));

/// Исправление графика
Future editSchedule(BuildContext context, Schedule schedule) async {
  final bloc = Provider.of<Bloc>(context, listen: false);
  bloc.setActiveSchedule(schedule);
  push(context, ScheduleEdit(schedule));
}

/// Форма редактирования графика
class ScheduleEdit extends StatefulWidget {
  final Schedule schedule;
  final DataActionType actionType;
  const ScheduleEdit(this.schedule, {Key key})
      : this.actionType = schedule == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _ScheduleEditState createState() => _ScheduleEditState();
}

/// Состояние формы редактирования графика
class _ScheduleEditState extends State<ScheduleEdit> {
  get _bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    if (widget.actionType == DataActionType.Insert) {
      final scheduleDays = <ScheduleDay>[];
      for (int dayNumber = 0; dayNumber < abbrWeekdays.length; dayNumber++) {
        scheduleDays.add(ScheduleDay(
          id: dayNumber,
          scheduleId: 0,
          dayNumber: dayNumber,
          hoursNorm: 0.0,
        ));
      }
      _bloc.scheduleDays.add(scheduleDays);
    }
  }

  @override
  Widget build(BuildContext context) {
    return form(
      title: L10n.schedule,
      scaffoldKey: _scaffoldKey,
      formKey: _formKey,
      autovalidateMode: _autovalidateMode,
      onSubmit: _onSubmit,
      child: StreamBuilder<List<ScheduleDay>>(
        stream: _bloc.scheduleDays,
        builder: (context, snapshot) =>
            ListView.builder(
              itemBuilder: (context, index) =>
                  _scheduleDayCard(snapshot.data, index),
              itemCount: snapshot.data?.length ?? 0,
            ),
      ),
    );
  }

  /// Карточка дня графика
  Widget _scheduleDayCard(List<ScheduleDay> scheduleDays, int index) {
    return realFormField(
      initialValue: scheduleDays[index].hoursNorm,
      labelText: abbrWeekdays[scheduleDays[index].dayNumber],
      icon: Icons.watch_later,
      validator: (value) {
        if (value.isNotEmpty) {
          final hoursNorm = double.tryParse(value);
          if (hoursNorm == null || hoursNorm > 24.0) {
            return L10n.invalidHoursNorm;
          }
        }
        return null;
      },
      onChanged: (value) {
        final hoursNorm = isNotEmpty(value) ? double.parse(value) : 0.0;
        scheduleDays[index] =
            scheduleDays[index].copyWith(hoursNorm: hoursNorm);
      },
    );
  }

  /// Обработка формы
  Future _onSubmit() async {
    if (!_formKey.currentState.validate()) {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      try {
        final hours = <double>[];
        for (int i = 0; i < _bloc.scheduleDays.value.length; i++) {
          hours.add(_bloc.scheduleDays.value[i].hoursNorm);
        }
        if (hours.reduce((a, b) => a + b) == 0.0) {
          showMessage(_scaffoldKey, L10n.noHoursNorm);
        } else {
          if (widget.actionType == DataActionType.Insert) {
            final schedule = await _bloc.insertSchedule(code: createScheduleCode(hours));
            _bloc.scheduleDays.value.forEach((scheduleDay) =>
                _bloc.db.scheduleDaysDao.insert2(
                  schedule: schedule,
                  dayNumber: scheduleDay.dayNumber,
                  hoursNorm: scheduleDay.hoursNorm,
                ));
          } else {
            await _bloc.updateSchedule(Schedule(
              id: widget.schedule?.id,
              code: createScheduleCode(hours),
            ));
            _bloc.scheduleDays.value.forEach((scheduleDay) =>
                _bloc.db.scheduleDaysDao.update2(scheduleDay));
          }
          Navigator.of(context).pop();
        }
      } catch(e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }
}