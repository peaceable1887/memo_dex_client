import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/welcome_screen.dart';
import 'package:memo_dex_prototyp/widgets/top_navigation_bar.dart';

import '../widgets/button.dart';
import '../widgets/divide_painter.dart';
import '../widgets/headline.dart';
import '../widgets/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
                            text: "Sign up"
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: SignUpForm(),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Checkbox(
                          side: BorderSide(color: Colors.white, width: 2),
                          value: false,
                          onChanged: null,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,0,3),
                          child: Text(
                            "Agree with Terms & Conditions",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Button(
                          text: "Sign up",
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
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Indem Sie fortfahren, stimmen Sie den Nutzerbedinungen und der Datenschutzrichtlinie zu.",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),// Container Lo// Conta
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
