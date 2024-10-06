import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../widgets/text/headlines/headline_large.dart';
import '../../../widgets/header/top_navigation_bar.dart';
import '../../bottom_navigation_screen.dart';

class LanguageSettingScreen extends StatefulWidget
{
  const LanguageSettingScreen({super.key});

  @override
  State<LanguageSettingScreen> createState() => _LanguageSettingScreenState();
}

class _LanguageSettingScreenState extends State<LanguageSettingScreen>
{

  @override
  Widget build(BuildContext context)
  {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  HeadlineLarge(text: "Language"),
                ],
              ),
            ),
          ),
          Switch(
            value: isDarkMode,
            onChanged: (value)
            {
              setState(()
              {
                Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
              });
            },
          ),
        ],
      ),
    );
  }
}
