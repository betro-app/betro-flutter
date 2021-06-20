import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:logging_appenders/logging_appenders.dart';

// import './router.dart';

import '../screens/groups.dart';
import '../screens/newgroup.dart';
import '../screens/login.dart';
import '../screens/loading.dart';
import '../screens/home.dart';
import '../screens/profile.dart';
import '../screens/register.dart';
import '../screens/user.dart';
import '../screens/approvals.dart';
import '../screens/followers.dart';
import '../screens/followees.dart';

final _logger = Logger('main');

void main() {
  Logger.root.level = kReleaseMode ? Level.WARNING : Level.FINE;
  PrintAppender().attachToLogger(Logger.root);
  _logger.fine('Application launched');
  // AppRouter.defineRoutes();
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
      routes: {
        '/': (context) => LoadingScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/register': (context) => RegisterScreen(),
        '/profile': (context) => ProfileScreen(),
        '/user': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments as UserScreenProps;
          return UserScreen(props: args);
        },
        '/groups': (context) => GroupScreen(),
        '/newgroup': (context) => NewGroupScreen(),
        '/followers': (context) => FollowersScreen(),
        '/followees': (context) => FolloweesScreen(),
        '/approvals': (context) => ApprovalsScreen(),
      },
      // onGenerateRoute: AppRouter.router.generator,
    );
  }
}
