import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/user/login_screen.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/widgets/dialogs/validation_message_box.dart';

import '../../../screens/welcome_screen.dart';
import '../../buttons/button.dart';
import '../../../utils/divide_painter.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  late TextEditingController _eMail;
  late TextEditingController _password;
  late TextEditingController _repeatPassword;
  bool _isPasswordVisible = false;
  bool _isChecked = false;
  bool _isEnabled = false;
  final storage = FlutterSecureStorage();

  @override
  void initState()
  {
    super.initState();
    _eMail = TextEditingController();
    _eMail.addListener(updateButtonState);
    _password = TextEditingController();
    _password.addListener(updateButtonState);
    _repeatPassword = TextEditingController();
    _repeatPassword.addListener(updateButtonState);

  }

  void updateButtonState()
  {
    setState(() {
      if (_eMail.text.isNotEmpty && _password.text.isNotEmpty && _repeatPassword.text.isNotEmpty && _isChecked) {
        _isEnabled = true;
      } else {
        _isEnabled = false;
      }
    });
  }

  void validateForm(String email, String password, String repeatPassword) async
  {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    String? internetConnection = await storage.read(key: "internet_connection");

    if(internetConnection == "false")
    {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ValidationMessageBox(message: "Keine Internetverbidnung vorhanden.");
        },
      );
    }else{
      if (emailRegExp.hasMatch(email))
      {
        if (password == repeatPassword && password.isNotEmpty) {
          await ApiClient(context).userApi.createUser(_eMail.text, _password.text);
          storage.write(key: 'addUser', value: "true");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(),
            ),
          );
        } else
        {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ValidationMessageBox(message: "Passwörter sind nicht identisch.");
            },
          );
        }
      } else
      {
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
    _repeatPassword.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 15, 20,0),
        child: ListView(
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
                      size: 30),
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
                  ),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
              child: TextFormField(
                controller: _repeatPassword,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: "repeat Password",
                  contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                  labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                  prefixIcon: Icon(
                      Icons.safety_check,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
              child: Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //TODO Style eventuell noch in ThemeData auslagern
                    Checkbox(
                      side: BorderSide(color: Colors.white, width: 2),
                      activeColor: Theme.of(context).colorScheme.primary,
                      checkColor: Theme.of(context).scaffoldBackgroundColor,
                      value: _isChecked,
                      onChanged: (bool? value)
                      {
                        setState(() {
                          _isChecked = value!;
                          updateButtonState(); // Hier rufe die updateButtonState-Methode auf
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,5,0),
                      child: Text(
                        "Agree with Terms & Conditions",
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isEnabled
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.tertiary,
                        minimumSize: Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        side: BorderSide(
                          color: _isEnabled
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.tertiary,
                          width: 2.0,
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isEnabled
                          ? () {
                        setState(() {
                          validateForm(_eMail.text, _password.text, _repeatPassword.text);
                        });
                      }
                          : null, // Deaktivieren Sie den Button, wenn nicht aktiviert
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Sign Up",
                            //TODO Style eventuell noch in ThemeData auslagern
                            style: TextStyle(
                              color: _isEnabled
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : Theme.of(context).colorScheme.tertiary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomPaint(
                            size: Size(MediaQuery.of(context).size.width/2.75, 2),
                            painter: DividePainter(Colors.white),
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
                            painter: DividePainter(Colors.white),
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
                    Container(
                      height: MediaQuery.of(context).size.height/6.5,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Indem Sie fortfahren, stimmen Sie den Nutzerbedinungen und der Datenschutzrichtlinie zu.",
                          style: Theme.of(context).textTheme.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
