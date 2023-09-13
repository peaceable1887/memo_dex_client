import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  final String text;
  final String backgroundColor;
  final String textColor;

  const Button({Key? key, required this.backgroundColor, required this.textColor, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Color(int.parse("0xFF$backgroundColor")),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                )
            ),
            onPressed: (){},
            child: Text(
              text,
              style: TextStyle(
                color: Color(int.parse("0xFF$textColor")),
                fontSize: 20,
                fontFamily: "Inter",
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ],
      ),
    );
  }
}