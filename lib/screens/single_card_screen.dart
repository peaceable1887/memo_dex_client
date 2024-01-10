import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';

import '../services/rest_services.dart';
import '../widgets/headline.dart';
import '../widgets/learning_card.dart';
import '../widgets/top_navigation_bar.dart';
import 'edit_card_screen.dart';

class SingleCardScreen extends StatefulWidget {

  final dynamic stackId;
  final dynamic cardId;

  const SingleCardScreen({Key? key, this.stackId, this.cardId}) : super(key: key);

  @override
  State<SingleCardScreen> createState() => _SingleCardScreenState();
}

class _SingleCardScreenState extends State<SingleCardScreen> {

  String stackname = "";
  late AnimationController controller;
  int activeIndex = 0;
  final List<dynamic> indexCards = [];
  bool isNoticed = false;
  String question = "";
  String answer = "";

  @override
  void initState() {
    loadStack();
    loadCard();
    super.initState();
  }

  @override
  void dispose() {
    loadStack();
    loadCard();
    super.dispose();
  }

  Future<void> loadStack() async {
    try {
      final stack = await RestServices(context).getStack(widget.stackId);

      setState(() {
        stackname = stack[0]["stackname"];
      });
    } catch (error) {
      print('Fehler beim Laden der Daten: $error');
    }
  }

  Future<void> loadCard() async {
    try {
      final cardsData = await RestServices(context).getCard(widget.cardId);

      for (var card in cardsData) {
        indexCards.add(
            LearningCard(
              question: card["question"],
              answer: card["answer"],
              cardIndex: card["card_id"],
              onClicked: (bool val){},
              isNoticed: card["remember"],
              isIndividual: true,
            ));
      }

      // Widget wird aktualisiert nnach dem Laden der Daten.
      if (mounted) {
        setState(() {
          question = cardsData[0]["question"];
          answer = cardsData[0]["answer"];
          if(cardsData[0]["remember"] == 1)
          {
            isNoticed = true;
            print(isNoticed);
          }
        });
      }
    } catch (error) {
      print('Fehler beim Laden der Daten: $error');
    }
  }

  void pushToEditCard(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCardScreen(stackId: widget.stackId, cardId: widget.cardId, stackname: stackname, question: question, answer: answer,),
      ),
    );
  }

  Widget buildIndexCard(Widget indexCard, int index) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: indexCard,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00324E),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
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
                            builder: (context) =>
                                StackContentScreen(stackId: widget.stackId),
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
                      padding: const EdgeInsets.fromLTRB(0,0,3,10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: pushToEditCard,
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
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Headline(
              text: stackname,
            ),
          ),
          CarouselSlider.builder(
            itemCount: indexCards.length,
            itemBuilder: (context, index, realIndex) {
              final indexCard = indexCards[index];

              return buildIndexCard(indexCard, index);
            },
            options: CarouselOptions( //hier kann man die eigenschaften des slider manipulieren
              height: 500,
              enableInfiniteScroll: false,
              autoPlayInterval: Duration(seconds: 1),
              onPageChanged: (index, reason) =>
                  setState(() => activeIndex = index),
            ),
          ),
        ],
      ),
    );
  }
}
