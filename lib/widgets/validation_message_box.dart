import 'package:flutter/material.dart';

class ValidationMessageBox extends StatelessWidget {
  final String message;

  ValidationMessageBox({required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Fehler'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Schließen Sie das Dialogfeld
          },
          child: Text('OK'),
        ),
      ],
    );
  }

  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ValidationMessageBox(message: message);
      },
    );
  }
}