import 'package:flutter/material.dart';

import '../../../widgets/header/headline.dart';
import '../../../widgets/header/top_navigation_bar.dart';
import '../../bottom_navigation_screen.dart';
import '../../setting_screen.dart';

class TrashSettingScreen extends StatefulWidget
{
  const TrashSettingScreen({super.key});

  @override
  State<TrashSettingScreen> createState() => _TrashSettingScreenState();
}

class _TrashSettingScreenState extends State<TrashSettingScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00324E),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,5,0,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                WillPopScope(
                  onWillPop: () async => false,
                  child: Container(
                    child: TopNavigationBar(
                      btnText: "Settings",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen(index: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Headline(text: "Trash"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
