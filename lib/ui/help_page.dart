import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
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
    body: FutureBuilder(
      future: http.get('https://raw.githubusercontent.com/parusinf/timesheets/master/README.md?token=ACOJLSZNAWIIOMQRL5XYP3K7MSOXA'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          http.Response response = snapshot.data;
          return Markdown(data: response.body);
        }
        else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),
  );

  Future _launchURL() async {
    const url = 'https://youtu.be/jGygPdV9smU';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showMessage(_scaffoldKey, 'Видео не запускается');
    }
  }
}