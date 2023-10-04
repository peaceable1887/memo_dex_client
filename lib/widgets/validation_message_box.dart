import 'package:flutter/material.dart';

class ValidationMessageBox extends StatelessWidget {
  final String message;

  ValidationMessageBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: 200.0,
        height: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,30,0,0),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Colors.white,
                    size: 100,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Fehler!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 35),
            Text(
              message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: "Inter",
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(

                backgroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft:  Radius.circular(10),
                  ), // Hier wird der BorderRadius entfernt
                ),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF8597A1),
                  fontSize: 18,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}