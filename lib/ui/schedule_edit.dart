import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/db/schedule_helper.dart';

/// Форма редактирования графика
class ScheduleEdit extends StatefulWidget {
  final Schedule schedule;
  final DataActionType actionType;
  const ScheduleEdit({Key key, this.schedule})
      : this.actionType = schedule == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _ScheduleEditState createState() => _ScheduleEditState();
}

/// Состояние формы редактирования графика
class _ScheduleEditState extends State<ScheduleEdit> {
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    if (widget.actionType == DataActionType.Insert) {
      final scheduleDays = List<ScheduleDay>();
      for (int dayNumber = 0; dayNumber < abbrWeekdays.length; dayNumber++) {
        scheduleDays.add(ScheduleDay(
          id: dayNumber,
          scheduleId: 0,
          dayNumber: dayNumber,
          hoursNorm: 0.0,
        ));
      }
      bloc.scheduleDays.add(scheduleDays);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(widget.actionType == DataActionType.Insert
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
          stream: bloc.scheduleDays,
          builder: (context, snapshot) => ListView.builder(
            itemBuilder: (context, index) => _scheduleDayCard(snapshot.data, index),
            itemCount: snapshot.data?.length ?? 0,
          ),
        ),
      ),
    ),
  );

  /// Карточка дня графика
  Widget _scheduleDayCard(List<ScheduleDay> scheduleDays, int index) => TextFormField(
    initialValue: doubleToString(scheduleDays[index].hoursNorm),
    keyboardType: TextInputType.numberWithOptions(),
    decoration: InputDecoration(
      icon: const Icon(Icons.watch_later),
      labelText: abbrWeekdays[scheduleDays[index].dayNumber],
    ),
    validator: _validateHoursNorm,
    onChanged: (value) {
      final hoursNorm = isNotEmpty(value) ? double.parse(value) : 0.0;
      scheduleDays[index] = scheduleDays[index].copyWith(hoursNorm: hoursNorm);
    },
  );

  /// Обработка формы
  Future _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      try {
        final hours = bloc.scheduleDays.value.map((e) => e.hoursNorm).toList();
        if (hours.reduce((a, b) => a + b) == 0.0) {
          showMessage(_scaffoldKey, L10n.of(context).noHoursNorm);
        } else {
          switch (widget.actionType) {
            case DataActionType.Insert: _insert(hours); break;
            case DataActionType.Update: _update(hours); break;
            case DataActionType.Delete: break;
          }
          Navigator.of(context).pop();
        }
      } catch(e) {
        showMessage(_scaffoldKey, e.toString());
      }
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
  Future _insert(List<double> hours) async {
    final schedule = await bloc.insertSchedule(code: createScheduleCode(hours));
    bloc.scheduleDays.value.forEach((scheduleDay) =>
        bloc.db.scheduleDaysDao.insert2(
          schedule: schedule,
          dayNumber: scheduleDay.dayNumber,
          hoursNorm: scheduleDay.hoursNorm,
        ));
  }

  /// Исправление графика
  Future _update(List<double> hours) async {
    await bloc.updateSchedule(Schedule(
      id: widget.schedule.id,
      code: createScheduleCode(hours),
    ));
    bloc.scheduleDays.value.forEach((scheduleDay) =>
        bloc.db.scheduleDaysDao.update2(scheduleDay));
  }
}