import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/person_edit.dart';

/// Словарь персон
class PersonsDictionary extends StatefulWidget {
  const PersonsDictionary({Key key}): super(key: key);
  @override
  _PersonsDictionaryState createState() => _PersonsDictionaryState();
}

class _PersonsDictionaryState extends State<PersonsDictionary> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);
  final searchQueryEdit = TextEditingController();
  bool isSearching = false;
  String searchQuery = '';

  void _startSearch() {
    ModalRoute.of(context)
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();
    setState(() {
      isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      searchQueryEdit.clear();
      updateSearchQuery('');
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment = Platform.isIOS
        ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: horizontalTitleAlignment,
        children: <Widget>[
          Text(l10n.persons),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchQueryEdit,
      autofocus: true,
      decoration: InputDecoration(
        hintText: l10n.person,
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white54),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
  }

  List<Widget> _buildActions() {
    return <Widget>[
      if (isSearching)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (searchQueryEdit == null || searchQueryEdit.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      if (!isSearching)
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _startSearch,
        ),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () => addPerson(context),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: isSearching ? const BackButton() : null,
      title: isSearching ? _buildSearchField() : _buildTitle(context),
      actions: _buildActions(),
    ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(padding1),
        child: StreamBuilder<List<PersonView>>(
          stream: Provider.of<Bloc>(context).db.personsDao.watch(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final list = snapshot.data.where((person) => personFullName(person)
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
                .toList();
              if (list.length > 0) {
                return ListView.builder(
                  itemBuilder: (context, index) => _PersonCard(list, index, isSearching),
                  itemCount: list.length,
                );
              } else {
                return centerButton(l10n.addPerson, onPressed: () => addPerson(context));
              }
            } else {
              return centerMessage(context, l10n.dataLoading);
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
  final isSearching;

  _PersonCard(this.persons, this.index, this.isSearching) : entry = persons[index];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, padding2),
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
          onTap: () {
            if (isSearching) {
              Navigator.pop(context);
            }
            Navigator.pop(context, entry);
          },
          onDoubleTap: () => editPerson(context, entry),
          child: ListTile(
            title: Text(entry.family),
            subtitle: Text(personName(entry)),
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