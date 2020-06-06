import 'package:flutter/material.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/ui/add_group_dialog.dart';

class GroupsDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
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
          child: StreamBuilder<List<GroupIsActive>>(
            stream: Provider.of<Bloc>(context).groupsStream,
            builder: (context, snapshot) {
              final groups = snapshot.data ?? <GroupIsActive>[];

              return ListView.builder(
                itemBuilder: (context, index) =>
                    _GroupDrawerEntry(entry: groups[index]),
                itemCount: groups.length,
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
                  showDialog(context: context, builder: (_) => AddGroupDialog());
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _GroupDrawerEntry extends StatelessWidget {
  final GroupIsActive entry;
  const _GroupDrawerEntry({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = entry.groupView;
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
        child: Text(_personsPersonCountString(context, group.personCount)),
      ),
    ];
    // Показывать кнопку удаления, если группа может быть удалена
    if (group != null && group.personCount == 0 &&
        bloc.groupsStream.value.length > 1) {
      rowContent.addAll([
        const Spacer(),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Colors.red,
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
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
              )
            );
            if (confirmed == true)
              bloc.db.groupsDao.del(group);
          },
        ),
      ]);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        color: entry.isActive ?
            Colors.lightBlue.withOpacity(0.3) :
            Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: () {
            bloc.showGroup(group);
            Navigator.pop(context); // закрыть дроувер
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
  String _personsPersonCountString(BuildContext context, int personCount) =>
      [2, 3, 4].contains(personCount) ?
      '$personCount ${L10n.of(context).personCount234}' :
      '$personCount ${L10n.of(context).personCount}';
}
