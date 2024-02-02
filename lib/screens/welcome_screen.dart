import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/login_screen.dart';
import 'package:memo_dex_prototyp/screens/sign_up_screen.dart';

import '../widgets/buttons/button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Container(
          color: Color(0xFF00324E),
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height/8, 0, 0),
            child: Column(
              children: [
                Expanded(
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
                  padding: EdgeInsets.fromLTRB(20,MediaQuery.of(context).size.height/8,20,0),
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
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
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
                ),
              ],
            ),
          ),
        ),
    );
  }
}



