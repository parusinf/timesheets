import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/ui/schedule_edit.dart';

/// Словарь графиков
class SchedulesDictionary extends StatefulWidget {
  @override
  SchedulesDictionaryState createState() => SchedulesDictionaryState();
}

/// Состояние словаря графиков
class SchedulesDictionaryState extends State<SchedulesDictionary> {
  Bloc get bloc => Provider.of<Bloc>(context);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(L10n.of(context).schedules),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: L10n.of(context).scheduleInserting,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScheduleEdit()),
          ),
        ),
      ],
    ),
    body: SafeArea(
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<ActiveSchedule>>(
          stream: Provider.of<Bloc>(context).activeSchedulesSubject,
          builder: (context, snapshot) {
            final schedules = snapshot.data ?? <ActiveSchedule>[];
            return ListView.builder(
              itemBuilder: (context, index) =>
                  _ScheduleCard(schedules, index),
              itemCount: schedules.length,
            );
          },
        ),
      ),
    ),
  );
}

/// Карточка графика
class _ScheduleCard extends StatelessWidget {
  final List<ActiveSchedule> schedules;
  final int index;
  final ActiveSchedule entry;
  _ScheduleCard(this.schedules, this.index) : entry = schedules[index];

  @override
  Widget build(BuildContext context) => Dismissible(
    confirmDismiss: (direction) async => entry.scheduleView.groupCount == 0,
    background: Material(
      color: Colors.red,
      borderRadius: BorderRadius.circular(16),
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    key: UniqueKey(),
    onDismissed: (direction) {
      schedules.removeAt(index);
      Provider.of<Bloc>(context, listen: false).deleteSchedule(entry.scheduleView);
    },
    child: Material(
      color: entry.isActive
          ? Colors.lightGreen.withOpacity(0.3) : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Provider.of<Bloc>(context, listen: false).showSchedule(entry.scheduleView);
          Navigator.pop(context, entry.scheduleView);
        },
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ScheduleEdit(scheduleView: entry.scheduleView)
            ),
          );
        },
        child: ListTile(
          title: Text(entry.scheduleView.code),
          trailing: Text('${entry.scheduleView.groupCount}',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: entry.isActive ? Colors.black54 : Colors.black26),
          ),
        ),
      ),
    ),
  );
}