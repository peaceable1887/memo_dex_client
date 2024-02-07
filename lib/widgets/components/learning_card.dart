import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';

import '../../services/local/file_handler.dart';
import '../dialogs/custom_snackbar.dart';

class LearningCard extends StatefulWidget {

  final dynamic stackId;
  final int cardIndex;
  final String question;
  final String answer;
  final Function(bool) onClicked;
  final int isNoticed;
  final bool isIndividual;

  const LearningCard({Key? key,
    required this.question,
    required this.answer,
    required this.cardIndex,
    required this.onClicked,
    required this.isIndividual,
    required this.isNoticed,
    this.stackId}) : super(key: key);

  @override
  State<LearningCard> createState() => _LearningCardState();

}

class _LearningCardState extends State<LearningCard> with TickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;
  AnimationStatus animationStatus = AnimationStatus.dismissed;
  bool isCardTurned = false;
  bool showAnswerBtns = true;
  bool isCardNoticed = false;
  bool online = true;
  FileHandler fileHandler = FileHandler();
  late StreamSubscription subscription;

  @override
  void initState()
  {
    super.initState();
    print("widget.cardIndex: ${widget.cardIndex}");
    setLightIcon();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    animation = Tween(end: 1.0, begin: 0.0).animate(controller);
    animation.addListener(()
    {
      setState(() {});
    });
    animation.addStatusListener((status)
    {
      animationStatus = status;
    });
    _checkInternetConnection();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    {
      _checkInternetConnection();
    });
  }

  @override
  void didUpdateWidget(covariant LearningCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Überprüfe, ob die Daten geändert wurden, bevor du sie aktualisierst
    if (widget.isNoticed != oldWidget.isNoticed) {
      setLightIcon();
      cardNoted();
    }
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

  void setLightIcon()
  {
    setState(()
    {
      if(widget.isNoticed == 1)
      {
        isCardNoticed = true;
      }else{
        isCardNoticed = false;
      }
    });
  }

  void cardNotedOffline()
  {
    setState(() {
      if(isCardNoticed == false)
      {
        fileHandler.editItemById(
            "allStacks", "stack_id", widget.stackId,
            {"is_updated": 1});

        fileHandler.editItemById(
            "allCards", "card_id", widget.cardIndex,
            {"remember":1, "is_updated": 1});

        isCardNoticed = true;
        CustomSnackbar.showSnackbar(
            context,
            Icons.warning_amber_rounded,
            "You marked the card as memorized.",
            Color(0xFFE59113),
            Duration(seconds: 0),
            Duration(milliseconds: 1500)
        );
      }else
      {
        fileHandler.editItemById(
            "allStacks", "stack_id", widget.stackId,
            {"is_updated": 1});

        fileHandler.editItemById(
            "allCards", "card_id", widget.cardIndex,
            {"remember":0, "is_updated": 1});

        isCardNoticed = false;
        CustomSnackbar.showSnackbar(
            context,
            Icons.warning_amber_rounded,
            "You marked the card as unmemorized",
            Color(0xFFE59113),
            Duration(seconds: 0),
            Duration(milliseconds: 1500)
        );
      }
    });
  }

  void cardNoted()
  {
    setState(()
    {
      if(isCardNoticed == false)
      {
        ApiClient(context).cardApi.updateCard(widget.question, widget.answer, 0, 1, widget.cardIndex);
        isCardNoticed = true;
        CustomSnackbar.showSnackbar(
            context,
            Icons.warning_amber_rounded,
            "You marked the card as memorized.",
            Color(0xFFE59113),
            Duration(seconds: 0),
            Duration(milliseconds: 1500)
        );
      }else
      {
        ApiClient(context).cardApi.updateCard(widget.question, widget.answer, 0, 0, widget.cardIndex);
        isCardNoticed = false;
        CustomSnackbar.showSnackbar(
            context,
            Icons.warning_amber_rounded,
            "You marked the card as unmemorized",
            Color(0xFFE59113),
            Duration(seconds: 0),
            Duration(milliseconds: 1500)
        );
      }
    });
  }

  Future<void> sendAnswer(answeredCorrectly)
  async
  {
    if(online)
    {
      setState(()
      {
        if(answeredCorrectly == false)
        {
          ApiClient(context).cardApi.answeredIncorrectly(widget.cardIndex);
        }else
        {
          ApiClient(context).cardApi.answeredCorrectly(widget.cardIndex);
        }
      });
    }else
    {
      String localCardContent = await fileHandler.readJsonFromLocalFile("allCards");

      if (localCardContent.isNotEmpty)
      {
        List<dynamic> cardContent = jsonDecode(localCardContent);

        for (var card in cardContent)
        {
          if (card['card_id'] == widget.cardIndex)
          {
            if (card['is_deleted'] == 0)
            {
              setState(() {
                if(answeredCorrectly == false)
                {
                  print(card);
                  print("IncorrectAnswer: ${card['answered_incorrectly']}");
                  print("widget.cardIndex: ${widget.cardIndex}");
                  print("cardid: ${card["card_id"]}");

                  fileHandler.editItemById(
                      "allStacks", "stack_id", widget.stackId,
                      {"is_updated": 1});

                  fileHandler.editItemById(
                      "allCards", "card_id", widget.cardIndex,
                      {"answered_incorrectly": card['answered_incorrectly'] + 1, "is_updated": 1});
                }else
                {
                  print(card);
                  print("CorrectAnswer: ${card['answered_correctly']}");
                  print("widget.cardIndex: ${widget.cardIndex}");
                  print("cardid: ${card["card_id"]}");


                  fileHandler.editItemById(
                      "allStacks", "stack_id", widget.stackId,
                      {"is_updated": 1});

                  fileHandler.editItemById(
                      "allCards", "card_id", widget.cardIndex,
                      {"answered_correctly": card['answered_correctly'] + 1, "is_updated": 1});
                }

              });
            }
          }
        }
      }
    }
  }

  Widget showText(String text)
  {
    if(text.length >= 200)
    {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: "Inter",
          fontWeight: FontWeight.w500,
        ),
      );
    }
    {
      return Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
          fontFamily: "Inter",
          fontWeight: FontWeight.w500,
          ),
        );
    }
  }

  @override
  void dispose()
  {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 30,
            ),
            Transform(
              alignment: FractionalOffset.center, //flip in der mitte der karte
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0010)
                ..rotateY((animation.value < 0.5) ? pi * animation.value : (pi * ( 1+ animation.value))), //nochmal ansehen wie genau der Teil funktioniert
              child: Card(
                color: Colors.transparent,
                child: animation.value <= 0.5
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width/1.15,
                      height: MediaQuery.of(context).size.height/2.085,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.35,
                              height: 60,
                              child: Container(),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width/1.35,
                            height: MediaQuery.of(context).size.height/2.8,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                child: showText(widget.question)
                              ),
                            ),
                          ),
                          ],
                        ),
                      ),
                    )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width/1.35,
                    height: MediaQuery.of(context).size.height/2.085,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 10, 0),
                                child: InkWell(
                                  onTap: online ? cardNoted : cardNotedOffline,
                                  child: isCardNoticed ? Icon(
                                    Icons.lightbulb_rounded,
                                    size: 32.0,
                                    color: Color(0xFFE59113),
                                  ) : Icon(
                                    Icons.lightbulb_outline_rounded,
                                    size: 32.0,
                                    color: Color(0xFFE59113),
                                  ), // Icon als klickbares Element
                                ),
                              ),
                            ],
                          )
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width/1.35,
                          height: MediaQuery.of(context).size.height/2.8,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: showText(widget.answer)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                )
              ),
            const SizedBox(
              height: 30,
            ),
            animation.value <= 0.5 ? //muss in eine eigene klasse ausgelagert werden !
            Container(
              width: 75,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: Offset(1,5),
                    ),
                  ],
              ),
              child: IconButton(
                icon: const Icon(Icons.redo_rounded),
                color: Colors.white,
                iconSize: 40,
                onPressed: (){
                  if(animationStatus == AnimationStatus.dismissed){
                    controller.forward();
                  }else{
                    controller.reverse();
                  }
                },
              ),
            ) :
            !widget.isIndividual ? showAnswerBtns ? Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 75,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: Offset(1,5),
                          ),
                        ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_rounded),
                          color: Colors.white,
                          iconSize: 40,
                          onPressed: ()
                          {
                            setState(() {
                              widget.onClicked(true);
                              sendAnswer(true);
                              isCardTurned = true;
                              showAnswerBtns = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 75,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: Offset(1,5),
                          ),
                        ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined),
                          color: Colors.white,
                          iconSize: 40,
                          onPressed: ()
                          {
                            setState(() {
                              widget.onClicked(true);
                              sendAnswer(false);
                              isCardTurned = true;
                              showAnswerBtns = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ) : Container() :
            Container(
              width: 75,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: Offset(1,5),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.redo_rounded),
                color: Colors.white,
                iconSize: 40,
                onPressed: (){
                  if(animationStatus == AnimationStatus.dismissed){
                    controller.forward();
                  }else{
                    controller.reverse();
                  }
                },
              ),
            ),
          ],
        ),
      );
  }
}
