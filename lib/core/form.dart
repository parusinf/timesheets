import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:timesheets/core.dart';

/// Форма
Widget form({
  String title,
  Key scaffoldKey,
  Key formKey,
  AutovalidateMode autovalidateMode,
  VoidCallback onSubmit,
  List<Widget> fields,
  Widget child,
}) {
  var formChild;
  if (child != null) {
    formChild = Padding(
      padding: const EdgeInsets.fromLTRB(padding1, padding2, padding1, 0.0),
      child: child,
    );
  } else {
    final fieldsWithFirstDivider = <Widget>[];
    fieldsWithFirstDivider.add(divider(height: padding2));
    fieldsWithFirstDivider.addAll(fields);
    formChild = Scrollbar(
      child: SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.down,
        padding: const EdgeInsets.symmetric(horizontal: padding1),
        child: Column(children: fieldsWithFirstDivider),
      ),
    );
  }
  return Scaffold(
    appBar: AppBar(
      title: Text(title),
      actions: onSubmit == null
          ? null
          : <Widget>[
              IconButton(icon: const Icon(Icons.done), onPressed: onSubmit),
            ],
    ),
    key: scaffoldKey,
    body: Form(
      child: formChild,
      key: formKey,
      autovalidateMode: autovalidateMode,
    ),
  );
}

/// Поле формы с текстом
Widget textFormField({
  TextEditingController controller,
  String initialValue,
  String labelText,
  IconData icon = Icons.text_fields,
  ValueChanged<String> onChanged,
  VoidCallback onTap,
  FormFieldValidator<String> validator,
  TextCapitalization textCapitalization = TextCapitalization.none,
  int maxLength,
  bool autofocus = false,
  bool readOnly = false,
}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(
        0.0, 0.0, 0.0, (maxLength ?? 0) > 0 ? 0.0 : dividerHeight),
    child: TextFormField(
      controller: controller,
      initialValue: initialValue,
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
      ),
      onChanged: onChanged,
      onTap: onTap,
      validator: validator,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
      autofocus: autofocus,
      readOnly: readOnly,
    ),
  );
}

