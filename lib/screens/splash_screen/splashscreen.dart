import 'package:flutter/material.dart';
import 'package:money_manager/screens/home/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
        return HomeScreen();
      }));
    });
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: RadialGradient(colors: [
          Color.fromARGB(255, 6, 1, 66),
          Color.fromARGB(255, 97, 117, 233)
        ])),
      ),
    );
  }
}
