import 'package:flutter/material.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';
import 'package:carousel_slider/carousel_slider.dart'; // https://pub.dev/packages/carousel_slider

import '../services/rest_services.dart';
import '../widgets/headline.dart';
import '../widgets/learning_card.dart';
import '../widgets/top_navigation_bar.dart';

class CardLearningScreen extends StatefulWidget {

  final dynamic stackId;
  final bool? isMixed;

  const CardLearningScreen({Key? key, this.stackId, this.isMixed}) : super(key: key);

  @override
  State<CardLearningScreen> createState() => _CardLearningScreenState();
}

class _CardLearningScreenState extends State<CardLearningScreen> with TickerProviderStateMixin{

  late AnimationController controller;
  int activeIndex = 0;
  final List<dynamic> indexCards = [];
  bool emptyCards = false;
  String stackname = "";

  late LearningCard learningCard;

  @override
  void initState() {

    loadStack();
    loadCards();
    super.initState();
  }

  @override
  void dispose() {
    loadStack();
    loadCards();
    super.dispose();
  }

  Future<void> loadStack() async {
    try {
      final stack  = await RestServices(context).getStack(widget.stackId);

      setState(() {
        stackname = stack[0]["stackname"];
      });

    } catch (error) {
      print('Fehler beim Laden der Daten: $error');
    }
  }

  Future<void> loadCards() async {
    try {
      final cardsData = await RestServices(context).getAllCards(widget.stackId);

      for (var card in cardsData) {
        if(card["remember"] == 0 && card["is_deleted"] == 0)
        {
          LearningCard lCard = LearningCard(question: card["question"], answer: card["answer"], cardIndex: card["card_id"]);
          indexCards.add(lCard);
        }
      }
      if(widget.isMixed == true)
      {
        indexCards.shuffle();
      }else{}
      // Widget wird aktualisiert nnach dem Laden der Daten.
      if (mounted) {
        setState(() {

        });
      }
    } catch (error) {
      print('Fehler beim Laden der Daten: $error');
    }
  }

  Widget buildIndexCard(Widget indexCard, int index) => Container(
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
                  text: stackname,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,40,20,0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        minHeight: 10,
                        backgroundColor: Colors.white,
                        color: Color(0xFFE59113),
                        value: (() {
                          double progressValue = (activeIndex + 1) / indexCards.length;
                          if (progressValue.isNaN || progressValue.isInfinite) {
                            progressValue = 0.0;
                            emptyCards = true;
                          }
                          return progressValue;
                        })(),
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,6,1,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${activeIndex + 1}",
                            style: TextStyle(
                              color: Color(0xFFE59113),
                              fontSize: 14,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                              " / ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                              "${indexCards.length}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w700,
                              ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              child: CarouselSlider.builder(
                itemCount: indexCards.length,
                  itemBuilder: (context, index, realIndex)
                  {
                    final indexCard = indexCards[index];
                    return buildIndexCard(indexCard, index);
                  },
                  options: CarouselOptions( //hier kann man die eigenschaften des slider manipulieren
                    height: 500,
                    enableInfiniteScroll: false,
                    scrollPhysics: RightBlockedScrollPhysics(),
                    autoPlayInterval: Duration(seconds: 1),
                    onPageChanged: (index, reason) => setState(()
                    {
                      activeIndex = index;
                      print(index);
                    }
                    ),
                  ),
              ),
            ),
          ],
        ),
    );
  }
}
