import 'package:flutter/widgets.dart';

class PeriodInfo extends InheritedWidget {
  final DateTime period;

  PeriodInfo(this.period, Widget child): super(child: child);

  static PeriodInfo of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(PeriodInfo oldPeriodInfo) {
    var oldPeriod = oldPeriodInfo?.period ?? 0;
    var newPeriod = period ?? 0;
    if (oldPeriod == 0 && newPeriod == 0) {
      return true;
    }
    return oldPeriod != newPeriod;
  }
}

class PeriodInheritedWidget extends StatefulWidget {
  static PeriodInfo of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  const PeriodInheritedWidget({this.child, Key key}) : super(key: key);

  final Widget child;

  @override
  _PeriodInheritedState createState() => _PeriodInheritedState();
}

class _PeriodInheritedState extends State<PeriodInheritedWidget> {
  DateTime _period;

  @override
  void initState() {
    super.initState();
    _period = _lastDayDateTime(DateTime.parse('2020-05-31 00:00:00.000')/*DateTime.now()*/);
  }

  /// Дата с последним днём месяца
  _lastDayDateTime(DateTime date) {
    return date.month < 12 ?
        DateTime(date.year, date.month + 1, 0) : DateTime(date.year + 1, 1, 0);
  }

  void onPositionChange(DateTime newPeriod) {
    setState(() {
      _period = newPeriod;
    });
  }

  @override
  Widget build(BuildContext context) => PeriodInfo(_period, widget.child);
}
