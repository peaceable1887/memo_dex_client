import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/user/login_screen.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/widgets/dialogs/validation_message_box.dart';

import '../../screens/welcome_screen.dart';
import '../buttons/button.dart';
import '../../utils/divide_painter.dart';

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
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(Icons.email, color: Colors.white,size: 30),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _eMail.text = "";
                    });
                  },
                  child: Icon(
                    _eMail.text.isNotEmpty ? Icons.cancel : null,
                    color: Colors.white.withOpacity(0.50),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8597A1),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white, // Ändern Sie hier die Farbe des Rahmens im Fokus
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                filled: true,
                fillColor: Color(0xFF33363F),
              ),
              style: TextStyle(
                color: Colors.white, // Ändern Sie die Textfarbe auf Weiß
                fontSize: 16,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
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
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.white,size: 30),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white.withOpacity(0.50),
                  ),
                ),// Icon hinzufügen
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8597A1),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white, // Ändern Sie hier die Farbe des Rahmens im Fokus
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                filled: true,
                fillColor: Color(0xFF33363F),
              ),
              style: TextStyle(
                color: Colors.white, // Ändern Sie die Textfarbe auf Weiß
                fontSize: 16,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
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
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(Icons.safety_check, color: Colors.white,size: 30),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  child: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white.withOpacity(0.50),
                  ),
                ),// Icon hinzufügen
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF8597A1),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white, // Ändern Sie hier die Farbe des Rahmens im Fokus
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                filled: true,
                fillColor: Color(0xFF33363F),
              ),
              style: TextStyle(
                color: Colors.white, // Ändern Sie die Textfarbe auf Weiß
                fontSize: 16,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
                    side: BorderSide(color: Colors.white, width: 2),
                    activeColor: Color(int.parse("0xFFE59113")),
                    checkColor: Color(int.parse("0xFF00324E")),
                    value: _isChecked,
                    onChanged: (bool? value) {
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
                    padding: const EdgeInsets.fromLTRB(0,0,5,3),
                    child: Text(
                      "Agree with Terms & Conditions",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w700
                      ),
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
                          ? Color(int.parse("0xFFE59113"))
                          : Color(0xFF8597A1),
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      side: BorderSide(
                        color: _isEnabled
                            ? Color(int.parse("0xFFE59113"))
                            : Color(0xFF8597A1), // Button-Rahmenfarbe ändern, wenn nicht aktiviert
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
                          "Login",
                          style: TextStyle(
                            color: _isEnabled
                                ? Color(int.parse("0xFF00324E"))
                                : Color(0xFF8597A1), // Textfarbe ändern, wenn nicht aktiviert
                            fontSize: 20,
                            fontFamily: "Inter",
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
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                            ),
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
                    backgroundColor: "FFFFFF",
                    borderColor: "FFFFFF",
                    textColor: "8597A1",
                    onPressed: WelcomeScreen(),
                    iconPath: "assets/images/google_icon.png",
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
