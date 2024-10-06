import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import '../../../services/api/api_client.dart';
import '../../../widgets/dialogs/edit_message_box.dart';
import '../../../widgets/dialogs/validation_message_box.dart';
import '../../../widgets/text/headlines/headline_large.dart';
import '../../../widgets/header/top_navigation_bar.dart';

class EmailSettingScreen extends StatefulWidget
{
  const EmailSettingScreen({super.key});

  @override
  State<EmailSettingScreen> createState() => _EmailSettingScreenState();
}

class _EmailSettingScreenState extends State<EmailSettingScreen>
{
  late TextEditingController _eMail;
  late TextEditingController _eMailRepeat;
  String _eMailText = "";
  bool _isButtonEnabled = false;
  final _storage = FlutterSecureStorage();

  @override
  void initState()
  {
    super.initState();
    loadEmail();
    _eMail = TextEditingController(text: _eMailText);
    _eMailRepeat = TextEditingController(text: "");
    _eMail.addListener(updateButtonState);
    _eMailRepeat.addListener(updateButtonState);
  }

  Future<void> loadEmail() async
  {
    try
    {
      List<dynamic> _eMailList = await ApiClient(context).userApi.getUserEmail();
      print("Usermail: ${_eMailList[0]["e_mail"]}");
      String _eMailAsString = _eMailList[0]["e_mail"].toString();

      setState(()
      {
        _eMailText = _eMailAsString;
      });

      _eMail = TextEditingController(text: _eMailText);

    }catch(error)
    {
      print("Can not get Usermail. Error: $error");
    }
  }

  Future<void> editEmail(String email, String emailRepeat) async
  {
    try
    {
      final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');

      if (emailRegExp.hasMatch(email))
      {
        if (email == emailRepeat && email.isNotEmpty)
        {
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return EditMessageBox(
                onEdit: () async
                {
                  print("E-Mail is successfully edited!");
                  await ApiClient(context).userApi.updateUserEmail(email);
                  _storage.write(key: 'editEmail', value: "true");

                  Navigator.of(context).pop();

                  //Route und ersetze das Widget
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNavigationScreen(index: 2,),
                    ),
                  );
                },
                boxMessage: "Bitte gebe dein Passwort ein um fortzufahren.",
              );
            },
          );
        } else
        {
          showDialog(
            context: context,
            builder: (BuildContext context)
            {
              return ValidationMessageBox(message: "E-Mail Adressen sind nicht identisch.");
            },
          );
        }
      } else
      {
        showDialog(
          context: context,
          builder: (BuildContext context)
          {
            return ValidationMessageBox(message: "Bitte eine gültige E-Mail Adresse angeben.");
          },
        );
      }
    }catch(error)
    {
      print("ERROR: $error");
    }
  }

  void updateButtonState()
  {
    setState(()
    {
      if(_eMail.text.isNotEmpty && _eMailRepeat.text.isNotEmpty)
      {
        _isButtonEnabled = true;
      }else{
        _isButtonEnabled = false;
      }
    });
  }

  @override
  void dispose()
  {
    editEmail(_eMail.text, _eMailRepeat.text);
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
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
                  HeadlineLarge(text: "E-Mail"),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20,15,20,0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: TextFormField(
                      maxLength: 800,
                      controller: _eMail,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: "E-Mail",
                        contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                        counterText: "",
                        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                        prefixIcon: Icon(
                          Icons.mail,
                          color: Theme.of(context).inputDecorationTheme.prefixIconColor,
                          size: 28,),
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextFormField(
                      maxLength: 800,
                      controller: _eMailRepeat,
                      maxLines: 3,
                      minLines: 1,
                      decoration: InputDecoration(
                        labelText: "E-Mail repeat",
                        contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                        counterText: "",
                        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
                        prefixIcon: Icon(
                          Icons.safety_check_rounded,
                          color: Theme.of(context).inputDecorationTheme.prefixIconColor,
                          size: 30,),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _eMailRepeat.text = "";
                            });
                          },
                          child: Icon(
                            _eMailRepeat.text.isNotEmpty ? Icons.cancel : null,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        side: BorderSide(
                          color:  _isButtonEnabled
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.tertiary,
                          width: 2.0,
                        ),
                        elevation: 0,
                      ),
                      onPressed: _isButtonEnabled
                          ? () {
                        setState(() {
                          editEmail(_eMail.text, _eMailRepeat.text);
                        });
                      }: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Update E-Mail",
                            style: TextStyle(
                              color:  _isButtonEnabled
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : Theme.of(context).colorScheme.tertiary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
