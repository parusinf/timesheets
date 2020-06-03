import 'package:flutter/material.dart';
import 'package:timesheets/l10n.dart';
import 'package:timesheets/bloc.dart';
import 'package:provider/provider.dart';
//import 'package:timesheets/widgets/add_group_dialog.dart';

class GroupsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              L10n.of(context).groups,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1
                  .copyWith(color: Colors.white),
            ),
            decoration: BoxDecoration(color: Colors.lightBlue),
          ),
          Flexible(
            child: StreamBuilder<List<GroupWithActiveInfo>>(
              stream: Provider.of<Bloc>(context).groups,
              builder: (context, snapshot) {
                final categories = snapshot.data ?? <GroupWithActiveInfo>[];

                return ListView.builder(
                  itemBuilder: (context, index) {
                    return _GroupDrawerEntry(entry: categories[index]);
                  },
                  itemCount: categories.length,
                );
              },
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  child: Icon(Icons.add),
                  tooltip: L10n.of(context).addGroup,
                  onPressed: () {
                    /*showDialog(
                        context: context, builder: (_) => AddGroupDialog());*/
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GroupDrawerEntry extends StatelessWidget {
  final GroupWithActiveInfo entry;
  const _GroupDrawerEntry({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = entry.groupWithScheduleAndCount;
    final title = group.name;
    final bloc = Provider.of<Bloc>(context);

    final rowContent = [
      Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: entry.isActive ? Theme.of(context).accentColor : Colors.black,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8),
        child: Text(_personsAmountString(context, group.personsAmount)),
      ),
    ];

    // also show a delete button if the group can be deleted
    if (group != null) {
      rowContent.addAll([
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Colors.red,
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(L10n.of(context).deleting),
                  content: Text('${L10n.of(context).deleteGroup} $title?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(L10n.of(context).cancel),
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    FlatButton(
                      child: Text(L10n.of(context).ok),
                      textColor: Colors.red,
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                    ),
                  ],
                );
              },
            );

            if (confirmed == true) {
              bloc.db.deleteGroup(group: group);
            }
          },
        ),
      ]);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: entry.isActive
            ? Colors.lightBlue.withOpacity(0.3)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            bloc.showGroup(group);
            Navigator.pop(context); // close the navigation drawer
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: rowContent,
            ),
          ),
        ),
      ),
    );
  }

  /// Формирование строки с количеством человек
  String _personsAmountString(BuildContext context, int amount) {
    if ([2, 3, 4].contains(amount))
      return '$amount ${L10n.of(context).personsAmount234}';
    else
      return '$amount ${L10n.of(context).personsAmount}';
  }
}
