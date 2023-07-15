import 'package:flutter/material.dart';

ThemeData joAndAyThemeData = ThemeData(
  fontFamily: 'NotoSansKR',
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.lightBlue[500],
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black),
    ),
  ),
);
