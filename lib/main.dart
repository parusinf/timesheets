import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:uni_links/uni_links.dart';
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

enum UniLinksType { string, uri }

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  get l10n => L10n.of(context);
  Uri _latestUri;
  StreamSubscription _sub;
  UniLinksType _type = UniLinksType.string;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  @override
  dispose() {
    if (_sub != null) _sub.cancel();
    super.dispose();
  }

  initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  initPlatformStateForStringUniLinks() async {
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        try {
          if (link != null) _latestUri = Uri.parse(link);
        } on FormatException {}
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
      });
    });
    String initialLink;
    Uri initialUri;
    try {
      initialLink = await getInitialLink();
      if (initialLink != null) initialUri = Uri.parse(initialLink);
    } on PlatformException {
      initialLink = l10n.failedToGetInitialLink;
      initialUri = null;
    } on FormatException {
      initialLink = l10n.failedToParseInitialLink;
      initialUri = null;
    }
    if (!mounted) return;
    setState(() {
      _latestUri = initialUri;
    });
  }

  initPlatformStateForUriUniLinks() async {
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
      });
    });
    Uri initialUri;
    try {
      initialUri = await getInitialUri();
    } on PlatformException {
      initialUri = null;
    } on FormatException {
      initialUri = null;
    }
    if (!mounted) return;
    setState(() {
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
      home: HomePage(uriToString(_latestUri)),
    ),
  );
}