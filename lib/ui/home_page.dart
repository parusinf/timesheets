import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/home_drawer.dart';
import 'package:timesheets/ui/timesheet_card.dart';

/// Табели
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

/// Состояние табелей
class HomePageState extends State<HomePage> {
  Bloc get bloc => Provider.of<Bloc>(context);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: StreamBuilder<Group>(
        stream: bloc.activeGroup,
        builder: (context, snapshot) =>
            snapshot.hasData ? Text(snapshot.data.name) : Text('')
      )
    ),
    drawer: HomeDrawer(),
    body: StreamBuilder<List<GroupPerson>>(
      stream: bloc.groupPersonList,
      builder: (context, snapshot) {
        // Организаций нет
        if (bloc.activeOrg.value == null) {
          return centerMessage(context, L10n.of(context).noOrgs);
        } else {
          // Групп нет
          if (bloc.activeGroup.value == null) {
            return centerMessage(context, L10n.of(context).noGroups);
          } else {
            // Данные загрузились
            if (snapshot.hasData) {
              // Персон нет
              if (snapshot.data.length == 0) {
                return centerMessage(context, L10n.of(context).noPersons);
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) => TimesheetCard(snapshot.data[index]),
                  itemCount: snapshot.data.length,
                );
              }
            // Данные загружаются
            } else {
              return centerMessage(context, L10n.of(context).dataLoading);
            }
          }
        }
      }
    ),
  );
}