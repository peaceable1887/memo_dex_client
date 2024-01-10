import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/sign_up_screen.dart';
import 'package:memo_dex_prototyp/screens/welcome_screen.dart';
import 'package:memo_dex_prototyp/widgets/headline.dart';
import 'package:memo_dex_prototyp/widgets/login_form.dart';
import 'package:memo_dex_prototyp/widgets/top_navigation_bar.dart';

import '../widgets/button.dart';
import '../widgets/components/custom_snackbar.dart';
import '../widgets/divide_painter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final storage = FlutterSecureStorage();

  @override
  void initState()
  {
    showSnackbarInformation();
    super.initState();
  }

  void showSnackbarInformation() async
  {
    String? stackCreated = await storage.read(key: 'addUser');
    if(stackCreated == "true")
    {
      CustomSnackbar.showSnackbar(
          context,
          "Information",
          "User was successfully created.",
          Colors.green,
          Duration(milliseconds: 500),
          Duration(milliseconds: 1500)
      );
      await storage.write(key: 'addUser', value: "false");
    }
  }

  @override
  void dispose()
  {
    showSnackbarInformation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
              color: Color(0xFF00324E),
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
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
