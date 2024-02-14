import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/setting/account/email_setting_screen.dart';
import 'package:memo_dex_prototyp/screens/setting/account/password_setting_screen.dart';
import 'package:memo_dex_prototyp/screens/setting/configuration/language_setting_screen.dart';
import 'package:memo_dex_prototyp/screens/setting/datamanagement/trash_setting_screen.dart';
import 'package:memo_dex_prototyp/widgets/buttons/setting_btn.dart';

import '../widgets/buttons/button.dart';
import '../widgets/header/headline.dart';
import 'bottom_navigation_screen.dart';

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
          Expanded(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20,0,20,0),
              child: ListView(
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "ACCOUNT",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      SettingBtn(
                        buttonText: "E-Mail",
                        buttonBorderRadius: [10,10,0,0],
                        pushToContent: EmailSettingScreen(),
                      ),
                      SizedBox(height: 1,),
                      SettingBtn(
                          buttonText: "Password",
                          buttonBorderRadius: [0,0,10,10],
                          pushToContent: PasswordSettingScreen(),
                      ),
                      SizedBox(height: 15,),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "CONFIGURATION",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      SettingBtn(
                          buttonText: "Language",
                          buttonBorderRadius: [10,10,0,0],
                          pushToContent: LanguageSettingScreen(),
                      ),
                      SettingBtn(
                          buttonText: "Disable Autocorrect",
                          buttonBorderRadius: [0,0,10,10],
                          pushToContent: BottomNavigationScreen(),
                          showSwitch: true,
                      ),
                      SizedBox(height: 15,),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "DATAMANAGEMENT",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      SettingBtn(
                          buttonText: "Trash",
                          buttonBorderRadius: [10,10,10,10],
                          pushToContent: TrashSettingScreen(),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Button(
                    text: "Logout",
                    backgroundColor: "00324E",
                    borderColor: "E59113",
                    textColor: "E59113",
                    onPressed: BottomNavigationScreen(),
                  ),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
