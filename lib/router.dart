import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../screens/login.dart';
import '../screens/loading.dart';
import '../screens/home.dart';
import '../screens/profile.dart';
import '../screens/register.dart';

class AppRouter {
  static final FluroRouter router = FluroRouter();

  static final Handler _loadingHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const LoadingScreen());

  static final Handler _loginHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const LoginScreen());

  static final Handler _registerHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const RegisterScreen());

  static final Handler _homeHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const HomeScreen());

  static final Handler _profileHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, dynamic> params) =>
          const ProfileScreen());

  static void defineRoutes() {
    router.define('/',
        handler: _loadingHandler, transitionType: TransitionType.none);
    router.define('/login', handler: _loginHandler);
    router.define('/register', handler: _registerHandler);
    router.define('/home', handler: _homeHandler);
    router.define('/profile', handler: _profileHandler);

    // it is also possible to define the route transition to use
    // router.define("users/:id", handler: usersHandler, transitionType: TransitionType.inFromLeft);
  }
}
