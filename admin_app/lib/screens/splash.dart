import 'package:admin_app/screens/setup.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the main screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
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
              Color(0xFF0000FF), // Dark blue-green
              Color(0xFF28738E), // Light gray
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
