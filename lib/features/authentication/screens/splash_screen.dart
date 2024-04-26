import 'package:flutter/material.dart';
import 'package:tugas_progmob_2/features/authentication/screens/starting_page.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    delayScreen();
  }

  delayScreen() async {
    var duration = Duration(seconds: 5);
    Timer(
      duration,
      () {
        try {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StartingPage(),
            ),
          );
        } catch (e) {
          print("Navigation Error: $e");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFAFAFA),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 260,
                ),
                const SizedBox(height: 32),
                Text("BorrowMo",
                    style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 16),
                Text(
                  "Satu solusi untuk semua masalah finansialmu",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ));
  }
}
