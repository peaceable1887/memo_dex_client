import 'package:flutter/material.dart';

import '../widgets/header/headline.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00324E),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,80,0,0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Headline(text: "Settings"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
