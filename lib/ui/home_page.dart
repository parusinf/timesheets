import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/home_drawer.dart';
import 'package:timesheets/ui/persons_dictionary.dart';

/// Табели
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

/// Состояние табелей
class HomePageState extends State<HomePage> {
  Bloc get bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: StreamBuilder<Group>(
        stream: bloc.activeGroup,
        builder: (context, snapshot) =>
            snapshot.hasData ? Text(snapshot.data.name) : Text('')
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.person_add),
          tooltip: L10n.of(context).addPersonToGroup,
          onPressed: () {
            _addPersonToGroup();
          },
        ),
      ],
    ),
    drawer: HomeDrawer(),
    body: StreamBuilder<List<GroupPerson>>(
      stream: bloc.groupPersonList,
      builder: (context, snapshot) {
        // Организаций нет
        if (bloc.activeOrg.value == null) {
          return centerMessage(context, L10n.of(context).noOrgs);
        } else {
          // Групп нет
          if (bloc.activeGroup.value == null) {
            return centerMessage(context, L10n.of(context).noGroups);
          } else {
            // Данные загрузились
            if (snapshot.hasData) {
              // Персон нет
              if (snapshot.data.length == 0) {
                return centerMessage(context, L10n.of(context).noPersons);
              } else {
                return ListView.builder(
                  itemBuilder: (context, index) => _GroupPersonCard(snapshot.data, index),
                  itemCount: snapshot.data.length,
                );
              }
            // Данные загружаются
            } else {
              return centerMessage(context, L10n.of(context).dataLoading);
            }
          }
        }
      }
    ),
  );

  /// Добавление персоны в группу
  Future _addPersonToGroup() async {
    try {
      final person = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => PersonsDictionary()));
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
  final List<GroupPerson> groupPerson;
  final int index;
  final GroupPerson entry;

  _GroupPersonCard(this.groupPerson, this.index) : entry = groupPerson[index];

  @override
  Widget build(BuildContext context) => Dismissible(
    confirmDismiss: (direction) async => true,
    background: Material(
      color: Colors.red,
      borderRadius: BorderRadius.circular(16),
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    key: UniqueKey(),
    onDismissed: (direction) {
      groupPerson.removeAt(index);
      Provider.of<Bloc>(context, listen: false).deletePersonFromGroup(entry);
    },
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Navigator.pop(context, entry),
        child: ListTile(
          title: Text(entry.family),
          subtitle: Text('${entry.name} ${entry.middleName}'),
        ),
      ),
    ),
  );
}