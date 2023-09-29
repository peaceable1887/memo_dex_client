import 'package:flutter/material.dart';

class Headline extends StatelessWidget {

  final String text;

  const Headline({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontFamily: "Inter",
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}
