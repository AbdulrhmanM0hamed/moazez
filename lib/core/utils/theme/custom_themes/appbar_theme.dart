import 'package:flutter/material.dart';

class TAppBarTheme {
  TAppBarTheme._();

  static AppBarTheme lightAppBarTheme = const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme:  IconThemeData(size: 24),
    actionsIconTheme:  IconThemeData(size: 24),
    titleTextStyle:  TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      fontFamily: 'Cairo',
    ),
  );

  static AppBarTheme darkAppBarTheme = const AppBarTheme(
    elevation: 0,
    centerTitle: true,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme:  IconThemeData(color: Colors.white, size: 24),
    actionsIconTheme:  IconThemeData(color: Colors.white, size: 24),
    titleTextStyle:  TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontFamily: 'Cairo',
    ),
  );
}
