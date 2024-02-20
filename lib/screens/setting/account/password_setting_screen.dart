import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../services/api/api_client.dart';
import '../../../widgets/dialogs/edit_message_box.dart';
import '../../../widgets/dialogs/validation_message_box.dart';
import '../../../widgets/text/headlines/headline_large.dart';
import '../../../widgets/header/top_navigation_bar.dart';
import '../../bottom_navigation_screen.dart';

class PasswordSettingScreen extends StatefulWidget
{
  const PasswordSettingScreen({super.key});

  @override
  State<PasswordSettingScreen> createState() => _PasswordSettingScreenState();
}

class _PasswordSettingScreenState extends State<PasswordSettingScreen>
{
  late TextEditingController _password;
  late TextEditingController _passwordRepeat;
  bool _isPasswordVisible = false;
  bool _isButtonEnabled = false;
  final _storage = FlutterSecureStorage();

  @override
  void initState()
  {
    super.initState();
    _password = TextEditingController(text: "");
    _passwordRepeat = TextEditingController(text: "");
    _password.addListener(updateButtonState);
    _passwordRepeat.addListener(updateButtonState);
  }

  Future<void> updatePassword(String password, String passwordRepeat) async
  {
    try
    {
      if (password == passwordRepeat && password.isNotEmpty)
      {
        showDialog(
          context: context,
          builder: (BuildContext context)
          {
            return EditMessageBox(
              onEdit: () async
              {
                print("Password was successfully edited!");
                await ApiClient(context).userApi.updateUserPassword(password);
                _storage.write(key: 'editPassword', value: "true");

                Navigator.of(context).pop();

                //Route und ersetze das Widget
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationScreen(index: 2,),
                  ),
                );
              },
              boxMessage: "Bitte gebe dein bisheriges Passwort ein um fortzufahren.",
            );
          },
        );
      } else
      {
        showDialog(
          context: context,
          builder: (BuildContext context)
          {
            return ValidationMessageBox(message: "Die Passwörter sind nicht identisch.");
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
      if(_password.text.isNotEmpty && _passwordRepeat.text.isNotEmpty)
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
    updatePassword(_password.text, _passwordRepeat.text);
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
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
                  const HeadlineLarge(text: "Password"),
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
                      controller: _password,
                      obscureText: !_isPasswordVisible, // Passwort verschleiern
                      decoration: InputDecoration(
                        labelText: "Password",
                        contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.50),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(Icons.lock_rounded, color: Colors.white, size: 28,),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child: TextFormField(
                      controller: _passwordRepeat,
                      obscureText: !_isPasswordVisible, // Passwort verschleiern
                      decoration: InputDecoration(
                        labelText: "Password repeat",
                        contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                        labelStyle: TextStyle(
                          color: Colors.white.withOpacity(0.50),
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                        prefixIcon: Icon(Icons.safety_check_rounded, color: Colors.white, size: 28,),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          child: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
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
                          updatePassword(_password.text, _passwordRepeat.text);
                        });
                      }: null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Update Password",
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
