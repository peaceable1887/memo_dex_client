import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';

class EditMessageBox extends StatefulWidget
{
  final Future<void> Function() onEdit;
  final String boxMessage;

  const EditMessageBox({
    super.key,
    required this.onEdit,
    required this.boxMessage});

  @override
  State<EditMessageBox> createState() => _EditMessageBoxState();
}

class _EditMessageBoxState extends State<EditMessageBox>
{
  late TextEditingController _password;
  bool _isPasswordVisible = false;
  bool _isButtonEnabled = false;
  bool _showValidationMessage = false;

  @override
  void initState()
  {
    super.initState();
    _password = TextEditingController(text: "");
    _password.addListener(updateButtonState);
  }

  void updateButtonState()
  {
    setState(()
    {
      if(_password.text.isNotEmpty)
      {
        _isButtonEnabled = true;
      }else{
        _isButtonEnabled = false;
      }
    });
  }

  Future<void> verifyPassword() async
  {
      bool isPasswordVerified = await ApiClient(context).userApi.verifyUserPassword(_password.text);

      if(isPasswordVerified == true)
      {
        widget.onEdit();
      }else
      {
        setState(()
        {
          _showValidationMessage = true;
        });
      }

  }

  @override
  Widget build(BuildContext context)
  {
    return Dialog(
      backgroundColor: Color(0xFF00324E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width/1.8,
        height: 380.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0,30,0,0),
              child: Column(
                children: [
                  Icon(
                    Icons.safety_check_rounded,
                    color: Colors.white,
                    size: 90,
                  ),
                  SizedBox(height: 0),
                  Text(
                    "Überprüfung",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(8,0,8,0),
              child: Text(
                widget.boxMessage,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "Inter",
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
              child: TextFormField(
                controller: _password,
                obscureText: !_isPasswordVisible, // Passwort verschleiern
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  labelStyle: TextStyle(
                    color: Colors.black.withOpacity(0.50),
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    child: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Colors.black.withOpacity(0.50),
                    ),
                  ),// Icon hinzufügen
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.50),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: TextStyle(
                  color: Colors.black.withOpacity(0.50), // Ändern Sie die Textfarbe auf Weiß
                  fontSize: 12,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
              child: Container(
                child: _showValidationMessage ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline_rounded,
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(width: 5,),
                    Text(
                      "Entered the wrong password.",
                      style: TextStyle(
                        color: Colors.red, // Ändern Sie die Textfarbe auf Weiß
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ) : Row(
                  children: [
                    Text(""),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius:  BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft:  Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: TextButton(
                      onPressed: _isButtonEnabled ? () async
                      {
                        await verifyPassword();
                      }
                      : null,
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: Text(
                        'FORTFAHREN',
                        style: TextStyle(
                          decoration:_isButtonEnabled ? null : TextDecoration.lineThrough,
                          color: Colors.green,
                          fontSize: 18,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Schließe das Dialogfenster
                      },
                      child: Text(
                        'ABBRECHEN',
                        style: TextStyle(
                          color: Color(0xFF8597A1),
                          fontSize: 18,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
