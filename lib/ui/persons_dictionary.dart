import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/person_edit.dart';

/// Словарь персон
class PersonsDictionary extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(L10n.of(context).persons),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.add),
          tooltip: L10n.of(context).personInserting,
          onPressed: () => addPerson(context),
        ),
      ],
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(padding1),
        child: StreamBuilder<List<PersonView>>(
          stream: Provider.of<Bloc>(context).db.personsDao.watch(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                  itemBuilder: (context, index) => _PersonCard(snapshot.data, index),
                  itemCount: snapshot.data.length,
                );
              } else {
                return centerButton(L10n.of(context).addPerson, onPressed: () => addPerson(context));
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

/// Карточка персоны
class _PersonCard extends StatelessWidget {
  final List<PersonView> persons;
  final int index;
  final PersonView entry;

  _PersonCard(this.persons, this.index) : entry = persons[index];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, dividerHeight),
    child: Dismissible(
      confirmDismiss: (direction) async => entry.groupCount == 0,
      background: Material(
        color: Colors.red,
        borderRadius: BorderRadius.circular(borderRadius),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        persons.removeAt(index);
        Provider.of<Bloc>(context, listen: false).deletePerson(entry);
      },
      child: Material(
        color: Colors.lightGreen.withOpacity(passiveColorOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: () => Navigator.pop(context, entry),
          onDoubleTap: () => editPerson(context, entry),
          child: ListTile(
            title: Text(entry.family),
            subtitle: Text('${entry.name} ${entry.middleName ?? ''}'),
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => editPerson(context, entry),
            ),
          ),
        ),
      ),
    ),
  );
}