import 'package:flutter/material.dart';

class ValidationMessageBox extends StatelessWidget {
  final String message;

  ValidationMessageBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          'Eingabefehler!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
          ),
      ),
      content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "Inter",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
              'OK',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
      backgroundColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0), // Ändere die Eckenrundung des Dialogs
      ),
    );
  }
}