import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const SmartTaskManager());
}

class SmartTaskManager extends StatelessWidget {
  const SmartTaskManager({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Task Manager',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}