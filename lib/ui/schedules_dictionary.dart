import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/ui/schedule_edit.dart';

/// Словарь графиков
class SchedulesDictionary extends StatefulWidget {
  const SchedulesDictionary({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => SchedulesDictionaryState();
}

class SchedulesDictionaryState extends State<SchedulesDictionary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.schedules),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await push(context, const ScheduleEdit(null));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(padding1),
          child: StreamBuilder<List<ActiveSchedule>>(
              stream: Provider
                  .of<Bloc>(context)
                  .activeSchedules,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      itemBuilder: (context, index) =>
                          ScheduleCard(snapshot.data!, index),
                      itemCount: snapshot.data!.length,
                    );
                  } else {
                    return centerButton(
                        L10n.addSchedule,
                        onPressed: () async {
                          await push(context, const ScheduleEdit(null));
                        }
                    );
                  }
                } else {
                  return centerMessage(context, L10n.dataLoading);
                }
              }),
        ),
      ),
    );
  }
}

/// Карточка графика
class ScheduleCard extends StatefulWidget {
  final List<ActiveSchedule> schedules;
  final int index;
  final ActiveSchedule entry;

  ScheduleCard(this.schedules, this.index, {Key? key})
      : entry = schedules[index],
        super(key: key);

  @override
  State<StatefulWidget> createState() => ScheduleCardState();
}

class ScheduleCardState extends State<ScheduleCard> {
  get _bloc => Provider.of<Bloc>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, padding2),
      child: Dismissible(
        confirmDismiss: (direction) async =>
        widget.entry.scheduleView.groupCount == 0,
        background: Material(
          color: Colors.red,
          borderRadius: BorderRadius.circular(borderRadius),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        key: UniqueKey(),
        onDismissed: (direction) {
          widget.schedules.removeAt(widget.index);
          _bloc.deleteSchedule(widget.entry.scheduleView);
        },
        child: Material(
          color: widget.entry.isActive
              ? Colors.lightGreen.withOpacity(activeColorOpacity)
              : Colors.lightGreen.withOpacity(passiveColorOpacity),
          borderRadius: BorderRadius.circular(borderRadius),
          child: InkWell(
            onTap: () async {
              await _bloc.setActiveSchedule(widget.entry.scheduleView);
              if (!mounted) return;
              Navigator.pop(context, widget.entry.scheduleView);
            },
            onDoubleTap: () async {
              await editSchedule(context, widget.entry.scheduleView);
            },
            child: ListTile(
              title: Text(widget.entry.scheduleView.code),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await editSchedule(context, widget.entry.scheduleView);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
