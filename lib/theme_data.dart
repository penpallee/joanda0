import 'package:flutter/material.dart';

const seedColor = Color.fromARGB(223, 250, 161, 238);
const dark = Brightness.dark;
const light = Brightness.light;
const outPadding = 32.0;

ThemeData joAndAyThemeData = ThemeData(
  // backgroundColor: Colors.blue,
  // dialogBackgroundColor: Colors.blue,
  // scaffoldBackgroundColor: Colors.blue,
  colorScheme: ColorScheme.fromSeed(seedColor: seedColor, brightness: dark),
  fontFamily: 'NotoSansKR',
  // primaryColor: Colors.white,
  // scaffoldBackgroundColor: Colors.lightBlue[500],
  // appBarTheme: const AppBarTheme(
  //   backgroundColor: Colors.white,
  //   elevation: 0,
  //   iconTheme: IconThemeData(color: Colors.black),
  // ),
  // inputDecorationTheme: const InputDecorationTheme(
  //   border: OutlineInputBorder(
  //     borderSide: BorderSide(color: Colors.black),
  //   ),
  //   enabledBorder: OutlineInputBorder(
  //     borderSide: BorderSide(color: Colors.black),
  //   ),
  //   focusedBorder: OutlineInputBorder(
  //     borderSide: BorderSide(color: Colors.black),
  //   ),
  // ),
);
