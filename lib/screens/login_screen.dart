import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/sign_up_screen.dart';
import 'package:memo_dex_prototyp/screens/welcome_screen.dart';
import 'package:memo_dex_prototyp/widgets/headline.dart';
import 'package:memo_dex_prototyp/widgets/login_form.dart';
import 'package:memo_dex_prototyp/widgets/top_navigation_bar.dart';

import '../widgets/button.dart';
import '../widgets/divide_painter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              color: Color(0xFF00324E),
              child: ListView(
                children: [
                  Container(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Headline(
                            text: "Login"
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: LoginForm(),
                  ),// Container LoginForm
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 30),
                    width: double.infinity,
                    child: Text(
                        "Forgot password?",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),// Container Forgort password
                  Container(
                    child: Column(
                      children: [
                        Button(
                          text: "Login",
                          backgroundColor: "E59113",
                          borderColor: "E59113",
                          textColor: "00324E",
                          onPressed: WelcomeScreen(),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomPaint(
                                size: Size(165, 2),
                                painter: DividePainter(),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0), // Füge horizontalen Abstand hinzu
                                child: Text(
                                  "or",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              CustomPaint(
                                size: Size(165, 2),
                                painter: DividePainter(),
                              ),
                            ],
                          ),
                        ),
                        Button(
                          text: "Continue with Google",
                          backgroundColor: "FFFFFF",
                          borderColor: "FFFFFF",
                          textColor: "8597A1",
                          onPressed: WelcomeScreen(),
                          iconPath: "assets/images/google_icon.png",
                        ),
                      ],
                    ),
                  ),// Container Login or Google Login
                ],
              ),
            ),
            TopNavigationBar(
              onPressed: WelcomeScreen(),
           ),
          ],
        ),
    );
  }
}
