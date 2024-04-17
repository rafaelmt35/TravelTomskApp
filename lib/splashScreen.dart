import 'dart:async';

import 'package:flutter/material.dart';
import 'package:travel_app/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait for 3 seconds then navigate to the main screen
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/initial');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maincolor,
      body: Center(
        child: Container(
          width: 160.0,
          height: 160.0,
          decoration: const BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/3.png'))),
        ),
      ),
    );
  }
}
