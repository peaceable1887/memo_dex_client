import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/welcome_screen.dart';
import 'package:memo_dex_prototyp/widgets/text/headlines/headline_large.dart';
import 'package:memo_dex_prototyp/widgets/forms/user/login_form.dart';
import 'package:memo_dex_prototyp/widgets/header/top_navigation_bar.dart';
import '../../widgets/dialogs/custom_snackbar.dart';

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
    String? userCreated = await storage.read(key: 'addUser');
    if(userCreated == "true")
    {
      CustomSnackbar.showSnackbar(
          context,
          Icons.check_rounded,
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
                    HeadlineLarge(text: "Login"),
                  ],
                ),
              ),
            ),
            LoginForm(),
          ],
        ),
    );
  }
}
