import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/ui/schedule_edit.dart';

/// Словарь графиков
class SchedulesDictionary extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(L10n.schedules),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => addSchedule(context),
        ),
      ],
    ),
    body: SafeArea(
      child: Padding(
      padding: const EdgeInsets.all(padding1),
      child: StreamBuilder<List<ActiveSchedule>>(
          stream: Provider.of<Bloc>(context).activeSchedules,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                  itemBuilder: (context, index) => _ScheduleCard(snapshot.data, index),
                  itemCount: snapshot.data.length,
                );
              } else {
                return centerButton(L10n.addSchedule, onPressed: () => addSchedule(context));
              }
            } else {
              return centerMessage(context, L10n.dataLoading);
            }
          }
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
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, padding2),
    child: Dismissible(
      confirmDismiss: (direction) async => entry.scheduleView.groupCount == 0,
      background: Material(
        color: Colors.red,
        borderRadius: BorderRadius.circular(borderRadius),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        schedules.removeAt(index);
        Provider.of<Bloc>(context, listen: false).deleteSchedule(entry.scheduleView);
      },
      child: Material(
        color: entry.isActive
            ? Colors.lightGreen.withOpacity(activeColorOpacity)
            : Colors.lightGreen.withOpacity(passiveColorOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: () {
            Provider.of<Bloc>(context, listen: false).setActiveSchedule(entry.scheduleView);
            Navigator.pop(context, entry.scheduleView);
          },
          onDoubleTap: () => editSchedule(context, entry.scheduleView),
          child: ListTile(
            title: Text(entry.scheduleView.code),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => editSchedule(context, entry.scheduleView),
            ),
          ),
        ),
      ),
    ),
  );
}