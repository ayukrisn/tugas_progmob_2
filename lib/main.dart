import 'package:flutter/material.dart';
import 'package:tugas_progmob_2/features/authentication/screens/starting_page.dart';
import 'package:tugas_progmob_2/utils/theme/theme.dart';
import 'package:tugas_progmob_2/features/authentication/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: TAppTheme.theme,
      home: SplashScreen(),
    );
  }
}