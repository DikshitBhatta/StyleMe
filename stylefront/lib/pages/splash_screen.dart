import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to OnboardingScreen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.checkroom, // Minimalist t-shirt icon
              color: Colors.white,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'StyleMe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                // Removed 'Modern' fontFamily
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Elevate your style, Embrace your fit.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                // Removed 'Modern' fontFamily
              ),
            ),
          ],
        ),
      ),
    );
  }
}