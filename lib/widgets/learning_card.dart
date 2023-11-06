import 'dart:math';

import 'package:flutter/material.dart';

class LearningCard extends StatefulWidget {

  final String question;
  final String answer;

  const LearningCard({Key? key, required this.question, required this.answer}) : super(key: key);

  @override
  State<LearningCard> createState() => _LearningCardState();
}

class _LearningCardState extends State<LearningCard> with TickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;
  AnimationStatus animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation = Tween(end: 1.0, begin: 0.0).animate(controller);
    animation.addListener(() {
        setState(() {

        });
      });
    animation.addStatusListener((status) {
        animationStatus = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    width: 330,
                    height: 430,
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Container(
                            width: 330,
                            height: 60,
                            color: Colors.red,
                            child: Center(
                              child: Text(
                                "Question",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 330,
                          height: 300,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                              child: Text(
                                widget.question,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.redo_rounded),
                          iconSize: 40,
                          onPressed: (){
                            if(animationStatus == AnimationStatus.dismissed){
                              controller.forward();
                            }else{
                              controller.reverse();
                            }
                          },
                          )
                        ],
                      ),
                    ),
                  )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  color: Colors.white,
                  width: 330,
                  height: 430,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 330,
                          height: 60,
                          color: Colors.red,
                          child: Center(
                            child: Text(
                              "Answer",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 330,
                        height: 300,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                            child: Text(
                              widget.answer,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.redo_rounded),
                        iconSize: 40,
                        onPressed: (){
                          if(animationStatus == AnimationStatus.dismissed){
                            controller.forward();
                          }else{
                            controller.reverse();
                          }
                        },
                      )
                    ],
                  ),
                ),
              )
              )
            ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
