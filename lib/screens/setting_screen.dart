import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/settings/account/email_setting_screen.dart';
import 'package:memo_dex_prototyp/screens/settings/account/password_setting_screen.dart';
import 'package:memo_dex_prototyp/screens/settings/configuration/language_setting_screen.dart';
import 'package:memo_dex_prototyp/screens/settings/datamanagement/trash_setting_screen.dart';
import 'package:memo_dex_prototyp/screens/settings/support/contact_setting_screen.dart';
import 'package:memo_dex_prototyp/screens/settings/support/donation_setting_screen.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/widgets/buttons/settings/configuration/switch_disable_autocorrect_btn.dart';
import 'package:memo_dex_prototyp/widgets/buttons/settings/setting_btn.dart';
import 'package:memo_dex_prototyp/widgets/dialogs/decision_message_box.dart';

import '../widgets/buttons/button.dart';
import '../widgets/buttons/settings/interface/switch_button_color_btn.dart';
import '../widgets/buttons/settings/interface/switch_theme_btn.dart';
import '../widgets/dialogs/custom_snackbar.dart';
import '../widgets/text/headlines/headline_large.dart';
import '../widgets/text/headlines/headline_medium.dart';

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
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            centerTitle: true,
            expandedHeight: 130,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              expandedTitleScale: 2,
              titlePadding: EdgeInsets.only(bottom: 15),
              centerTitle: true,
              title: const HeadlineLarge(text: "Settings"),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.fromLTRB(20,20,20,0),
                child: Column(
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,0,20,0),
                child: Column(
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
                    SwitchDisableAutocorrectBtn(
                      buttonText: "Disable Autocorrect",
                      buttonBorderRadius: [0,0,10,10],
                    ),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,0,20,0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const HeadlineMedium(text: "INTERFACE"),
                      ],
                    ),
                    SizedBox(height: 15,),
                    SwitchButtonColorBtn
                      (
                      buttonText: "Button Color",
                      buttonBorderRadius: [10,10,0,0],
                    ),
                    SwitchThemeBtn(
                      buttonText: "Theme Mode",
                      buttonBorderRadius: [0,0,10,10],
                    ),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,0,20,0),
                child: Column(
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
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,0,20,0),
                child: Column(
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
                      pushToContent: ContactSettingScreen(),
                    ),
                    SettingBtn(
                      buttonText: "Donation",
                      buttonBorderRadius: [0,0,10,10],
                      pushToContent: DonationSettingScreen(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.fromLTRB(20,0,20,0),
                child: Button(
                  text: "Logout",
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  borderColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).colorScheme.primary,
                  onPressed: logoutUser, // Übergeben Sie die Rückruffunktion anstelle sie sofort aufzurufen
                ),
              ),
              SizedBox(height: 30,)
            ]),
          ),
        ],
      ),
    );
  }
}
