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
        body: Stack(
          children: [
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const HeadlineLarge(
                            text: "Sign up"
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: SignUpForm(),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    height: MediaQuery.of(context).size.height/6.5,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Indem Sie fortfahren, stimmen Sie den Nutzerbedinungen und der Datenschutzrichtlinie zu.",
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),// Container Lo// Conta
                ],
              ),
            ),
            TopNavigationBar(
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
          ],
        ),

    );
  }
}
