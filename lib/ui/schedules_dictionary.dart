import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/ui/schedule_edit.dart';

/// Словарь графиков
class SchedulesDictionary extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(L10n.of(context).schedules),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: L10n.of(context).scheduleInserting,
          onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ScheduleEdit())),
        ),
      ],
    ),
    body: SafeArea(
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<ActiveSchedule>>(
          stream: Provider.of<Bloc>(context).activeSchedules,
          builder: (context, snapshot) => ListView.builder(
            itemBuilder: (context, index) => _ScheduleCard(snapshot.data, index),
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
          ),
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
          Provider.of<Bloc>(context, listen: false).setActiveSchedule(entry.scheduleView);
          Navigator.pop(context, entry.scheduleView);
        },
        onDoubleTap: () {
          Provider.of<Bloc>(context, listen: false).setActiveSchedule(entry.scheduleView);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                ScheduleEdit(schedule: entry.scheduleView)
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