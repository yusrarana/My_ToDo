import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyTodoApp());
}

class MyTodoApp extends StatelessWidget {
  const MyTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Todo',
      theme: ThemeData(
        primaryColor: const Color(0xFF6C72CB),
        scaffoldBackgroundColor: const Color(0xFF6C72CB),
      ),
      home: const SplashScreen(),
    );
  }
}
