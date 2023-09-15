import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/widgets/divide_painter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(() {
      setState(() {

      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20,0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
              child: TextFormField(
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
          ],
        ),
    );
  }
}
