import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/services/local/write_to_device_storage.dart';

import '../services/local/file_handler.dart';
import '../widgets/header/headline.dart';
import '../widgets/header/top_navigation_bar.dart';
import 'bottom_navigation_screen.dart';

class AddCardScreen extends StatefulWidget {

  final dynamic stackId;
  final String stackname;

  const AddCardScreen({Key? key, this.stackId, required this.stackname}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {

  late TextEditingController _question;
  late TextEditingController _answer;
  bool _isButtonEnabled = false;
  final storage = FlutterSecureStorage();
  FileHandler fileHandler = FileHandler();
  late StreamSubscription subscription;
  bool online = true;

  @override
  void initState() {
    super.initState();
    _question = TextEditingController();
    _answer = TextEditingController();
    _question.addListener(updateButtonState);
    _answer.addListener(updateButtonState);
    _checkInternetConnection();

    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    {

      _checkInternetConnection();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => BottomNavigationScreen()),
      );
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
      if(_question.text.isNotEmpty && _answer.text.isNotEmpty){
        _isButtonEnabled = true;
      }else{
        _isButtonEnabled = false;
      }
    });
  }

  @override
  void dispose() {
    _question.dispose();
    _answer.dispose();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00324E),
      body: Column(
        mainAxisSize: MainAxisSize.min,
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
                      btnText: "Back",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StackContentScreen(stackId: widget.stackId),
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
            child: Headline(
                text: "Add Card"
            ),
          ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 50, 20,0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: TextFormField(
                        maxLength: 800,
                        controller: _question,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          labelText: "Question",
                          contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                          counterText: "",
                          labelStyle: TextStyle(
                            color: Colors.white.withOpacity(0.50),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: Icon(Icons.question_mark_rounded, color: Colors.white, size: 28,),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _question.text = "";
                              });
                            },
                            child: Icon(
                              _question.text.isNotEmpty ? Icons.cancel : null,
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
                        maxLength: 800,
                        controller: _answer,
                        maxLines: 3,
                        minLines: 1,
                        decoration: InputDecoration(
                          labelText: "Answer",
                          contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 20),
                          counterText: "",
                          labelStyle: TextStyle(
                            color: Colors.white.withOpacity(0.50),
                            fontSize: 16,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: Icon(Icons.question_answer_outlined, color: Colors.white, size: 30,),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _answer.text = "";
                              });
                            },
                            child: Icon(
                              _answer.text.isNotEmpty ? Icons.cancel : null,
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
                      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
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
                              ? () async
                          {
                            //storage wird im stack_content_screen in der funktion loadCards gesetzt
                            String? tempCardIndex = await storage.read(key: 'tempCardIndex');
                            print("onlinestatis: ${online}");

                            if(online == true)
                            {
                              await ApiClient(context).cardApi.addCard(_question.text, _answer.text, 0, 0, widget.stackId);
                            }else
                            {
                              await WriteToDeviceStorage().addCard(
                                  question: _question.text,
                                  answer: _answer.text,
                                  stackId: widget.stackId,
                                  fileName: "allCards",
                                  tempCardIndex: tempCardIndex,
                              );
                            }
                            //zeige die Snackbar an
                            storage.write(key: 'addCard', value: "true");

                            print(widget.stackId);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StackContentScreen(stackId: widget.stackId),
                              ),
                            );
                          }
                              : null,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Add Card",
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
        ],
      ),
    );
  }
}
