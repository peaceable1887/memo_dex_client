import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';

import '../services/rest_services.dart';
import '../widgets/headline.dart';
import '../widgets/top_navigation_bar.dart';

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

  @override
  void initState() {
    _question = TextEditingController();
    _answer = TextEditingController();
    _question.addListener(updateButtonState);
    _answer.addListener(updateButtonState);
    super.initState();
  }

  @override
  void dispose() {
    _question.dispose();
    _answer.dispose();
    super.dispose();
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
                        Navigator.push(
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
                              ? () {
                            setState(() {
                              RestServices(context).addCard(_question.text, _answer.text, widget.stackId);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StackContentScreen(stackId: widget.stackId),
                                ),
                              );
                            });
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
