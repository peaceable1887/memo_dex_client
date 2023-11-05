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
      resizeToAvoidBottomInset: false,
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
                ],
              ),
            ),
            TopNavigationBar(
              btnText: "",
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
