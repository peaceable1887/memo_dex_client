import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/welcome_screen.dart';
import 'package:memo_dex_prototyp/widgets/top_navigation_bar.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF0784CB),
                image: DecorationImage(
                  image: AssetImage("assets/images/waves_background.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            TopNavigationBar(
              onPressed: WelcomeScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
