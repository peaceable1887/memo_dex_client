import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/welcome_screen.dart';
import 'package:memo_dex_prototyp/widgets/header/top_navigation_bar.dart';

import '../../widgets/text/headlines/headline_large.dart';
import '../../widgets/forms/user/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,5,0,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  WillPopScope(
                    onWillPop: () async => false,
                    child: Container(
                      child: TopNavigationBar(
                        btnText: "",
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,10,0,0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HeadlineLarge(text: "Sign up"),
                  ],
                ),
              ),
            ),
            Container(
              child: SignUpForm(),
            ),
          ],
        ),

    );
  }
}
