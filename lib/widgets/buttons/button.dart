import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onPressed;
  final String? iconPath;

  const Button({Key? key,
    required this.backgroundColor,
    required this.textColor,
    required this.text,
    required this.onPressed,
    this.iconPath,
    required this.borderColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              minimumSize: Size(double.infinity, 55),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              side: BorderSide(
                color: borderColor,
                width: 2.0,
              ),
              elevation: 0,
            ),
            onPressed: onPressed,
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
                    color: textColor,
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