import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart' show DragStartBehavior;
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';

/// Форма редактирования графика
class ScheduleEdit extends StatefulWidget {
  final Schedule scheduleView;
  const ScheduleEdit({Key key, this.scheduleView}) : super(key: key);
  @override
  _ScheduleEditState createState() => _ScheduleEditState();
}

/// Состояние формы редактирования графика
class _ScheduleEditState extends State<ScheduleEdit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final TextEditingController _codeEdit = TextEditingController();

  @override
  void initState() {
    _codeEdit.text = widget.scheduleView?.code;
    super.initState();
  }

  @override
  void dispose() {
    _codeEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(widget.scheduleView == null
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
      child: Scrollbar(
        child: SingleChildScrollView(
          dragStartBehavior: DragStartBehavior.down,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              horizontalSpace,
              // Мнемокод графика
              TextFormField(
                controller: _codeEdit,
                autofocus: true,
                decoration: InputDecoration(
                  filled: true,
                  icon: const Icon(Icons.calendar_today),
                  labelText: L10n.of(context).scheduleCode,
                ),
                validator: _validateCode,
              ),
              horizontalSpace,
              // Дни графика

            ],
          ),
        ),
      ),
    ),
  );

  /// Обработка формы
  void _handleSubmitted() {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      if (widget.scheduleView == null) {
        _insert();
      } else {
        _update();
      }
    }
  }

  /// Проверка мнемокода
  String _validateCode(String value) {
    if (value.isEmpty) {
      return L10n.of(context).noCode;
    }
    return null;
  }

  /// Добавление
  Future _insert() async {
    try {
      await bloc.insertSchedule(code: _codeEdit.text);
      Navigator.of(context).pop();
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }

  /// Исправление
  Future _update() async {
    try {
      await bloc.updateSchedule(widget.scheduleView.copyWith(code: _codeEdit.text));
      Navigator.of(context).pop();
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }
}