import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/user/login_screen.dart';
import 'package:memo_dex_prototyp/screens/welcome_screen.dart';
import 'package:memo_dex_prototyp/widgets/forms/user/forgot_password_form.dart';
import 'package:memo_dex_prototyp/widgets/text/headlines/headline_large.dart';
import 'package:memo_dex_prototyp/widgets/forms/user/login_form.dart';
import 'package:memo_dex_prototyp/widgets/header/top_navigation_bar.dart';
import '../../widgets/dialogs/custom_snackbar.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final storage = FlutterSecureStorage();

  @override
  void initState()
  {
    super.initState();
  }

  @override
  void dispose()
  {
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
                            builder: (context) => LoginScreen(),
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
                  HeadlineLarge(text: "Forgot Password?"),
                ],
              ),
            ),
          ),
          Container(
            child: ForgotPasswordForm(),
          ),
        ],
      ),
    );
  }
}
