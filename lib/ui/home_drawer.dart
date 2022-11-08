import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/org_edit.dart';
import 'package:timesheets/ui/group_edit.dart';
import 'package:timesheets/ui/group_persons_dictionary.dart';
import 'package:timesheets/ui/help_page.dart';
import 'package:timesheets/ui/pay_page.dart';
import 'package:timesheets/ui/org_report.dart';
import 'package:timesheets/ui/holidays_dictionary.dart';
import 'package:timesheets/ui/settings_edit.dart';

/// Дроувер домашнего экрана
class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key}) : super(key: key);
  @override
  HomeDrawerState createState() => HomeDrawerState();
}

/// Состояние дроувера домашнего экрана
class HomeDrawerState extends State<HomeDrawer> {
  get bloc => Provider.of<Bloc>(context, listen: false);

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
                  listHeater(Icons.business, L10n.orgs,
                      onAddPressed: () => addOrg(context)),
                  Flexible(
                    child: StreamBuilder<List<ActiveOrg>>(
                      stream: bloc.activeOrgs,
                      builder: (context, snapshot) {
                        final orgs = snapshot.data ?? <ActiveOrg>[];
                        return ListView.builder(
                          itemBuilder: (context, index) =>
                              OrgCard(orgs, index),
                          itemCount: orgs.length,
                        );
                      },
                    ),
                  ),
                  // Список групп активной организации
                  StreamBuilder<OrgView?>(
                      stream: bloc.activeOrg,
                      builder: (context, snapshot) => snapshot.hasData
                          ? listHeater(Icons.group, L10n.groups,
                              onAddPressed: () async {
                                final groupView = await addGroup(context);
                                if (!mounted) return;
                                // Добавление персон в группу
                                if (groupView != null) {
                                  await push(context, const GroupPersonsDictionary());
                                }
                                if (!mounted) return;
                                Navigator.pop(context);
                              })
                          : const Spacer()),
                  StreamBuilder<List<ActiveOrg>>(
                      stream: bloc.activeOrgs,
                      builder: (context, snapshot) => snapshot.hasData
                          ? _groupList(orientation, snapshot.data!.length)
                          : const Text('')),
                  const Spacer(),
                  listHeater(Icons.settings, L10n.settings,
                      onHeaderTap: () async {
                        await push(context, const SettingsEdit());
                        if (!mounted) return;
                        Navigator.pop(context);
                      }
                  ),
                  listHeater(Icons.auto_awesome, L10n.holidays,
                      onHeaderTap: () async {
                        await push(context, const HolidaysDictionary());
                        if (!mounted) return;
                        Navigator.pop(context);
                      }
                  ),
                  listHeater(Icons.help, L10n.help,
                      onHeaderTap: () async {
                        await push(context, const HelpPage());
                        if (!mounted) return;
                        Navigator.pop(context);
                      }
                  ),
                  listHeater(Icons.account_balance_wallet, L10n.support,
                      onHeaderTap: () async {
                        await push(context, const PayPage());
                        if (!mounted) return;
                        Navigator.pop(context);
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  /// Список групп
  Widget _groupList(Orientation orientation, int orgsCount) => Flexible(
        flex: orientation == Orientation.portrait
            ? orgsCount < 2
                ? 5
                : 2
            : 1,
        child: StreamBuilder<List<ActiveGroup>>(
          stream: bloc.activeGroups,
          builder: (context, snapshot) => ListView.builder(
            itemBuilder: (context, index) => GroupCard(snapshot.data!, index),
            itemCount: snapshot.data?.length ?? 0,
          ),
        ),
      );
}

/// Карточка организации
class OrgCard extends StatefulWidget {
  final List<ActiveOrg> orgs;
  final int index;
  final ActiveOrg entry;

  OrgCard(this.orgs, this.index, {Key? key})
      : entry = orgs[index],
        super(key: key);

  @override
  OrgCardState createState() => OrgCardState();
}

class OrgCardState extends State<OrgCard> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, padding2),
        child: Dismissible(
          confirmDismiss: (direction) async => widget.entry.orgView.groupCount == 0,
          background: Material(
            color: Colors.red,
            borderRadius: BorderRadius.circular(borderRadius),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          key: UniqueKey(),
          onDismissed: (direction) {
            widget.orgs.removeAt(widget.index);
            Provider.of<Bloc>(context, listen: false).deleteOrg(widget.entry.orgView);
          },
          child: Material(
            color: widget.entry.isActive
                ? Colors.lightBlue.withOpacity(activeColorOpacity)
                : Colors.lightBlue.withOpacity(passiveColorOpacity),
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: () {
                Provider.of<Bloc>(context, listen: false)
                    .setActiveOrg(widget.entry.orgView);
              },
              onDoubleTap: () async {
                await editOrg(context, widget.entry.orgView);
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text(widget.entry.orgView.name),
                subtitle: Text(
                    '${isNotEmpty(widget.entry.orgView.inn) ?
                    widget.entry.orgView.inn :
                    L10n.withoutInn}'
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.article),
                  onPressed: () async {
                    await push(context, const OrgReport());
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ),
      );
}

/// Карточка группы
class GroupCard extends StatefulWidget {
  final List<ActiveGroup> groups;
  final int index;
  final ActiveGroup entry;
  GroupCard(this.groups, this.index, {Key? key}) : entry = groups[index], super(key: key);
  @override
  GroupCardState createState() => GroupCardState();
}

class GroupCardState extends State<GroupCard> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, padding2),
        child: Dismissible(
          confirmDismiss: (direction) async => widget.entry.groupView.personCount == 0,
          background: Material(
            color: Colors.red,
            borderRadius: BorderRadius.circular(borderRadius),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          key: UniqueKey(),
          onDismissed: (direction) {
            widget.groups.removeAt(widget.index);
            Provider.of<Bloc>(context, listen: false)
                .deleteGroup(widget.entry.groupView);
          },
          child: Material(
            color: widget.entry.isActive
                ? Colors.lightGreen.withOpacity(activeColorOpacity)
                : Colors.lightGreen.withOpacity(passiveColorOpacity),
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: () {
                Provider.of<Bloc>(context, listen: false)
                    .setActiveGroup(widget.entry.groupView);
                Navigator.pop(context);
              },
              onDoubleTap: () async {
                await editGroup(context, widget.entry.groupView);
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text(widget.entry.groupView.name),
                subtitle: Text(widget.entry.groupView.schedule!.code),
                trailing: IconButton(
                  icon: const Icon(Icons.group_add),
                  onPressed: () async {
                    await push(context, const GroupPersonsDictionary());
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
        ),
      );
}
