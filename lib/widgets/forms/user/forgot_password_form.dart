import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/user/forgot_passwort_screen.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/utils/divide_painter.dart';
import 'package:memo_dex_prototyp/widgets/dialogs/validation_message_box.dart';

import '../../../screens/welcome_screen.dart';
import '../../buttons/button.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {

  late TextEditingController _eMail;
  bool _isButtonEnabled = false;
  final storage = FlutterSecureStorage();

  @override
  void initState()
  {
    super.initState();
    _eMail = TextEditingController();
    _eMail.addListener(updateButtonState);
  }


  void updateButtonState() {
    setState(() {
      if(_eMail.text.isNotEmpty){
        _isButtonEnabled = true;
      }else{
        _isButtonEnabled = false;
      }
    });
  }
  void validateForm(String email) async
  {
    final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

    if(isConnected == false)
    {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ValidationMessageBox(message: "Keine Internetverbidnung vorhanden.");
        },
      );

    }else
    {
      if (emailRegExp.hasMatch(email))
      {
        await ApiClient(context).userApi.forgotPassword(email);

      }else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Bitte eine gültige E-Mail Adresse angeben.");
          },
        );
      }
    }
  }

  @override
  void dispose() {
    _eMail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20,0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: Center(
              child: const Text(
                "No worries, we will send you reset instructions.",
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
            child: TextFormField(
              controller: _eMail,
              decoration: InputDecoration(
                labelText: "E-Mail",
                contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                prefixIcon: Icon(
                  Icons.email,
                  color: Theme.of(context).inputDecorationTheme.prefixIconColor,
                  size: 30,),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _eMail.text = "";
                    });
                  },
                  child: Icon(
                    _eMail.text.isNotEmpty ? Icons.cancel : null,
                    color: Theme.of(context).inputDecorationTheme.suffixIconColor,
                  ),
                ),// Icon hinzufügen
                enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              ),
              style: Theme.of(context).inputDecorationTheme.floatingLabelStyle,
            ),
          ),
          Container(
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.tertiary,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    side: BorderSide(
                      color: _isButtonEnabled
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.tertiary,
                      width: 2.0,
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isButtonEnabled
                      ? () {
                    setState(() {
                      validateForm(_eMail.text);
                    });
                  }
                      : null, // Deaktivieren Sie den Button, wenn nicht aktiviert
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Reset password",
                        style: TextStyle(
                          color: _isButtonEnabled
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Theme.of(context).colorScheme.tertiary, // Textfarbe ändern, wenn nicht aktiviert
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),// Container Login or Google Login
        ],
      ),
    );
  }
}
