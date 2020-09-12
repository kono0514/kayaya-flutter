import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  appBarTheme: AppBarTheme(
    color: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    actionsIconTheme: IconThemeData(color: Colors.black),
  ),
  typography: Typography.material2018(platform: defaultTargetPlatform),
  splashFactory: InkRipple.splashFactory,
  highlightColor: Colors.transparent,
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[900],
  ),
  typography: Typography.material2018(platform: defaultTargetPlatform),
  splashFactory: InkRipple.splashFactory,
  highlightColor: Colors.transparent,
);
