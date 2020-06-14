import 'package:flutter/material.dart' hide Column;
import 'package:flutter/widgets.dart' as f show Column;
import 'package:provider/provider.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/home_drawer.dart';
import 'package:timesheets/ui/timesheet_card.dart';
import 'package:timesheets/core/l10n.dart';

class HomeScreen extends StatefulWidget {
  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

/// Отображает наименование группы и табели посещаемости персон в группе
class HomeScreenState extends State<HomeScreen> {
  Bloc get bloc => Provider.of<Bloc>(context);
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: StreamBuilder<Group>(
        stream: bloc.activeGroupStream,
        builder: (context, snapshot) => snapshot.hasData ?
          Text(snapshot.data.name) :
          Text(' ')
      )
    ),
    drawer: HomeDrawer(),
    body: StreamBuilder<List<GroupPerson>>(
      stream: bloc.groupPersonsStream,
      builder: (context, snapshot) {
        final persons = snapshot.data ?? <GroupPerson>[];
        return ListView.builder(
            itemBuilder: (context, index) => TimesheetCard(persons[index]),
            itemCount: persons.length,
        );
      }
    ),
    bottomSheet: Material(
      elevation: 12,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: f.Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(L10n.of(context).fio),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onSubmitted: (_) => _createPersonOfGroup(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    color: Theme.of(context).accentColor,
                    onPressed: _createPersonOfGroup,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );

  void _createPersonOfGroup() {
    if (controller.text.isNotEmpty) {
      final fio = controller.text.split(' ');
      final family = fio[0];
      String name;
      if (fio.length > 1) name = fio[1];
      String middleName;
      if (fio.length > 2) name = fio[2];
      bloc.createPersonOfGroup(family: family, name: name, middleName: middleName);
      controller.clear();
    }
  }
}
