import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme() {
  final theme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.purple,
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ),
  );
  return theme;
}

ThemeData darkTheme() {
  final theme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.purple,
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.light.copyWith(
      statusBarIconBrightness: Brightness.light,
    ),
  );
  return theme;
}
