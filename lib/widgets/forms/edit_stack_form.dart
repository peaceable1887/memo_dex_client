import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import '../../services/local/file_handler.dart';
import '../../services/local/upload_to_database.dart';

class EditStackForm extends StatefulWidget {

  final dynamic stackId;
  final dynamic stackname;
  final dynamic color;

  const EditStackForm({Key? key, this.stackId, this.stackname, this.color}) : super(key: key);

  @override
  State<EditStackForm> createState() => _EditStackFormState();
}

class _EditStackFormState extends State<EditStackForm> {

  late Color newColor;
  late TextEditingController _stackname;
  bool _isButtonEnabled = false;
  final storage = FlutterSecureStorage();
  FileHandler fileHandler = FileHandler();
  late StreamSubscription subscription;
  bool online = true;

  @override
  void initState() {
    super.initState();
    _stackname = TextEditingController(text: widget.stackname);
    _stackname.addListener(updateButtonState);
    newColor = Color(int.parse("0xFF${widget.color}"));
    updateButtonState();
    _checkInternetConnection();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    async {
      _checkInternetConnection();
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);
      if(isConnected == true)
      {
        await UploadToDatabase(context).updateAllLocalCards(widget.stackId);
      }else{}

    });
  }

  void _checkInternetConnection() async
  {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

    if(isConnected == false)
    {
      online = false;
    } else
    {
      online = true;
    }
  }

  Future<void> updateStack()
  async {

    if(online)
    {
      await ApiClient(context).stackApi.updateStack(_stackname.text, "${newColor.value.toRadixString(16).substring(2)}", 0, widget.stackId);
    }else
    {
      await fileHandler.editItemById(
          "allStacks", "stack_id", widget.stackId,
          {"stackname":_stackname.text,"color":"${newColor.value.toRadixString(16).substring(2)}", "is_deleted": 0, "is_updated": 1});
    }

    storage.write(key: 'stackUpdated', value: "true");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StackContentScreen(stackId: widget.stackId),
      ),
    );

  }

  void updateButtonState() {
    setState(() {
      if(_stackname.text.isNotEmpty){
        _isButtonEnabled = true;
      }else{
        _isButtonEnabled = false;
      }
    });
  }
  Widget buildColorPicker(){
    return Container(
      height: 330,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(10),
      child: BlockPicker(
        pickerColor: newColor,
        onColorChanged: (color) => setState(() => this.newColor = color),
      ),
    );
  }

  void pickColor(BuildContext context){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color(0xFF00324E),
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(10.0)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  "Select a Color",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              buildColorPicker(),

              Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: const Size(300, 50),
                    backgroundColor: Color(0xFFE59113),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    "Select",
                    style: TextStyle(
                      color: Color(0xFF00324E),
                      fontSize: 20,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        )
    );
  }

  @override
  void dispose() {
    _stackname.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20,0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: TextFormField(
              controller: _stackname,
              decoration: InputDecoration(
                labelText: "Stackname",
                contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                labelStyle: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w600,
                ),
                prefixIcon: Icon(Icons.folder_outlined, color: Colors.white, size: 30,),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _stackname.text = "";
                    });
                  },
                  child: Icon(
                    _stackname.text.isNotEmpty ? Icons.cancel : null,
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
            child: Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF33363F), // Verwenden Sie die ausgewählte Farbe
                  minimumSize: Size(double.infinity, 55),
                  padding: EdgeInsets.fromLTRB(11, 0, 13, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  side: BorderSide(
                    color: Color(0xFF8597A1),
                    width: 2.0,
                  ),
                  elevation: 0,
                ),
                onPressed: () => pickColor(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.colorize,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "#${newColor.value.toRadixString(16).substring(2)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: newColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
// Container Login or Google Login
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Container(
              child:
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isButtonEnabled
                      ? Color(int.parse("0xFFE59113"))
                      : Color(0xFF8597A1),
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  side: BorderSide(
                    color: _isButtonEnabled
                        ? Color(int.parse("0xFFE59113"))
                        : Color(0xFF8597A1), // Button-Rahmenfarbe ändern, wenn nicht aktiviert
                    width: 2.0,
                  ),
                  elevation: 0,
                ),
                onPressed: _isButtonEnabled
                    ? updateStack
                    : null, // deaktivert den Button, wenn nicht aktiviert
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Update Stack",
                      style: TextStyle(
                        color: _isButtonEnabled
                            ? Color(int.parse("0xFF00324E"))
                            : Color(0xFF8597A1), // Textfarbe ändern, wenn nicht aktiviert
                        fontSize: 20,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),// Container Login or Google Login
        ],
      ),
    );
  }
}
