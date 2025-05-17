import 'dart:async';

import 'package:client_app/screens/OnBoardingPages/onboarding.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 4 seconds
    Future.delayed(const Duration(seconds: 4), () {
      // Check if the widget is still in the tree
      if (mounted) {
        // Navigate to the main screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SetUPScreenA()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF18637B), // Dark blue-green
              Color(0xFFD3D3D3), // Light gray
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "TORTUGA",
                style: TextStyle(
                  fontSize: 32,
                  fontFamily: 'InknutAntiqua',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Better Food, Better Mood",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontFamily: 'Inder',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
