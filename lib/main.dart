import 'package:firebase_core/firebase_core.dart';
import 'package:joanda0/component/provider.dart';
import 'package:joanda0/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:joanda0/screen/login_screen.dart';
import 'package:joanda0/theme_data.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await initializeDateFormatting();

  runApp(
    ChangeNotifierProvider(
      create: (context) => GroupIdProvider(),
      child: MaterialApp(
          title: 'Jo&A0 diary',
          theme: joAndAyThemeData,
          home: const LoginScreen()),
    ),
  );
}
