import 'package:flutter/material.dart';

import '../../../utils/trim.dart';

class HeadlineLarge extends StatefulWidget {

  final String text;

  const HeadlineLarge({Key? key, required this.text}) : super(key: key);

  @override
  State<HeadlineLarge> createState() => _HeadlineLargeState();
}

class _HeadlineLargeState extends State<HeadlineLarge> {

  bool textIsTooLong = false;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Container(
        child: Text(
          Trim().trimText(widget.text,30),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
