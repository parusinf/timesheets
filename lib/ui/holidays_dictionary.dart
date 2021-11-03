import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/holiday_edit.dart';

/// Словарь праздников
class HolidaysDictionary extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(L10n.holidays),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => addHoliday(context),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(padding1),
            child: StreamBuilder<List<Holiday>>(
                stream: Provider.of<Bloc>(context).holidays,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.length > 0) {
                      return ListView.builder(
                        itemBuilder: (context, index) =>
                            _HolidayCard(snapshot.data, index),
                        itemCount: snapshot.data.length,
                      );
                    } else {
                      return centerButton(L10n.addHoliday,
                          onPressed: () => addHoliday(context));
                    }
                  } else {
                    return centerMessage(context, L10n.dataLoading);
                  }
                }),
          ),
        ),
      );
}

/// Карточка праздника
class _HolidayCard extends StatelessWidget {
  final List<Holiday> holidays;
  final int index;
  final Holiday holiday;
  _HolidayCard(this.holidays, this.index) : holiday = holidays[index];

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, padding2),
        child: Dismissible(
          background: Material(
            color: Colors.red,
            borderRadius: BorderRadius.circular(borderRadius),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          key: UniqueKey(),
          onDismissed: (direction) {
            holidays.removeAt(index);
            Provider.of<Bloc>(context, listen: false).deleteHoliday(holiday);
          },
          child: Material(
            color: Colors.lightGreen.withOpacity(passiveColorOpacity),
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: () {
                Navigator.pop(context, holiday);
              },
              onDoubleTap: () => editHoliday(context, holiday),
              child: ListTile(
                title: Text(dateToString(holiday.date)),
                subtitle: holiday.workday != null
                    ? Text('${L10n.workday} ${dateToString(holiday.workday)}')
                    : null,
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => editHoliday(context, holiday),
                ),
              ),
            ),
          ),
        ),
      );
}
