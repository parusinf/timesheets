import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/ui/add_group_dialog.dart';

/*Column(
            children: <Widget>[
              // ОРГАНИЗАЦИИ    +
              Row(
                children: <Widget>[
                  Text(
                    L10n.of(context).organizations,
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.black38),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.black38,
                    onPressed: () async {
                      showDialog(context: context, builder: (_) => AddGroupDialog());
                    },
                  )
                ]
              ),*/


/// Дроувер домашнего экрана
class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // Список организаций в заголовке дроувера
        DrawerHeader(
          child: StreamBuilder<List<ActiveOrg>>(
            stream: Provider.of<Bloc>(context).activeOrgsStream,
            builder: (context, snapshot) {
              final orgs = snapshot.data ?? <ActiveOrg>[];
              return ListView.builder(
                itemBuilder: (context, index) =>
                    _OrgDrawerEntry(entry: orgs[index]),
                itemCount: orgs.length,
              );
            },
          ),
        ),
        // Список групп активной организации
        Flexible(
          child: StreamBuilder<List<ActiveGroup>>(
            stream: Provider.of<Bloc>(context).activeGroupsStream,
            builder: (context, snapshot) {
              final groups = snapshot.data ?? <ActiveGroup>[];
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

class _OrgDrawerEntry extends StatelessWidget {
  final ActiveOrg entry;
  const _OrgDrawerEntry({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
    color: entry.isActive
        ? Colors.lightGreen.withOpacity(0.3) : Colors.transparent,
    borderRadius: BorderRadius.circular(8),
    child: InkWell(
      onTap: () {
        Provider.of<Bloc>(context, listen: false).showOrg(entry.org);
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          entry.org.name,
          style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: entry.isActive ? Colors.black54 : Colors.black26),
        ),
      ),
    ),
  );
}

class _GroupDrawerEntry extends StatelessWidget {
  final ActiveGroup entry;
  const _GroupDrawerEntry({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = entry.groupView;
    final title = group.name;
    final bloc = Provider.of<Bloc>(context);
    final rowContent = <Widget>[
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
        bloc.activeGroupsStream.value.length > 1) {
      rowContent.addAll(<Widget>[
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
              bloc.db.groupsDao.remove(group);
          },
        ),
      ]);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: entry.isActive
            ? Colors.lightBlue.withOpacity(0.3) : Colors.transparent,
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
