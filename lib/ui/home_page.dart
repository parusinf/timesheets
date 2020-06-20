import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/home_drawer.dart';
import 'package:timesheets/ui/timesheet_card.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/core/tools.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

/// Отображает наименование группы и табели посещаемости персон в группе
class HomePageState extends State<HomePage> {
  Bloc get bloc => Provider.of<Bloc>(context);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: StreamBuilder<Group>(
        stream: bloc.activeGroupSubject,
        builder: (context, snapshot) =>
            snapshot.hasData ? Text(snapshot.data.name) : Text('')
      )
    ),
    drawer: HomeDrawer(),
    body: StreamBuilder<List<GroupPerson>>(
        stream: bloc.groupPersonsStream,
        builder: (context, snapshot) {
          if (bloc.activeOrgSubject.value == null)
            return centerMessage(context, L10n.of(context).noOrgs);
          else if (bloc.activeGroupSubject.value == null)
            return centerMessage(context, L10n.of(context).noGroups);
          else if (snapshot.hasData)
            if (snapshot.data.length > 0)
              return ListView.builder(
                itemBuilder: (context, index) => TimesheetCard(
                    snapshot.data[index]
                ),
                itemCount: snapshot.data.length,
              );
            else
              return centerMessage(context, L10n.of(context).noPersons);
          else
            return centerMessage(context, L10n.of(context).dataLoading);
        }
    ),
  );

  /// Сообщение в центре страницы серым цветом
  Widget centerMessage(BuildContext context, String message) =>
      Center(child: greyText(context, message));
}
