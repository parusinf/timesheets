import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core/l10n.dart';
import 'package:timesheets/core/bloc.dart';
import 'package:timesheets/core/tools.dart';
import 'package:timesheets/ui/add_group_page.dart';
import 'package:timesheets/ui/add_org_page.dart';

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
            _listTitle(context, L10n.of(context).organizations, AddOrgPage()),
            Flexible(
              child: StreamBuilder<List<ActiveOrg>>(
                stream: Provider.of<Bloc>(context).activeOrgsSubject,
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
            _listTitle(context, L10n.of(context).groups, AddGroupPage()),
            Flexible(
              flex: 3,
              child: StreamBuilder<List<ActiveGroup>>(
                stream: Provider.of<Bloc>(context).activeGroupsSubject,
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
          ],
        ),
      ),
    ),
  );

  /// Заголовок списка с кнопкой добавления
 _listTitle(BuildContext context, String title, Widget addPage) =>
   Row(
     children: <Widget>[
       greyText(context, title),
       const Spacer(),
       IconButton(
         icon: const Icon(Icons.add),
         color: Colors.black38,
         onPressed: () async {
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => addPage),
           );
         },
       ),
     ]
   );
}

class _OrgDrawerEntry extends StatelessWidget {
  final ActiveOrg entry;
  const _OrgDrawerEntry({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
    color: entry.isActive
        ? Colors.lightBlue.withOpacity(0.3) : Colors.transparent,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: () {
        Provider.of<Bloc>(context, listen: false).showOrg(entry.orgView);
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
  );
}

class _GroupDrawerEntry extends StatelessWidget {
  final ActiveGroup entry;
  const _GroupDrawerEntry({Key key, this.entry}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
    color: entry.isActive
        ? Colors.lightGreen.withOpacity(0.3) : Colors.transparent,
    borderRadius: BorderRadius.circular(16),
    child: InkWell(
      onTap: () {
        Provider.of<Bloc>(context, listen: false).showGroup(entry.groupView);
        Navigator.pop(context); // закрыть дроувер
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
  );
}