import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:joanda0/database/drift_database.dart';
import 'package:joanda0/screen/home_screen.dart';
import 'package:joanda0/theme_data.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);

  runApp(
    MaterialApp(
        title: 'Jo&A0 diary', theme: joAndAyThemeData, home: HomeScreen()),
  );
}
