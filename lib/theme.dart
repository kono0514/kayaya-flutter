import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  primaryTextTheme: TextTheme(
    headline6: TextStyle(color: Colors.black),
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue,
    textTheme: ButtonTextTheme.primary,
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.grey.shade800,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  typography: Typography.material2018(
    platform: defaultTargetPlatform,
  ),
  splashFactory: InkRipple.splashFactory,
  highlightColor: Colors.transparent,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  backgroundColor: Colors.grey.shade900,
  scaffoldBackgroundColor: Colors.grey.shade900,
  dialogBackgroundColor: Colors.grey.shade800,
  appBarTheme: AppBarTheme(
    color: Colors.grey[850],
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[850],
  ),
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey[850],
    modalBackgroundColor: Colors.grey[850],
  ),
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.grey.shade800,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
  typography: Typography.material2018(
    platform: defaultTargetPlatform,
  ),
  splashFactory: InkRipple.splashFactory,
  highlightColor: Colors.transparent,
);
