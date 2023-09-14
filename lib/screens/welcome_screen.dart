import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/login_screen.dart';
import 'package:memo_dex_prototyp/screens/sign_up_screen.dart';

import '../widgets/button.dart';
import '../widgets/headline.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: Color(0xFF0784CB),
              image: DecorationImage(
                image: AssetImage("assets/images/waves_background.png"),
                fit: BoxFit.cover,
              )
            ),
            child: Column(
              children: [
                Container(
                  height: 450,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/images/logo.png"),
                        ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Headline(
                        text: "Welcome",
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                    child: Text("Create flashcards and organize folders "
                      "for maximum efficiency and effectiveness.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                Container(
                  child: Column(
                    children: [
                      Button(
                        text: "Sign up",
                        backgroundColor: "FFFFFF",
                        textColor: "E59113",
                        onPressed: SignUpScreen(),
                      ),
                      Button(
                        text: "Login",
                        backgroundColor: "E59113",
                        textColor: "FFFFFF",
                        onPressed: LoginScreen(),
                      ),
                    ],
                  ),
                )

              ],
            ),
          ),
        ),
    );
  }
}



