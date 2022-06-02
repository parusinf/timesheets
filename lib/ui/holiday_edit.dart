import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Добавление праздника
Future addHoliday(BuildContext context) async =>
    push(context, const HolidayEdit(null));

/// Исправление праздника
Future editHoliday(BuildContext context, Holiday holiday) async =>
    push(context, HolidayEdit(holiday));

/// Форма редактирования праздника
class HolidayEdit extends StatefulWidget {
  final Holiday? holiday;
  final DataActionType actionType;
  const HolidayEdit(this.holiday, {Key? key})
      : actionType = holiday == null ? DataActionType.insert : DataActionType.update,
        super(key: key);
  @override
  HolidayEditState createState() => HolidayEditState();
}

/// Состояние формы редактирования праздника
class HolidayEditState extends State<HolidayEdit> {
  final _holidayEdit = TextEditingController();
  final _workdayEdit = TextEditingController();

  get _bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _holidayEdit.text = dateToString(widget.holiday?.date);
    _workdayEdit.text = dateToString(widget.holiday?.workday);
  }

  @override
  void dispose() {
    _holidayEdit.dispose();
    _workdayEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return form(
      title: L10n.holidays,
      scaffoldKey: _scaffoldKey,
      formKey: _formKey,
      autovalidateMode: _autovalidateMode,
      onSubmit: _onSubmit,
      fields: <Widget>[
        // Праздничный день
        dateFormField(
          controller: _holidayEdit,
          labelText: L10n.holiday,
          validator: validateEmpty,
        ),
        // Рабочий день
        dateFormField(
          controller: _workdayEdit,
          labelText: L10n.workday,
        ),
      ],
    );
  }

  /// Обработка формы
  Future _onSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      try {
        if (widget.actionType == DataActionType.insert) {
          await _bloc.insertHoliday(
            date: stringToDateOrNull(_holidayEdit.text),
            workday: stringToDateOrNull(_workdayEdit.text),
          );
        } else {
          await _bloc.updateHoliday(Holiday(
            id: widget.holiday?.id ?? 0,
            date: stringToDate(_holidayEdit.text),
            workday: stringToDateOrNull(_workdayEdit.text),
          ));
        }
        if (!mounted) return;
        Navigator.of(context).pop();
      } catch (e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }
}
