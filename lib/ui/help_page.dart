import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/core.dart';

/// Справка
class HelpPage extends StatefulWidget {
  @override
  HelpPageState createState() => HelpPageState();
}

/// Состояние справки
class HelpPageState extends State<HelpPage> {
  get bloc => Provider.of<Bloc>(context, listen: false);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(L10n.help),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.ondemand_video),
          onPressed: () => launchUrl(_scaffoldKey, 'https://youtu.be/vvLaug6BrWo'),
        ),
        IconButton(
          icon: const Icon(Icons.chat),
          onPressed: () => launchUrl(_scaffoldKey, 'https://chat.whatsapp.com/LU9rBpRadmE1Xw53TZ3VOl'),
        ),
      ],
    ),
    body: Markdown(data: _fetchHelp()),
  );

  String _fetchHelp() {
    return '''
# Табели посещаемости

## О приложении

Регистрируйте посещаемость персон в группах организаций по графикам посещения:

1. Детей в группах детских садов.
2. Учеников в группах дополнительного образования.
3. Спортсменов в спортивных секциях.

Обменивайтесь табелями между телефонами и учётной системой через Telegram или почту.

## Использование

### Жесты

* Выбор: _нажатие_
* Редактирование: _двойное нажатие_
* Удаление: _мах влево или вправо_

### Настройки

* Двойное нажатие в табеле: _Нет_

### Демо
[Видео-демонстрация](https://youtu.be/jGygPdV9smU)

## Выпуск

2021.7.2

## Автор

Павел Никитин

[pavel@parusinf.ru](mailto:pavel@parusinf.ru)
''';
  }
}