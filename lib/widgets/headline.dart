import 'package:flutter/material.dart';

class Headline extends StatefulWidget {

  final String text;

  const Headline({Key? key, required this.text}) : super(key: key);

  @override
  State<Headline> createState() => _HeadlineState();
}

class _HeadlineState extends State<Headline> {

  bool textIsTooLong = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String trimText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + "...";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
        child: Text(
          trimText(widget.text,30),
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontFamily: "Inter",
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}
