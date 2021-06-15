import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../screens/login.dart';
import '../screens/loading.dart';
import '../screens/home.dart';

class AppRouter {
  static final FluroRouter router = FluroRouter();

  static final Handler _loginHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          LoginScreen());

  static final Handler _homeHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          HomeScreen());

  static final Handler _loadingHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          LoadingScreen());

  static void defineRoutes() {
    router.define('/', handler: _loadingHandler);
    router.define('/login', handler: _loginHandler);
    router.define('/home', handler: _homeHandler);

    // it is also possible to define the route transition to use
    // router.define("users/:id", handler: usersHandler, transitionType: TransitionType.inFromLeft);
  }
}
