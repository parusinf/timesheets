import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/group_edit.dart';
import 'package:timesheets/ui/group_person_edit.dart';

/// Словарь персон в группе
class GroupPersonsDictionary extends StatefulWidget {
  const GroupPersonsDictionary({Key key}): super(key: key);
  @override
  GroupPersonsDictionaryState createState() => GroupPersonsDictionaryState();
}

class GroupPersonsDictionaryState extends State<GroupPersonsDictionary> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: StreamBuilder<Group>(
        stream: bloc.activeGroup,
        builder: (context, snapshot) => snapshot.hasData
          ? InkWell(
            onTap: () => editGroup(context, bloc.activeGroup.value),
            child: text(snapshot.data.name),
          )
          : text('')
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () => addGroupPerson(context),
        ),
      ],
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(padding1),
        child: StreamBuilder<List<GroupPersonView>>(
            stream: bloc.groupPersons,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  return ListView.builder(
                    itemBuilder: (context, index) => _GroupPersonCard(snapshot.data, index),
                    itemCount: snapshot.data.length,
                  );
                } else {
                  return centerButton(L10n.of(context).addPersonToGroup, onPressed: () => addGroupPerson(context));
                }
              } else {
                return centerMessage(context, L10n.of(context).dataLoading);
              }
            }
        ),
      ),
    ),
  );
}

/// Карточка персоны в группе
class _GroupPersonCard extends StatelessWidget {
  final List<GroupPersonView> groupPersons;
  final int index;
  final GroupPersonView entry;
  _GroupPersonCard(this.groupPersons, this.index) : entry = groupPersons[index];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, padding2),
    child: Dismissible(
      confirmDismiss: (direction) async => entry.attendanceCount == 0,
      background: Material(
        color: Colors.red,
        borderRadius: BorderRadius.circular(borderRadius),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        groupPersons.removeAt(index);
        Provider.of<Bloc>(context, listen: false).deleteGroupPerson(entry);
      },
      child: Material(
        color: Colors.lightGreen.withOpacity(passiveColorOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: () => editGroupPerson(context, entry),
          onDoubleTap: () => editGroupPerson(context, entry),
          child: ListTile(
            title: Text(personFullName(entry.person)),
            subtitle: Text(datesToString(context, entry.beginDate, entry.endDate)),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => editGroupPerson(context, entry),
            ),
          ),
        ),
      ),
    ),
  );
}