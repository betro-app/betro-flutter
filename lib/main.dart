import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';

import './router.dart';

final _logger = Logger('main');

void main() {
  Logger.root.level = kReleaseMode ? Level.WARNING : Level.FINER;
  PrintAppender().attachToLogger(Logger.root);
  _logger.fine('Application launched');
  AppRouter.defineRoutes();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.lightBlue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        accentColor: Colors.lightBlue,
      ),
      onGenerateRoute: AppRouter.router.generator,
    );
  }
}
