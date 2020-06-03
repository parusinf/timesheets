import 'package:flutter/material.dart' hide Column;
import 'package:flutter/widgets.dart' as f show Column;
import 'package:provider/provider.dart';
import 'package:timesheets/bloc.dart';
import 'package:timesheets/database/database.dart';
import 'package:timesheets/widgets/groups_drawer.dart';
import 'package:timesheets/widgets/timesheet_card.dart';
import 'package:timesheets/l10n.dart';

class TimesheetPage extends StatefulWidget {
  @override
  TimesheetPageState createState() {
    return TimesheetPageState();
  }
}

/// Shows a list of timesheets and displays a text input to add another one
class TimesheetPageState extends State<TimesheetPage> {
  // we only use this to reset the input field at the bottom when a entry has
  // been added
  final TextEditingController controller = TextEditingController();

  Bloc get bloc => Provider.of<Bloc>(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(L10n.of(context).title),
      ),
      drawer: GroupsDrawer(),
      body: StreamBuilder<List<PersonOfGroup>>(
        stream: bloc.personsInActiveGroup,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }

          final activePersons = snapshot.data;

          return ListView.builder(
            itemCount: activePersons.length,
            itemBuilder: (context, index) {
              return TimesheetCard(activePersons[index]);
            },
          );
        },
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
  }

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
