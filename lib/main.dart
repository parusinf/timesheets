import 'dart:io';
import 'dart:isolate';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart' as p;
import 'package:moor/moor.dart';
import 'package:moor/isolate.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:provider/provider.dart';
import 'package:timesheets/database/database.dart';
import 'package:timesheets/widgets/timesheets_page.dart';
import 'package:timesheets/l10n.dart';
import 'package:timesheets/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'ru_RU';

  // Инициализация базы данных в фоновом изоляте
  final isolate = await _createMoorIsolate();
  final connection = await isolate.connect();

  // Добавление базы данных в инжектор
  Injector.appInstance.registerSingleton<Database>((injector) =>
      Database.connect(connection));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Provider<Bloc>(
    create: (_) => Bloc(),
    dispose: (_, bloc) => bloc.close(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (BuildContext context) => L10n.of(context).title,
      localizationsDelegates: [
        const L10nDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ru'),
        const Locale('en'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        typography: Typography.material2018(),
      ),
      home: TimesheetPage(),
    ),
  );
}

Future<MoorIsolate> _createMoorIsolate() async {
  final dir = await getApplicationDocumentsDirectory();
  final path = p.join(dir.path, 'db.sqlite');
  final receivePort = ReceivePort();

  await Isolate.spawn(
    _startBackground,
    _IsolateStartRequest(receivePort.sendPort, path),
  );

  return (await receivePort.first as MoorIsolate);
}

void _startBackground(_IsolateStartRequest request) {
  final executor = VmDatabase(File(request.targetPath));
  final moorIsolate = MoorIsolate.inCurrent(() =>
      DatabaseConnection.fromExecutor(executor),
  );
  request.sendMoorIsolate.send(moorIsolate);
}

class _IsolateStartRequest {
  final SendPort sendMoorIsolate;
  final String targetPath;

  _IsolateStartRequest(this.sendMoorIsolate, this.targetPath);
}