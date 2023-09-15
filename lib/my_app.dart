import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/welcome_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const WelcomeScreen(),
    );
  }
}