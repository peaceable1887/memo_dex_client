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
        padding: const EdgeInsets.fromLTRB(20, 35, 20,0),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: "E-Mail",
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(Icons.email, color: Colors.white,size: 30,),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(0.0),
                    bottomRight: Radius.circular(0.0),
                  ),
                ),
                filled: true,
                fillColor: Color(0xFF00324E),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              style: TextStyle(
                color: Colors.white, // Ändern Sie die Textfarbe auf Weiß
                fontSize: 16,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
            ),
            CustomPaint(
              size: Size(391, 0.2),
              painter: DividePainter(),
            ),
            TextFormField(
              obscureText: true, // Passwort verschleiern
                decoration: InputDecoration(
                  labelText: "Passwort",
                  labelStyle: TextStyle(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                  prefixIcon: Icon(Icons.lock, color: Colors.white,size: 30), // Icon hinzufügen
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                  ),
                ),
                filled: true,
                fillColor: Color(0xFF00324E),
                floatingLabelBehavior: FloatingLabelBehavior.never,

              ),
              style: TextStyle(
                color: Colors.white, // Ändern Sie die Textfarbe auf Weiß
                fontSize: 16,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
    );
  }
}
