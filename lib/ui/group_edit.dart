import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/schedules_dictionary.dart';
import 'package:timesheets/ui/group_person_edit.dart';

/// Добавление группы
Future addGroup(BuildContext context) async {
  // Добавление группы
  final groupView = await push(context, GroupEdit(null));
  // Исправление группы для добавляения в неё персон
  if (groupView != null) {
    await push(context, GroupEdit(groupView));
  }
}

/// Исправление группы
Future editGroup(BuildContext context, GroupView groupView) async =>
  await push(context, GroupEdit(groupView));

/// Форма редактирования группы
class GroupEdit extends StatefulWidget {
  final GroupView groupView;
  final DataActionType actionType;
  const GroupEdit(this.groupView, {Key key})
      : this.actionType = groupView == null ? DataActionType.Insert : DataActionType.Update,
        super(key: key);
  @override
  _GroupEditState createState() => _GroupEditState();
}

/// Состояние формы редактирования группы
class _GroupEditState extends State<GroupEdit> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  get l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _nameEdit = TextEditingController();
  final _scheduleEdit = TextEditingController();
  Schedule _schedule;
  int _meals;
  var _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _nameEdit.text = widget.groupView?.name;
    _schedule = widget.groupView?.schedule ?? bloc.activeSchedule.value;
    _scheduleEdit.text = _schedule?.code;
    _meals = widget.groupView?.meals ?? 0; // 0 - Без питания, 1 - До 2 лет, 2 - От 3 лет
  }

  @override
  void dispose() {
    _nameEdit.dispose();
    _scheduleEdit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      divider(height: padding2),
      // Наименование группы
      TextFormField(
        controller: _nameEdit,
        autofocus: widget.actionType == DataActionType.Insert ? true : false,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          icon: const Icon(Icons.group),
          labelText: l10n.name,
        ),
        validator: _validateName,
      ),
      divider(),
      // График
      TextFormField(
        controller: _scheduleEdit,
        readOnly: true,
        decoration: InputDecoration(
          icon: const Icon(Icons.calendar_today),
          labelText: l10n.schedule,
        ),
        validator: _validateSchedule,
        onTap: () => _selectSchedule(context),
      ),
      divider(),
      // Питание
      formElement(
        context,
        Icons.restaurant,
        Wrap(
          children: [
            ChoiceChip(
              label: Text(l10n.meals0),
              selected: _meals == 0,
              onSelected: (value) {
                setState(() {
                  _meals = value ? 0 : -1;
                });
              },
            ),
            const SizedBox(width: padding2),
            ChoiceChip(
              label: Text(l10n.meals1),
              selected: _meals == 1,
              onSelected: (value) {
                setState(() {
                  _meals = value ? 1 : -1;
                });
              },
            ),
            const SizedBox(width: padding2),
            ChoiceChip(
              label: Text(l10n.meals2),
              selected: _meals == 2,
              onSelected: (value) {
                setState(() {
                  _meals = value ? 2 : -1;
                });
              },
            ),
          ],
        ),
      ),
    ];
    if (widget.actionType == DataActionType.Update) {
      items.addAll(<Widget>[
        divider(),
        listHeater(context, Icons.person, l10n.groupPersons.toUpperCase(),
            onAddPressed: () => addGroupPerson(context)),
        Flexible(
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
      ]);
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(l10n.group),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.done), onPressed: _handleSubmitted),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items,
          ),
        ),
      ),
    );
  }

  /// Выбор графика из словаря
  Future _selectSchedule(BuildContext context) async {
    _schedule = await push(context, SchedulesDictionary()) ?? bloc.activeSchedule?.value;
    _scheduleEdit.text = _schedule?.code ?? '';
  }

  /// Обработка формы
  Future _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    } else {
      try {
        switch (widget.actionType) {
          case DataActionType.Insert:
            final groupView = await bloc.insertGroup(
              name: trim(_nameEdit.text),
              schedule: _schedule,
              meals: _meals,
            );
            Navigator.of(context).pop(groupView);
            break;
          case DataActionType.Update:
            await bloc.updateGroup(Group(
              id: widget.groupView.id,
              orgId: widget.groupView.orgId,
              name: trim(_nameEdit.text),
              scheduleId: _schedule?.id ?? widget.groupView.schedule,
              meals: _meals,
            ));
            Navigator.of(context).pop();
            break;
          case DataActionType.Delete: break;
        }
      } catch(e) {
        showMessage(_scaffoldKey, e.toString());
      }
    }
  }

  /// Проверка наименования
  String _validateName(String value) {
    if (isEmpty(value)) {
      return l10n.noName;
    }
    return null;
  }

  /// Проверка графика
  String _validateSchedule(String value) {
    if (isEmpty(value)) {
      return l10n.selectSchedule;
    }
    return null;
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