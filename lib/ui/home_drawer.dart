import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/core/tools.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/group_page.dart';
import 'package:timesheets/ui/org_page.dart';

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
            _listTitle(context, L10n.of(context).organizations, OrgPage()),
            Flexible(
              child: StreamBuilder<List<ActiveOrg>>(
                stream: Provider.of<Bloc>(context).activeOrgsSubject,
                builder: (context, snapshot) {
                  final orgs = snapshot.data ?? <ActiveOrg>[];
                  return ListView.builder(
                    itemBuilder: (context, index) =>
                        _OrgDrawerEntry(orgs, index),
                    itemCount: orgs.length,
                  );
                },
              ),
            ),
            // Список групп активной организации
            StreamBuilder<Org>(
                stream: Provider.of<Bloc>(context).activeOrgSubject,
                builder: (context, snapshot) => snapshot.hasData ?
                    _listTitle(context, L10n.of(context).groups, GroupPage())
                    : Spacer()
            ),
            Flexible(
              flex: 3,
              child: StreamBuilder<List<ActiveGroup>>(
                stream: Provider.of<Bloc>(context).activeGroupsSubject,
                builder: (context, snapshot) {
                  final groups = snapshot.data ?? <ActiveGroup>[];
                  return ListView.builder(
                    itemBuilder: (context, index) =>
                        _GroupDrawerEntry(groups, index),
                    itemCount: groups.length,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );

  /// Заголовок списка с кнопкой добавления
 _listTitle(BuildContext context, String title, Widget entryPage) =>
   Row(
     children: <Widget>[
       greyText(context, title),
       const Spacer(),
       IconButton(
         icon: const Icon(Icons.add),
         color: Colors.black38,
         onPressed: () {
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => entryPage),
           );
         },
       ),
     ]
   );
}

class _OrgDrawerEntry extends StatelessWidget {
  final List<ActiveOrg> orgs;
  final int index;
  final ActiveOrg entry;
  _OrgDrawerEntry(this.orgs, this.index) : entry = orgs[index];

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
          Provider.of<Bloc>(context, listen: false).showOrg(entry.orgView);
        },
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrgPage(entry: entry.orgView)),
          );
        },
        child: ListTile(
          title: Text(entry.orgView.name),
          subtitle: Text(entry.orgView.inn != null
              ? entry.orgView.inn
              : L10n.of(context).withoutInn
          ),
          trailing: Text('${entry.orgView.groupCount}',
            style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: entry.isActive ? Colors.black54 : Colors.black26),
          ),
        ),
      ),
    ),
  );
}

class _GroupDrawerEntry extends StatelessWidget {
  final List<ActiveGroup> groups;
  final int index;
  final ActiveGroup entry;
  _GroupDrawerEntry(this.groups, this.index) : entry = groups[index];

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
          Provider.of<Bloc>(context, listen: false).showGroup(entry.groupView);
          Navigator.pop(context);
        },
        onDoubleTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GroupPage(entry: entry.groupView)),
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