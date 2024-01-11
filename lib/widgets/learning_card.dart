import 'dart:math';
import 'package:flutter/material.dart';

import '../services/rest_services.dart';
import 'components/custom_snackbar.dart';

class LearningCard extends StatefulWidget {

  final int cardIndex;
  final String question;
  final String answer;
  final Function(bool) onClicked;
  final int isNoticed;
  final bool isIndividual;

  const LearningCard({Key? key, required this.question, required this.answer, required this.cardIndex, required this.onClicked, required this.isIndividual, required this.isNoticed}) : super(key: key);

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

  @override
  void initState()
  {
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
    super.initState();
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

  void cardNoted()
  {
    setState(()
    {
      if(isCardNoticed == false)
      {
        RestServices(context).updateCard(widget.question, widget.answer, 0, 1, widget.cardIndex,);
        isCardNoticed = true;
        CustomSnackbar.showSnackbar(
            context,
            "Information",
            "You marked the card as memorized.",
            Color(0xFFE59113),
            Duration(seconds: 0),
            Duration(milliseconds: 1500)
        );
      }else{
        RestServices(context).updateCard(widget.question, widget.answer, 0, 0, widget.cardIndex,);
        isCardNoticed = false;
        CustomSnackbar.showSnackbar(
            context,
            "Information",
            "You marked the card as unmemorized",
            Color(0xFFE59113),
            Duration(seconds: 0),
            Duration(milliseconds: 1500)
        );
      }
    });
  }

  void sendAnswer(answeredCorrectly)
  {
    setState(() {
      if(answeredCorrectly == false){
        RestServices(context).answeredIncorrectly(widget.cardIndex);
      }else{
        RestServices(context).answeredCorrectly(widget.cardIndex);
      }
    });
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
    setLightIcon();
    controller.dispose();
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
                                  onTap: cardNoted,
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
