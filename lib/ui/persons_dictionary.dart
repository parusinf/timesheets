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
          onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => PersonEdit())),
        ),
      ],
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<List<PersonView>>(
          stream: Provider.of<Bloc>(context).db.personsDao.watch(),
          builder: (context, snapshot) => ListView.builder(
            itemBuilder: (context, index) => _PersonCard(snapshot.data, index),
            itemCount: snapshot.data == null ? 0 : snapshot.data.length,
          ),
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
  Widget build(BuildContext context) => Dismissible(
    confirmDismiss: (direction) async => entry.groupCount == 0,
    background: Material(
      color: Colors.red,
      borderRadius: BorderRadius.circular(16),
      child: const Icon(Icons.delete, color: Colors.white),
    ),
    key: UniqueKey(),
    onDismissed: (direction) {
      persons.removeAt(index);
      Provider.of<Bloc>(context, listen: false).deletePerson(entry);
    },
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Navigator.pop(context, entry),
        onDoubleTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => PersonEdit(person: entry))),
        child: ListTile(
          title: Text(entry.family),
          subtitle: Text('${entry.name} ${entry.middleName ?? ''}'),
          trailing: text(context, '${entry.groupCount}', color: Colors.black26),
        ),
      ),
    ),
  );
}