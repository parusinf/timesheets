import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/persons_dictionary.dart';

/// Форма редактирования организации
class GroupPersonsDictionary extends StatefulWidget {
  final GroupView groupView;
  const GroupPersonsDictionary({Key key, this.groupView}) : super(key: key);
  @override
  _GroupPersonsDictionaryState createState() => _GroupPersonsDictionaryState();
}

/// Словарь персон в группе
class _GroupPersonsDictionaryState extends State<GroupPersonsDictionary> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: StreamBuilder<Group>(
        stream: bloc.activeGroup,
        builder: (context, snapshot) => snapshot.hasData
            ? Text('${l10n.persons}: ${snapshot.data.name}')
            : Text('')
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: _addPersonToGroup,
        ),
      ],
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(padding),
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
                  return centerMessage(context, l10n.addPersonToGroup);
                }
              } else {
                return centerMessage(context, l10n.dataLoading);
              }
            }
        ),
      ),
    ),
  );

  /// Добавление персоны в группу
  Future _addPersonToGroup() async {
    try {
      final person = await push(context, PersonsDictionary());
      if (person != null) {
        await bloc.addPersonToGroup(bloc.activeGroup.value, person);
      }
    } catch(e) {
      showMessage(_scaffoldKey, e.toString());
    }
  }
}

/// Карточка персоны в группе
class _GroupPersonCard extends StatelessWidget {
  final List<GroupPersonView> groupPersons;
  final int index;
  final GroupPersonView entry;
  _GroupPersonCard(this.groupPersons, this.index) : entry = groupPersons[index];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, dividerHeight),
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
        Provider.of<Bloc>(context, listen: false).deletePersonFromGroup(entry);
      },
      child: Material(
        color: Colors.lightGreen.withOpacity(passiveColorOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        child: ListTile(
          title: Text(entry.family),
          subtitle: Text(entry.name),
          trailing: text('${entry.attendanceCount}', color: Colors.black26),
        ),
      ),
    ),
  );
}