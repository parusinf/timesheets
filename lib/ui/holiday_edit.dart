import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Добавление праздника
Future addHoliday(BuildContext context) async =>
    push(context, HolidayEdit(null));

/// Исправление праздника
Future editHoliday(BuildContext context, Holiday holiday) async =>
    push(context, HolidayEdit(holiday));

/// Форма редактирования праздника
class HolidayEdit extends StatefulWidget {
  final Holiday holiday;
  final DataActionType actionType;
  const HolidayEdit(this.holiday, {Key key})
      : this.actionType = holiday == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _HolidayEditState createState() => _HolidayEditState();
}

/// Состояние формы редактирования праздника
class _HolidayEditState extends State<HolidayEdit> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _holidayEdit = TextEditingController();
  final _workdayEdit = TextEditingController();
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
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(L10n.holidays),
      actions: <Widget>[
        IconButton(icon: const Icon(Icons.done), onPressed: _handleSubmitted),
      ],
    ),
    body: Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Scrollbar(
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          padding: const EdgeInsets.symmetric(horizontal: padding1),
          child: Column(
            children: <Widget>[
              divider(height: padding2),
              // Праздничный день
              TextFormField(
                controller: _holidayEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.event),
                  labelText: L10n.holiday,
                ),
                validator: _validateDate,
                inputFormatters: DateFormatters.formatters,
                maxLength: 10,
              ),
              // Рабочий день
              TextFormField(
                controller: _workdayEdit,
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  icon: const Icon(Icons.event),
                  labelText: L10n.workday,
                ),
                validator: _validateNullableDate,
                inputFormatters: DateFormatters.formatters,
                maxLength: 10,
              ),
            ],
          ),
        ),
      ),
    ),
  );

  /// Обработка формы
  Future _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      try {
        switch (widget.actionType) {
          case DataActionType.Insert:
            await bloc.insertHoliday(
              date: stringToDate(_holidayEdit.text),
              workday: stringToDate(_workdayEdit.text),
            );
            break;
          case DataActionType.Update:
            await bloc.updateHoliday(Holiday(
              id: widget.holiday.id,
              date: stringToDate(_holidayEdit.text),
              workday: stringToDate(_workdayEdit.text),
            ));
            break;
          case DataActionType.Delete: break;
        }
        Navigator.of(context).pop();
      } catch(e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }

  /// Проверка даты
  String _validateDate(String value) {
    if (stringToDate(value) == null) {
      return L10n.invalidDate;
    }
    return null;
  }

  /// Проверка необязательной даты
  String _validateNullableDate(String value) {
    if (value.isNotEmpty && stringToDate(value) == null) {
      return L10n.invalidDate;
    }
    return null;
  }
}