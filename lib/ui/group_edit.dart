import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';
import 'package:timesheets/db/db.dart';
import 'package:timesheets/ui/schedules_dictionary.dart';
import 'package:timesheets/ui/group_person_edit.dart';

/// Форма редактирования группы
class GroupEdit extends StatefulWidget {
  final GroupView groupView;
  final DataActionType actionType;
  const GroupEdit({Key key, this.groupView})
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
  Schedule schedule;
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _nameEdit.text = widget.groupView?.name;
    schedule = widget.groupView?.schedule ?? bloc.activeSchedule.value;
    _scheduleEdit.text = schedule?.code;
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
      horizontalSpace(height: dividerHeight),
      // Наименование группы
      TextFormField(
        controller: _nameEdit,
        autofocus: widget.actionType == DataActionType.Insert ? true : false,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          icon: const Icon(Icons.group),
          labelText: l10n.groupName,
        ),
        validator: _validateName,
      ),
      horizontalSpace(),
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
    ];
    if (widget.actionType == DataActionType.Update) {
      items.addAll(<Widget>[
        horizontalSpace(),
        listHeater(context, Icons.person, l10n.groupPersons.toUpperCase(),
            _addGroupPerson),
        Flexible(
          child: StreamBuilder<List<GroupPersonView>>(
            stream: bloc.groupPersons,
            builder: (context, snapshot) =>
                ListView.builder(
                  itemBuilder: (context, index) =>
                      _GroupPersonCard(snapshot.data, index),
                  itemCount: snapshot.data?.length ?? 0,
                ),
          ),
        ),
      ]);
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.actionType == DataActionType.Insert
            ? l10n.groupInserting
            : l10n.groupUpdating
        ),
        actions: <Widget>[
          IconButton(icon: const Icon(Icons.done), onPressed: _handleSubmitted),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: padding),
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
    schedule = await push(context, SchedulesDictionary()) ?? bloc.activeSchedule?.value;
    _scheduleEdit.text = schedule?.code ?? '';
  }

  /// Обработка формы
  Future _handleSubmitted() async {
    final form = _formKey.currentState;
    if (!form.validate()) {
      _autoValidate = true;
    } else {
      try {
        switch (widget.actionType) {
          case DataActionType.Insert:
            final groupView = await bloc.insertGroup(
                name: trim(_nameEdit.text),
                schedule: schedule,
            );
            Navigator.of(context).pop(groupView);
            break;
          case DataActionType.Update:
            await bloc.updateGroup(Group(
                id: widget.groupView.id,
                orgId: widget.groupView.orgId,
                name: trim(_nameEdit.text),
                scheduleId: schedule.id
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

  /// Добавление персоны в группу
  Future _addGroupPerson() async {
    try {
      await push(context, GroupPersonEdit());
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
        Provider.of<Bloc>(context, listen: false).deleteGroupPerson(entry);
      },
      child: Material(
        color: Colors.lightGreen.withOpacity(passiveColorOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: () => push(context, GroupPersonEdit(groupPerson: entry)),
          onDoubleTap: () => push(context, GroupPersonEdit(groupPerson: entry)),
          child: ListTile(
            title: Text(fio(entry.person)),
            subtitle: Text(datesToString(L10n.of(context), entry.beginDate, entry.endDate)),
            trailing: text('${entry.attendanceCount}', color: Colors.black26),
          ),
        ),
      ),
    ),
  );
}