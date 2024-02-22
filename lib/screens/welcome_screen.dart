import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/user/login_screen.dart';
import 'package:memo_dex_prototyp/screens/user/sign_up_screen.dart';

import '../widgets/buttons/button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height/8, 0, 0),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage("assets/images/logo_dark_theme.png"),
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
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          borderColor: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).scaffoldBackgroundColor,
                          onPressed: ()
                          {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );
                          },
                        ),
                        Button(
                          text: "Sign up",
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          borderColor: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.primary,
                          onPressed: ()
                          {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUpScreen(),
                              ),
                            );
                          },
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
                          style: Theme.of(context).textTheme.bodySmall,
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