/// Поле формы с логическим значением
Widget boolFormField({
  bool initialValue,
  String labelText,
  IconData icon = Icons.done,
  ValueChanged<bool> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(0.0, padding2, 0.0, 32.0),
    child: Row(
      children: <Widget>[
        Padding(
            padding:
                const EdgeInsets.fromLTRB(0.0, padding2, padding1, padding2),
            child: Icon(icon, color: Colors.black54)),
        text(labelText, fontSize: 16.0),
        Spacer(),
        CupertinoSwitch(
          value: initialValue,
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

/// Поле формы с целым числом
Widget intFormField({
  TextEditingController controller,
  int initialValue,
  String labelText,
  IconData icon = Icons.looks_one_outlined,
  ValueChanged<String> onChanged,
  FormFieldValidator<String> validator,
  int maxLength,
  bool autofocus = false,
}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(
        0.0, 0.0, 0.0, (maxLength ?? 0) > 0 ? 0.0 : dividerHeight),
    child: TextFormField(
      controller: controller,
      initialValue: initialValue != null ? initialValue.toString() : null,
      keyboardType: TextInputType.numberWithOptions(),
      inputFormatters: IntFormatters.formatters,
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
      ),
      onChanged: onChanged,
      validator: validator,
      maxLength: maxLength,
      autofocus: autofocus,
    ),
  );
}

/// Поле формы с числом
Widget realFormField({
  TextEditingController controller,
  double initialValue,
  String labelText,
  IconData icon = Icons.looks_one,
  ValueChanged<String> onChanged,
  FormFieldValidator<String> validator,
  int maxLength,
  bool autofocus = false,
}) {
  return Padding(
    padding: EdgeInsets.fromLTRB(
        0.0, 0.0, 0.0, (maxLength ?? 0) > 0 ? 0.0 : dividerHeight),
    child: TextFormField(
      controller: controller,
      initialValue: initialValue != null ? doubleToString(initialValue) : null,
      keyboardType: TextInputType.numberWithOptions(),
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: labelText,
      ),
      onChanged: onChanged,
      validator: validator,
      maxLength: maxLength,
      autofocus: autofocus,
    ),
  );
}

/// Поле формы с датой
Widget dateFormField({
  TextEditingController controller,
  DateTime initialValue,
  String labelText,
  ValueChanged<String> onChanged,
  FormFieldValidator<String> validator,
  bool autofocus = false,
}) {
  return TextFormField(
    controller: controller,
    initialValue: initialValue != null ? dateToString(initialValue) : null,
    keyboardType: TextInputType.numberWithOptions(),
    inputFormatters: DateFormatters.formatters,
    decoration: InputDecoration(
      icon: const Icon(Icons.event),
      labelText: labelText,
    ),
    maxLength: 10,
    onChanged: onChanged,
    validator: (value) {
      if (value.isNotEmpty && stringToDate(value) == null) {
        return L10n.invalidDate;
      }
      if (validator != null) {
        return validator(value);
      }
      return null;
    },
    autofocus: autofocus,
  );
}

/// Поле формы с телефоном
Widget phoneFormField({
  TextEditingController controller,
  String initialValue,
  String labelText,
  ValueChanged<String> onChanged,
  Key scaffoldKey,
  String phone,
  bool autofocus = false,
}) {
  return TextFormField(
    controller: controller,
    initialValue: initialValue,
    keyboardType: TextInputType.numberWithOptions(),
    onChanged: onChanged,
    decoration: InputDecoration(
      icon: const Icon(Icons.phone),
      labelText: labelText,
      prefixText: L10n.countryPhoneCode,
      suffix: IconButton(
        icon: const Icon(Icons.phone_in_talk),
        onPressed: () async {
          phone = controller.text ?? initialValue;
          launchUrl(scaffoldKey, 'tel:${L10n.countryPhoneCode}$phone');
        },
        color: Colors.green,
      ),
    ),
    inputFormatters: PhoneFormatters.formatters,
    autofocus: autofocus,
  );
}

/// Поле формы с выбором вариантов
Widget chooseFormField({
  int initialValue,
  List<String> names,
  IconData icon = Icons.auto_awesome_motion,
  Function(bool, int) onChanged,
}) {
  final chips = <Widget>[];
  for (int index = 0; index < names.length; index++) {
    chips.add(
      ChoiceChip(
        label: Text(names[index]),
        selected: initialValue == index,
        onSelected: (value) => onChanged(value, index),
      ),
    );
    if (index < names.length - 1) {
      chips.add(const SizedBox(width: padding2));
    }
  }
  return Padding(
    padding: const EdgeInsets.fromLTRB(0.0, padding2, 0.0, dividerHeight),
    child: formElement(icon, Wrap(children: chips)),
  );
}

/// Проверка строки на отсутствие значения
String validateEmpty(String value) {
  if (isEmpty(value)) {
    return L10n.noValue;
  }
  return null;
}

/// Проверка даты
String validateDate(String value) {
  if (value.isNotEmpty && stringToDate(value) == null) {
    return L10n.invalidDate;
  }
  return null;
}

/// Элемент формы
Widget formElement(IconData icon, Widget widget) {
  return Row(children: <Widget>[
    Padding(
        padding: const EdgeInsets.fromLTRB(0.0, padding2, padding1, padding2),
        child: Icon(icon, color: Colors.black54)),
    widget,
  ]);
}

/// Заголовок списка с кнопкой добавления
Widget listHeater(IconData icon, String title,
    {VoidCallback onAddPressed, VoidCallback onHeaderTap}) {
  final items = (formElement(icon, text(title.toUpperCase())) as Row).children;
  if (onAddPressed != null) {
    items.addAll(<Widget>[
      const Spacer(),
      IconButton(
          icon: const Icon(Icons.add),
          color: Colors.black54,
          onPressed: onAddPressed),
    ]);
  }
  return onHeaderTap != null
      ? InkWell(onTap: onHeaderTap, child: Row(children: items))
      : Row(children: items);
}

/// Разделитель между полями формы
Widget divider({height = dividerHeight}) => SizedBox(height: height);
