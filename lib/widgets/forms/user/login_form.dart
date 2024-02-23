import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/utils/divide_painter.dart';
import 'package:memo_dex_prototyp/widgets/dialogs/validation_message_box.dart';

import '../../../screens/welcome_screen.dart';
import '../../buttons/button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState(); //nochmal genau ansehen was der teil macht
}

class _LoginFormState extends State<LoginForm> {

  late TextEditingController _eMail;
  late TextEditingController _password;
  bool _isPasswordVisible = false;
  bool _isButtonEnabled = false;
  final storage = FlutterSecureStorage();


  //nochmal genau ansehen was der teil macht
  @override
  void initState()
  {
    super.initState();
    _eMail = TextEditingController();
    _eMail.addListener(updateButtonState);
    _password = TextEditingController();
    _password.addListener(updateButtonState);
  }


  void updateButtonState() {
    setState(() {
      if(_eMail.text.isNotEmpty && _password.text.isNotEmpty){
        _isButtonEnabled = true;
      }else{
        _isButtonEnabled = false;
      }
    });
  }
  void validateForm(String email, String password) async
  {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

    if(isConnected == false)
    {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ValidationMessageBox(message: "Keine Internetverbidnung vorhanden.");
        },
      );

    }else
    {
      if (emailRegExp.hasMatch(email))
      {
        await ApiClient(context).userApi.loginUser(_eMail.text, _password.text);
      }else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Bitte eine gültige E-Mail Adresse angeben.");
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _eMail.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20,0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: TextFormField(
                controller: _eMail,
                decoration: InputDecoration(
                  labelText: "E-Mail",
                  contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  prefixIcon: Icon(
                    Icons.email,
                    color: Theme.of(context).inputDecorationTheme.prefixIconColor,
                    size: 30,),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _eMail.text = "";
                      });
                    },
                    child: Icon(
                      _eMail.text.isNotEmpty ? Icons.cancel : null,
                      color: Theme.of(context).inputDecorationTheme.suffixIconColor,
                    ),
                  ),// Icon hinzufügen
                  enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                  focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                  filled: true,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                style: Theme.of(context).inputDecorationTheme.floatingLabelStyle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: TextFormField(
                controller: _password,
                obscureText: !_isPasswordVisible, // Passwort verschleiern
                  decoration: InputDecoration(
                    labelText: "Password",
                    contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                    labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                    prefixIcon: Icon(
                        Icons.lock,
                        color: Theme.of(context).inputDecorationTheme.prefixIconColor,
                        size: 30),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      child: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).inputDecorationTheme.suffixIconColor,
                      ),
                    ),// Icon hinzufügen
                    enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                    focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                    filled: true,
                    fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                ),
                style: Theme.of(context).inputDecorationTheme.floatingLabelStyle,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
              width: double.infinity,
              child: Text(
                "Forgot password?",
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),// Container Forgort password
            Container(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonEnabled
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.tertiary,
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      side: BorderSide(
                        color: _isButtonEnabled
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.tertiary,
                        width: 2.0,
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isButtonEnabled
                        ? () {
                          setState(() {
                            validateForm(_eMail.text, _password.text);
                          });
                        }
                      : null, // Deaktivieren Sie den Button, wenn nicht aktiviert
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            color: _isButtonEnabled
                                ? Theme.of(context).scaffoldBackgroundColor
                                : Theme.of(context).colorScheme.tertiary, // Textfarbe ändern, wenn nicht aktiviert
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width/2.75, 2),
                          painter: DividePainter(),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0), // Füge horizontalen Abstand hinzu
                          child: Text(
                            "or",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        CustomPaint(
                          size: Size(MediaQuery.of(context).size.width/2.75, 2),
                          painter: DividePainter(),
                        ),
                      ],
                    ),
                  ),
                  Button(
                    text: "Continue with Google",
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    borderColor: Theme.of(context).colorScheme.surface,
                    textColor: Theme.of(context).colorScheme.tertiary,
                    onPressed: ()
                    {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WelcomeScreen(),
                        ),
                      );
                    },
                    iconPath: "assets/images/google_icon.png",
                  ),
                ],
              ),
            ),// Container Login or Google Login
          ],
        ),
    );
  }
}
