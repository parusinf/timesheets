import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/group_edit.dart';
import 'package:timesheets/ui/org_edit.dart';
import 'package:timesheets/ui/help_page.dart';

/// Дроувер домашнего экрана
class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key key}) : super(key: key);
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

/// Состояние дроувера домашнего экрана
class _HomeDrawerState extends State<HomeDrawer> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);

  @override
  Widget build(BuildContext context) => OrientationBuilder(
    builder: (context, orientation) => Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Список организаций
              listHeater(context, Icons.business, l10n.orgs, onAddPressed: () => push(context, OrgEdit())),
              Flexible(
                child: StreamBuilder<List<ActiveOrg>>(
                  stream: bloc.activeOrgs,
                  builder: (context, snapshot) {
                    final orgs = snapshot.data ?? <ActiveOrg>[];
                    return ListView.builder(
                      itemBuilder: (context, index) => _OrgCard(orgs, index),
                      itemCount: orgs.length,
                    );
                  },
                ),
              ),
              // Список групп активной организации
              StreamBuilder<Org>(
                  stream: bloc.activeOrg,
                  builder: (context, snapshot) => snapshot.hasData
                      ? listHeater(context, Icons.group, l10n.groups, onAddPressed: () => addGroup(context))
                      : Spacer()
              ),
              StreamBuilder<List<ActiveOrg>>(
                  stream: bloc.activeOrgs,
                  builder: (context, snapshot) => snapshot.hasData
                      ? _groupList(orientation, snapshot.data.length)
                      : Text('')
              ),
              Spacer(),
              listHeater(context, Icons.help, l10n.help, onHeaderTap: () => push(context, HelpPage())),
            ],
          ),
        ),
      ),
    ),
  );

  /// Список групп
  Widget _groupList(Orientation orientation, int orgsCount) => Flexible(
    flex: orientation == Orientation.portrait
        ? orgsCount < 2 ? 7 : 2
        : 2,
    child: StreamBuilder<List<ActiveGroup>>(
      stream: bloc.activeGroups,
      builder: (context, snapshot) =>
          ListView.builder(
            itemBuilder: (context, index) => _GroupCard(snapshot.data, index),
            itemCount: snapshot.data?.length ?? 0,
          ),
    ),
  );
}

/// Карточка организации
class _OrgCard extends StatelessWidget {
  final List<ActiveOrg> orgs;
  final int index;
  final ActiveOrg entry;
  _OrgCard(this.orgs, this.index) : entry = orgs[index];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, dividerHeight),
    child: Dismissible(
      confirmDismiss: (direction) async => entry.orgView.groupCount == 0,
      background: Material(
        color: Colors.red,
        borderRadius: BorderRadius.circular(borderRadius),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        orgs.removeAt(index);
        Provider.of<Bloc>(context, listen: false).deleteOrg(entry.orgView);
      },
      child: Material(
        color: entry.isActive
            ? Colors.lightBlue.withOpacity(activeColorOpacity)
            : Colors.lightBlue.withOpacity(passiveColorOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: () {
            Provider.of<Bloc>(context, listen: false).setActiveOrg(entry.orgView);
          },
          onDoubleTap: () => push(context, OrgEdit(org: entry.orgView)),
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
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, dividerHeight),
    child: Dismissible(
      confirmDismiss: (direction) async => entry.groupView.personCount == 0,
      background: Material(
        color: Colors.red,
        borderRadius: BorderRadius.circular(borderRadius),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        groups.removeAt(index);
        Provider.of<Bloc>(context, listen: false).deleteGroup(entry.groupView);
      },
      child: Material(
        color: entry.isActive
            ? Colors.lightGreen.withOpacity(activeColorOpacity)
            : Colors.lightGreen.withOpacity(passiveColorOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: () {
            Provider.of<Bloc>(context, listen: false)
                .setActiveGroup(entry.groupView);
            Navigator.pop(context);
          },
          onDoubleTap: () => _updateGroup(context, entry.groupView),
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
    ),
  );

  /// Исправление группы
  Future _updateGroup(BuildContext context, GroupView groupView) async {
    Provider.of<Bloc>(context, listen: false).setActiveGroup(groupView);
    push(context, GroupEdit(groupView: groupView));
  }
}