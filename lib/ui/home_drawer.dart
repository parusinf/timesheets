import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/group_edit.dart';
import 'package:timesheets/ui/org_edit.dart';

/// Дроувер домашнего экрана
class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Drawer(
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Список организаций
            _listTitle(context, Icons.business, L10n.of(context).orgs,
                L10n.of(context).orgInserting, OrgEdit()),
            Flexible(
              child: StreamBuilder<List<ActiveOrg>>(
                stream: Provider.of<Bloc>(context).activeOrgs,
                builder: (context, snapshot) {
                  final orgs = snapshot.data ?? <ActiveOrg>[];
                  return ListView.builder(
                    itemBuilder: (context, index) =>
                        _OrgCard(orgs, index),
                    itemCount: orgs.length,
                  );
                },
              ),
            ),
            // Список групп активной организации
            StreamBuilder<Org>(
              stream: Provider.of<Bloc>(context).activeOrg,
              builder: (context, snapshot) => snapshot.hasData
                  ? _listTitle(context, Icons.group, L10n.of(context).groups,
                      L10n.of(context).groupInserting, GroupEdit())
                  : Spacer()
            ),
            Flexible(
              flex: 3,
              child: StreamBuilder<List<ActiveGroup>>(
                stream: Provider.of<Bloc>(context).activeGroups,
                builder: (context, snapshot) => ListView.builder(
                  itemBuilder: (context, index) => _GroupCard(snapshot.data, index),
                  itemCount: snapshot.data?.length ?? 0,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  /// Заголовок списка с кнопкой добавления
  Widget _listTitle(
    BuildContext context,
    IconData icon,
    String title,
    String actionName,
    Widget entryPage
  ) => Row(
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(icon, color: Colors.black54)
      ),
      text(title),
      const Spacer(),
      IconButton(
        icon: const Icon(Icons.add),
        color: Colors.black54,
        tooltip: actionName,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => entryPage),
        ),
      ),
    ],
  );
}

/// Карточка организации
class _OrgCard extends StatelessWidget {
  final List<ActiveOrg> orgs;
  final int index;
  final ActiveOrg entry;
  _OrgCard(this.orgs, this.index) : entry = orgs[index];

  @override
  Widget build(BuildContext context) => Dismissible(
    confirmDismiss: (direction) async => entry.orgView.groupCount == 0,
    background: Material(
      color: Colors.red,
      borderRadius: BorderRadius.circular(16),
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    key: UniqueKey(),
    onDismissed: (direction) {
      orgs.removeAt(index);
      Provider.of<Bloc>(context, listen: false).deleteOrg(entry.orgView);
    },
    child: Material(
      color: entry.isActive
          ? Colors.lightBlue.withOpacity(0.3) : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Provider.of<Bloc>(context, listen: false).setActiveOrg(entry.orgView);
        },
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrgEdit(org: entry.orgView)),
          );
        },
        child: ListTile(
          title: Text(entry.orgView.name),
          subtitle: Text(isNotEmpty(entry.orgView.inn)
              ? entry.orgView.inn
              : L10n.of(context).withoutInn
          ),
          trailing: text('${entry.orgView.groupCount}',
              color: entry.isActive ? Colors.black54 : Colors.black26),
        ),
      ),
    ),
  );
}

/// Карточка группы
class _GroupCard extends StatelessWidget {
  final List<ActiveGroup> groups;
  final int index;
  final ActiveGroup entry;
  _GroupCard(this.groups, this.index) : entry = groups[index];

  @override
  Widget build(BuildContext context) => Dismissible(
    confirmDismiss: (direction) async => entry.groupView.personCount == 0,
    background: Material(
      color: Colors.red,
      borderRadius: BorderRadius.circular(16),
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    key: UniqueKey(),
    onDismissed: (direction) {
      groups.removeAt(index);
      Provider.of<Bloc>(context, listen: false).deleteGroup(entry.groupView);
    },
    child: Material(
      color: entry.isActive
          ? Colors.lightGreen.withOpacity(0.3) : Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Provider.of<Bloc>(context, listen: false)
              .setActiveGroup(entry.groupView);
          Navigator.pop(context);
        },
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupEdit(groupView: entry.groupView),
            ),
          );
        },
        child: ListTile(
          title: Text(entry.groupView.name),
          subtitle: Text(entry.groupView.schedule.code),
          trailing: Text('${entry.groupView.personCount}',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
              color: entry.isActive ? Colors.black54 : Colors.black26),
          ),
        ),
      ),
    ),
  );
}