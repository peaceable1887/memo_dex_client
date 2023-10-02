import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/welcome_screen.dart';
import 'package:memo_dex_prototyp/widgets/top_navigation_bar.dart';

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
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    height: 140,
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WelcomeScreen(),
                  ),
                );
              },
            ),
          ],
        ),

    );
  }
}
