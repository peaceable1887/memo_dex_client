import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/services/rest_services.dart';
import 'package:memo_dex_prototyp/widgets/divide_painter.dart';

import '../screens/welcome_screen.dart';
import 'button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState(); //nochmal genau ansehen was der teil macht
}

class _LoginFormState extends State<LoginForm> {

  late TextEditingController _email;
  late TextEditingController _password;

  //nochmal genau ansehen was der teil macht
  @override
  void initState() {
    _email = TextEditingController();
    _email.addListener(() {
      setState(() {
          //wenn statusänderungen vorgenommen werden sollen
      });
    });
    _password = TextEditingController();
    _password.addListener(() {
      setState(() {
          //wenn statusänderungen vorgenommen werden sollen
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
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
                controller: _email,
                decoration: InputDecoration(
                  labelText: "E-Mail",
                  labelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: Icon(Icons.email, color: Colors.white, size: 30,),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      // Toggle the password visibility here
                    },
                    child: Icon(
                      Icons.cancel,
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
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: TextFormField(
                controller: _password,
                obscureText: true, // Passwort verschleiern
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: TextStyle(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.white,size: 30),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        // Toggle the password visibility here
                      },
                      child: Icon(
                        Icons.visibility_off,
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
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
              width: double.infinity,
              child: Text(
                "Forgot password?",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700
                ),
              ),
            ),// Container Forgort password
            Container(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(int.parse("0xFFE59113")),
                      minimumSize: Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      side: BorderSide(
                        color: Color(int.parse("0xFFE59113")),
                        width: 2.0,
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      setState(() {
                        RestServices().loginUser(_email.text, _password.text);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Color(int.parse("0xFF00324E")),
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
                          size: Size(165, 2),
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
                          size: Size(165, 2),
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
            ),// Container Login or Google Login
          ],
        ),
    );
  }
}
