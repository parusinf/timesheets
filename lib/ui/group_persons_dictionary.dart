import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/group_edit.dart';
import 'package:timesheets/ui/group_person_edit.dart';

/// Словарь персон в группе
class GroupPersonsDictionary extends StatefulWidget {
  const GroupPersonsDictionary({Key key}) : super(key: key);
  @override
  _GroupPersonsDictionaryState createState() => _GroupPersonsDictionaryState();
}

class _GroupPersonsDictionaryState extends State<GroupPersonsDictionary> {
  get bloc => Provider.of<Bloc>(context, listen: false);
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
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: horizontalTitleAlignment,
        children: <Widget>[
          StreamBuilder<Group>(
              stream: bloc.activeGroup,
              builder: (context, snapshot) => snapshot.hasData
                  ? InkWell(
                      onTap: () => editGroup(context, bloc.activeGroup.valueWrapper?.value),
                      child: text(snapshot.data.name),
                    )
                  : text('')),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchQueryEdit,
      autofocus: true,
      decoration: InputDecoration(
        hintText: L10n.person,
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
        icon: const Icon(Icons.person_add),
        onPressed: () => addGroupPerson(context),
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
            child: StreamBuilder<List<GroupPersonView>>(
                stream: bloc.groupPersons,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final list = snapshot.data
                        .where((groupPerson) =>
                            personFullName(groupPerson.person)
                                .toLowerCase()
                                .contains(searchQuery.toLowerCase()))
                        .toList();
                    if (list.length > 0) {
                      return ListView.builder(
                        itemBuilder: (context, index) =>
                            _GroupPersonCard(list, index),
                        itemCount: list.length,
                      );
                    } else {
                      return centerButton(L10n.addPersonToGroup,
                          onPressed: () => addGroupPerson(context));
                    }
                  } else {
                    return centerMessage(context, L10n.dataLoading);
                  }
                }),
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
                subtitle: Text(
                    datesToString(context, entry.beginDate, entry.endDate)),
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
