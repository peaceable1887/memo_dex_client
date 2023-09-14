import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  final String text;
  final String backgroundColor;
  final String textColor;
  final Widget onPressed;
  final String? iconPath;

  const Button({Key? key, required this.backgroundColor, required this.textColor, required this.text, required this.onPressed, this.iconPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(int.parse("0xFF$backgroundColor")),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => onPressed,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (iconPath != null)
                  Image.asset(
                    iconPath!, // ! wird verwendet um den Compiler mitzuteilen das iconPath ganz sicher nicht NULL ist
                    width: 24,
                    height: 24,
                  ),
                if (iconPath != null)
                  SizedBox(width: 8), // Optionaler Abstand zwischen dem Icon und dem Text
                Text(
                  text,
                  style: TextStyle(
                    color: Color(int.parse("0xFF$textColor")),
                    fontSize: 20,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}