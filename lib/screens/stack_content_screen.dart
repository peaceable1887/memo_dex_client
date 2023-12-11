import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/add_card_screen.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import 'package:memo_dex_prototyp/screens/card_learning_screen.dart';
import 'package:memo_dex_prototyp/screens/edit_stack_screen.dart';
import 'package:memo_dex_prototyp/services/rest_services.dart';
import 'package:memo_dex_prototyp/widgets/stack_content_btn.dart';

import '../widgets/card_btn.dart';
import '../widgets/filters/filter_cards.dart';
import '../widgets/headline.dart';
import '../widgets/top_navigation_bar.dart';

class StackContentScreen extends StatefulWidget {

  final dynamic stackId;

  const StackContentScreen({Key? key, this.stackId}) : super(key: key);

  @override
  State<StackContentScreen> createState() => _StackContentScreenState();
}

class _StackContentScreenState extends State<StackContentScreen> {

  String stackname = "";
  String color = "";
  dynamic cardId;

  final List<Widget> cards = [];

  List<Widget> showButtons()
  {
    List<Widget> startLearningButtons = [
      StackContentBtn(
          iconColor: "FFFFFF",
          btnText: "Chronological",
          backgroundColor: "34A853",
          onPressed: CardLearningScreen(stackId: widget.stackId),
          icon: Icons.play_circle_outline_rounded
      ),
      StackContentBtn(
          iconColor: "FFFFFF",
          btnText: "Shuffled",
          backgroundColor: "E57435",
          onPressed: CardLearningScreen(stackId: widget.stackId, isMixed: true),
          icon: Icons.shuffle_rounded
      )
    ];

    return startLearningButtons;
  }

  Future<void> loadStack() async{
    try{
      final stack  = await RestServices(context).getStack(widget.stackId);

      setState((){
        stackname = stack[0]["stackname"];
        color = stack[0]["color"];
      });

    }catch (error){
      print('Fehler beim Laden der Daten: $error');
    }
  }

  Future<void> loadCards() async{
    try{
      final cardsData = await RestServices(context).getAllCards(widget.stackId);

      for(var card in cardsData){
        if(card['is_deleted'] == 0) {
          cards.add(CardBtn(btnText: card["question"], stackId: widget.stackId, cardId: card["card_id"],));
        }
      }
      // Widget wird aktualisiert nnach dem Laden der Daten.
      if(mounted){
        setState((){
        });
      }
    }catch(error){
      print('Fehler beim Laden der Daten: $error');
    }
  }

  void pushToAddCard(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCardScreen(stackId: widget.stackId, stackname: stackname),
      ),
    );
  }

  void pushToEditStack(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStackScreen(stackId: widget.stackId, stackname: stackname, color: color),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadStack();
    loadCards();
    showButtons();
  }

  @override
  void dispose() {
    super.initState();
    loadStack();
    loadCards();
    showButtons();
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
                      btnText: "Home",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,15,0),
                  child: Container(
                    width: 80,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: pushToAddCard,
                            child: Icon(
                              Icons.add_rounded,
                              size: 38.0,
                              color: Colors.white,
                            ), // Icon als klickbares Element
                          ),
                          InkWell(
                            onTap: pushToEditStack,
                            child: Icon(
                              Icons.edit_outlined,
                              size: 32.0,
                              color: Colors.white,
                            ), // Icon als klickbares Element
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: Headline(
                text: stackname
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,40,0,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "START LEARNING",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200, // Feste Höhe von 200
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 2.3),
              ),
              itemBuilder: (context, index) {
                return showButtons()[index];
              },
              itemCount: showButtons().length,
            ),
          ),
          FilterCards(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                  return cards[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}
