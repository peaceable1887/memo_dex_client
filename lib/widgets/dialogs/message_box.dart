import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';

class MessageBox extends StatelessWidget {
  final String headline;
  final String message;
  final dynamic stackId;

  MessageBox({required this.message, required this.headline, required this.stackId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.green,
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
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 80,
                  ),
                  SizedBox(height: 0),
                  Text(
                    headline,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 27),
            Padding(
              padding: const EdgeInsets.fromLTRB(10,0,10,0),
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: "Inter",
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StackContentScreen(stackId: stackId)
                  ),
                );
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
                'ZURÜCK',
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