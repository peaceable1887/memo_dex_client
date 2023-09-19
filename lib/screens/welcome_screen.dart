import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/login_screen.dart';
import 'package:memo_dex_prototyp/screens/sign_up_screen.dart';

import '../widgets/button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          body: Container(
            color: Color(0xFF00324E),
            child: Column(
              children: [
                Container(
                  height: 450,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/images/logo_alternative.png"),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20,0,20,0),
                  child: Container(
                    child: Column(
                      children: [
                        Button(
                          text: "Login",
                          backgroundColor: "E59113",
                          borderColor: "E59113",
                          textColor: "00324E",
                          onPressed: LoginScreen(),
                        ),
                        Button(
                          text: "Sign up",
                          backgroundColor: "00324E",
                          borderColor: "E59113",
                          textColor: "E59113",
                          onPressed: SignUpScreen(),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                  height: 240,
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
                  ),
              ],
            ),
          ),
    );
  }
}



