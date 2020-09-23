import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
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
  get l10n => L10n.of(context);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
      title: Text(l10n.help),
      actions: <Widget>[
        IconButton(icon: const Icon(Icons.ondemand_video), onPressed: _launchURL),
      ],
    ),
    body: Markdown(data: _fetchHelp()),
  );

  Future _launchURL() async {
    const url = 'https://youtu.be/-TV0l17MW18';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showMessage(_scaffoldKey, 'Видео не запускается');
    }
  }

  String _fetchHelp() {
    return '''
# Табели посещаемости

## О приложении

Регистрируйте посещаемость персон в группах организаций по графикам посещения:

1. Детей в группах детских садов.
2. Учеников в группах дополнительного образования.
3. Спортсменов в спортивных секциях.

## Использование

### Жесты

* Выбор: _тап_
* Редактирование: _двойной тап_
* Удаление: _свайп влево или вправо_

### Демо
[Видео-демонстрация](https://youtu.be/jGygPdV9smU)

## Релиз

2020.9.22

## Автор

Павел Никитин

[parusinf@gmail.com](mailto:parusinf@gmail.com)
''';
  }
}