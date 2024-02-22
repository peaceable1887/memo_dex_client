import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/settings/account/email_setting_screen.dart';
import 'package:memo_dex_prototyp/screens/settings/account/password_setting_screen.dart';
import 'package:memo_dex_prototyp/screens/settings/configuration/language_setting_screen.dart';
import 'package:memo_dex_prototyp/screens/settings/datamanagement/trash_setting_screen.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/widgets/buttons/settings/setting_btn.dart';
import 'package:memo_dex_prototyp/widgets/dialogs/decision_message_box.dart';

import '../widgets/buttons/button.dart';
import '../widgets/buttons/settings/interface/switch_theme_btn.dart';
import '../widgets/dialogs/custom_snackbar.dart';
import '../widgets/text/headlines/headline_large.dart';
import '../widgets/text/headlines/headline_medium.dart';
import 'bottom_navigation_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  final storage = FlutterSecureStorage();

  @override
  void initState()
  {
    super.initState();
    showSnackbarInformation();
  }

  //TODO REDUNDANZ: muss noch ausgelagert werden
  void showSnackbarInformation() async
  {
    String? eMailWasUpdated = await storage.read(key: 'editEmail');
    String? passwordWasUpdated = await storage.read(key: 'editPassword');

    if (mounted)
    {
      if(eMailWasUpdated == "true")
      {
        CustomSnackbar.showSnackbar(
            context,
            Icons.check_rounded,
            "The E-Mail was successfully edited.",
            Colors.green,
            Duration(milliseconds: 500),
            Duration(milliseconds: 1500)
        );
        await storage.write(key: 'editEmail', value: "false");
      }
      if(passwordWasUpdated == "true")
      {
        CustomSnackbar.showSnackbar(
            context,
            Icons.check_rounded,
            "The password was successfully edited.",
            Colors.green,
            Duration(milliseconds: 500),
            Duration(milliseconds: 1500)
        );
        await storage.write(key: 'editPassword', value: "false");
      }
    }
  }

  Future<void>logoutUser() async
  {
    showDialog(
      context: context,
      builder: (BuildContext context)
      {
        return DecisionMessageBox(
          headline: "Ausloggen?",
          message: "Möchtest du dich wirklich ausloggen?",
          firstButtonText: "JA",
          secondButtonText: "NEIN",
          onPressed: (bool value)
          {
            if(value == true)
            {
              ApiClient(context).userApi.logoutUser();
            }else
            {
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,80,0,0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const HeadlineLarge(text: "Settings"),
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
                          const HeadlineMedium(text: "EDIT ACCOUNT"),
                        ],
                      ),
                      SizedBox(height: 15,),
                      SettingBtn(
                        buttonText: "E-Mail",
                        buttonBorderRadius: [10,10,0,0],
                        pushToContent: EmailSettingScreen(),
                      ),
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
                          const HeadlineMedium(text: "CONFIGURATION"),
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
                          const HeadlineMedium(text: "INTERFACE"),
                        ],
                      ),
                      SizedBox(height: 15,),
                      SettingBtn(
                        buttonText: "Button Color",
                        buttonBorderRadius: [10,10,0,0],
                        pushToContent: LanguageSettingScreen(),
                        showSwitch: true,
                      ),
                      SwitchBtn(
                        buttonText: "Theme Mode",
                        buttonBorderRadius: [0,0,10,10],
                      ),
                      SizedBox(height: 15,),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const HeadlineMedium(text: "DATAMANAGEMENT"),
                        ],
                      ),
                      SizedBox(height: 15,),
                      SettingBtn(
                          buttonText: "Trash",
                          buttonBorderRadius: [10,10,10,10],
                          pushToContent: TrashSettingScreen(),
                      ),
                      SizedBox(height: 15,),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const HeadlineMedium(text: "SUPPORT"),
                        ],
                      ),
                      SizedBox(height: 15,),
                      SettingBtn(
                        buttonText: "Contact",
                        buttonBorderRadius: [10,10,0,0],
                        pushToContent: TrashSettingScreen(),
                      ),
                      SettingBtn(
                        buttonText: "Donation",
                        buttonBorderRadius: [0,0,10,10],
                        pushToContent: TrashSettingScreen(),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                  Button(
                    text: "Logout",
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    borderColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).colorScheme.primary,
                    onPressed: logoutUser, // Übergeben Sie die Rückruffunktion anstelle sie sofort aufzurufen
                  ),
                  SizedBox(height: 30,),
                ],
              ),
            )
          )
        ],
      ),
    );
  }
}
