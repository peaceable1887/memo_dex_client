import 'package:flutter/material.dart';

class Headline extends StatelessWidget {

  final String text;

  const Headline({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0),
          )
      ),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontFamily: "Inter",
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}
