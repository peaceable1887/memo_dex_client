import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/single_card_screen.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';

import '../services/rest_services.dart';
import '../widgets/delete_message_box.dart';
import '../widgets/headline.dart';
import '../widgets/top_navigation_bar.dart';
import 'bottom_navigation_screen.dart';

class EditCardScreen extends StatefulWidget {

  final dynamic stackId;
  final dynamic cardId;
  final String stackname;
  final String question;
  final String answer;

  const EditCardScreen({Key? key, this.stackId, required this.stackname, required this.question, required this.answer, this.cardId}) : super(key: key);

  @override
  State<EditCardScreen> createState() => _EditCardScreenState();
}

class _EditCardScreenState extends State<EditCardScreen> {

  late TextEditingController _question;
  late TextEditingController _answer;
  bool _isButtonEnabled = false;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    _question = TextEditingController(text: widget.question);
    _answer = TextEditingController(text: widget.answer);
    _question.addListener(updateButtonState);
    _answer.addListener(updateButtonState);
    updateButtonState();
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

  void showDeleteMessageBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteMessageBox(
          onDelete: () async {
            await RestServices(context).updateCard(_question.text, _answer.text, 1, 0, widget.cardId,);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StackContentScreen(stackId: widget.stackId),
              ),
            );
          },
          boxMessage: "Möchtest du die Karte wirklich löschen?",
        );
      },
    );
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
                            builder: (context) => SingleCardScreen(stackId: widget.stackId, cardId: widget.cardId,),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,15,10),
                  child: Container(
                    child: InkWell(
                      onTap: showDeleteMessageBox,
                      child: Icon(
                        Icons.delete_forever_rounded,
                        size: 35.0,
                        color: Colors.white,
                      ), // Icon als klickbares Element
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: Headline(
                text: "Edit Card"
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
                        ? () {
                      setState(() {
                        RestServices(context).updateCard(_question.text, _answer.text, 0, 0, widget.cardId);
                        storage.write(key: 'editCard', value: "true");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SingleCardScreen(stackId: widget.stackId, cardId: widget.cardId),
                          ),
                        );
                      });
                    }
                        : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Update Card",
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
