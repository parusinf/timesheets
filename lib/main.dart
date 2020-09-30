import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_handle_file/flutter_handle_file.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/ui/home_page.dart';
import 'package:timesheets/core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'ru_RU';
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  get l10n => L10n.of(context);
  String _latestFile;
  Uri _latestUri;
  StreamSubscription _subLink;
  StreamSubscription _subUri;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  @override
  dispose() {
    if (_subLink != null) _subLink.cancel();
    if (_subUri != null) _subUri.cancel();
    super.dispose();
  }

  /// Инициализация состояния платформы
  initPlatformState() async {
    // Присоединяем слушателя к потоку ссылок [String]
    _subLink = getFilesStream().listen(
      (String file) {
        if (!mounted) return;
        setState(() {
          _latestFile = file;
        });
      },
      onError: (err) {
        if (!mounted) return;
        showMessage(_scaffoldKey, '${l10n.failedToGetLatestLink}: $err');
      }
    );

    // Присоединяем слушателя к потоку ссылок [Uri]
    _subUri = getUriFilesStream().listen(
      (Uri uri) {
        if (!mounted) return;
        setState(() {
          _latestUri = uri;
        });
      },
      onError: (err) {
        if (!mounted) return;
        setState(() {
          _latestUri = null;
        });
      }
    );

    // Получаем последнюю ссылку
    String initialFile;
    try {
      initialFile = await getInitialFile();
    } on PlatformException {
      initialFile = null;
      showMessage(_scaffoldKey, l10n.failedToGetInitialLink);
    } on FormatException {
      initialFile = null;
      showMessage(_scaffoldKey, l10n.failedToParseInitialLink);
    }

    // Получаем последний Uri
    Uri initialUri;
    try {
      initialUri = await getInitialUri();
    } on PlatformException {
      initialUri = null;
      showMessage(_scaffoldKey, l10n.failedToGetInitialUri);
    } on FormatException {
      initialUri = null;
      showMessage(_scaffoldKey, l10n.failedToParseInitialUri);
    }

    if (!mounted) return;

    setState(() {
      _latestFile = initialFile;
      _latestUri = initialUri;
    });
  }

  @override
  Widget build(BuildContext context) => Provider<Bloc>(
    create: (_) => Bloc(),
    dispose: (_, bloc) => bloc.close(),
    child: MaterialApp(
      key: _scaffoldKey,
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => L10n.of(context).timesheets,
      localizationsDelegates: [
        const L10nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        typography: Typography.material2018(),
      ),
      home: HomePage(_latestFile ?? _latestUri?.path),
    ),
  );
}