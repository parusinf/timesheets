import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/ui/home_page.dart';
import 'package:timesheets/core.dart';

// Упрощение проверки для самоподписанного сертификата
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (_certificateCheck);
  }
}

bool _certificateCheck(X509Certificate cert, String host, int port) =>
  host == 'api.parusinf.ru';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  Intl.defaultLocale = 'ru_RU';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<Bloc>(
      create: (_) => Bloc(),
      dispose: (_, bloc) => bloc.close(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (BuildContext context) => L10n.timesheets,
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: [
          const Locale('ru'),
        ],
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          typography: Typography.material2018(),
        ),
        home: HomePage(),
      ),
    );
  }
}
