
import 'package:demo/animated_root.dart';
import 'package:demo/login_screen/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    onChangeScreen(context);
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/quiz3.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }


  onChangeScreen( BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }
}
