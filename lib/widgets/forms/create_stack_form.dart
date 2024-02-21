import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import '../../screens/bottom_navigation_screen.dart';
import '../../services/local/file_handler.dart';
import '../../services/local/write_to_device_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateStackForm extends StatefulWidget {
  const CreateStackForm({Key? key}) : super(key: key);

  @override
  State<CreateStackForm> createState() => _CreateStackFormState();
}

class _CreateStackFormState extends State<CreateStackForm> {

  Color color = Colors.red;
  late TextEditingController _stackname;
  bool _isButtonEnabled = false;
  final storage = FlutterSecureStorage();
  FileHandler fileHandler = FileHandler();
  late StreamSubscription subscription;
  bool online = true;

  @override
  void initState() {
    super.initState();
    _stackname = TextEditingController();
    _stackname.addListener(updateButtonState);
    _checkInternetConnection();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    {
      _checkInternetConnection();
    });
  }

  void _checkInternetConnection() async
  {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

    if(isConnected == false)
    {
      online = false;
      print(online);
    } else
    {
      online = true;
      print(online);
    }
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
        color: Colors.transparent,
      ),
      padding: EdgeInsets.all(10),
      child: BlockPicker(
        pickerColor: color,
        onColorChanged: (color) => setState(() => this.color = color),
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
                Icon(
                  Icons.color_lens_rounded,
                  size: 30.0,
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Text(
                      "Select a Color",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
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
    _checkInternetConnection();
    subscription.cancel();
    _stackname.dispose();
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
              maxLength: 100,
              controller: _stackname,
              decoration: InputDecoration(
                labelText: "Stackname",
                contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                counterText: "",
                labelStyle: Theme.of(context).textTheme.labelMedium,
                prefixIcon: Icon(
                  Icons.folder_outlined,
                  color: Theme.of(context).inputDecorationTheme.iconColor,
                  size: 30,),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _stackname.text = "";
                    });
                  },
                  child: Icon(
                    _stackname.text.isNotEmpty ? Icons.cancel : null,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),// Icon hinzufügen
                enabledBorder: Theme.of(context).inputDecorationTheme.enabledBorder,
                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
            child: Container(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary, // Verwenden Sie die ausgewählte Farbe
                  minimumSize: Size(double.infinity, 55),
                  padding: EdgeInsets.fromLTRB(11, 0, 13, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.surface,
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
                          color: Theme.of(context).inputDecorationTheme.iconColor,
                          size: 30,
                        ),
                        SizedBox(width: 8),
                        //TODO ggf noch in ThemeData auslagern
                        Text(
                          "#${color.value.toRadixString(16).substring(2)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                    Container(
                      width: 22, // Ändern Sie die Breite nach Bedarf
                      height: 22, // Ändern Sie die Höhe nach Bedarf
                      decoration: BoxDecoration(
                        color: color,
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
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.tertiary,
                    minimumSize: Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    side: BorderSide(
                      color: _isButtonEnabled
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.tertiary, // Button-Rahmenfarbe ändern, wenn nicht aktiviert
                      width: 2.0,
                    ),
                    elevation: 0,
                  ),
                  onPressed: _isButtonEnabled
                      ? () async
                      {
                        if(online == true)
                        {
                          await ApiClient(context).stackApi.createStack(_stackname.text, "${color.value.toRadixString(16).substring(2)}", 0);
                        }else
                        {
                          await storage.read(key: 'user_id').then((String? value)
                          async {
                            if (value != null)
                            {
                              int userId;
                              userId = int.tryParse(value) ?? 0;

                              await WriteToDeviceStorage().addStack(
                                  stackname: _stackname.text,
                                  color: "${color.value.toRadixString(16).substring(2)}",
                                  userId: userId,
                                  fileName: "allStacks");

                            } else {}
                          });
                        }
                        //zeige die Snackbar an
                        storage.write(key: 'stackCreated', value: "true");

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen(),
                          ),
                        );
                      }
                      : null, // deaktivert den Button, wenn nicht aktiviert
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create Stack",
                        style: TextStyle(
                          color: _isButtonEnabled
                              ? Theme.of(context).scaffoldBackgroundColor
                              : Theme.of(context).colorScheme.tertiary, // Textfarbe ändern, wenn nicht aktiviert
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
