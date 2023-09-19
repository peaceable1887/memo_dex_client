import 'package:flutter/material.dart';

import '../screens/welcome_screen.dart';
import '../services/rest_services.dart';
import 'button.dart';
import 'divide_painter.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {

  late TextEditingController _eMail;
  late TextEditingController _password;
  late TextEditingController _repeatPassword;

  @override
  void initState() {
    _eMail = TextEditingController();
    _eMail.addListener(() {
      setState(() {

      });
    });
    _password = TextEditingController();
    _password.addListener(() {
      setState(() {

      });
    });
    _repeatPassword = TextEditingController();
    _repeatPassword.addListener(() {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _eMail.dispose();
    _password.dispose();
    _repeatPassword.dispose();
    super.dispose();
  }

  void validatePassword(String password, String repeatPassword)
  {
    if(password == repeatPassword){
      RestServices().createUser(_eMail.text, _password.text);
    }else{
      print("Passwörter sind nicht identisch!");
    }

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
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(Icons.email, color: Colors.white,size: 30),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: TextFormField(
              controller: _repeatPassword,
              obscureText: true, // Passwort verschleiern
              decoration: InputDecoration(
                labelText: "repeat Password",
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(Icons.safety_check, color: Colors.white,size: 30),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
            child: Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
                    side: BorderSide(color: Colors.white, width: 2),
                    value: false,
                    onChanged: null,
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
                        validatePassword(_password.text, _repeatPassword.text);
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sign up",
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
            ),
        ],
      ),

    );
  }
}
