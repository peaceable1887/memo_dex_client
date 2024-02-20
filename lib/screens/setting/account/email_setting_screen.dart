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
                  const HeadlineLarge(text: "E-Mail"),
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
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.50),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(Icons.mail, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 28,),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _eMail.text = "";
                            });
                          },
                          child: Icon(
                            _eMail.text.isNotEmpty ? Icons.cancel : null,
                            color: Colors.white.withOpacity(0.50),
                          ),
                        ),// Icon hinzufügen
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurfaceVariant, // Ändern Sie hier die Farbe des Rahmens im Fokus
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.primary,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant, // Ändern Sie die Textfarbe auf Weiß
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
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
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.50),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(Icons.safety_check_rounded, color: Colors.white, size: 30,),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _eMailRepeat.text = "";
                            });
                          },
                          child: Icon(
                            _eMailRepeat.text.isNotEmpty ? Icons.cancel : null,
                            color: Colors.white.withOpacity(0.50),
                          ),
                        ),// Icon hinzufügen
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF8597A1),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, // Ändern Sie hier die Farbe des Rahmens im Fokus
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        filled: true,
                        fillColor: Color(0xFF33363F),
                      ),
                      style: TextStyle(
                        color: Colors.white, // Ändern Sie die Textfarbe auf Weiß
                        fontSize: 16,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(int.parse("0xFFE59113")),
                        minimumSize: Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        side: BorderSide(
                          color:  _isButtonEnabled
                              ? Color(int.parse("0xFF00324E"))
                              : Color(0xFF8597A1),
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
                                  ? Color(int.parse("0xFF00324E"))
                                  : Color(0xFF8597A1),
                              fontSize: 20,
                              fontFamily: "Inter",
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
