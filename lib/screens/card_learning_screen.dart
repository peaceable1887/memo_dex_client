import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';
import 'package:carousel_slider/carousel_slider.dart'; // https://pub.dev/packages/carousel_slider

import '../services/rest_services.dart';
import '../widgets/headline.dart';
import '../widgets/learning_card.dart';
import '../widgets/top_navigation_bar.dart';

class CardLearningScreen extends StatefulWidget {

  final dynamic stackId;

  const CardLearningScreen({Key? key, this.stackId}) : super(key: key);

  @override
  State<CardLearningScreen> createState() => _CardLearningScreenState();
}

class _CardLearningScreenState extends State<CardLearningScreen> with TickerProviderStateMixin{

  late AnimationController controller;

  @override
  void initState() {
    loadStack();
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
      setState(() {});
    });
    controller.forward();
    /*controller.repeat();*/
    super.initState();
  }

  @override
  void dispose() {
    loadStack();
    controller.dispose();
    super.dispose();
  }

  String stackname = "";

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
                  Container(
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0,0,20,0),
                    child: Container(
                      width: 80,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,0,10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => {
                              },
                              child: Icon(
                                Icons.lightbulb_outline_rounded,
                                size: 32.0,
                                color: Colors.white,
                              ), // Icon als klickbares Element
                            ),
                            InkWell(
                              onTap: (){},
                              child: Icon(
                                Icons.edit_outlined,
                                size: 30.0,
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
                        value: controller.value,
                        semanticsLabel: 'Linear progress indicator',
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
                              "12",
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
                              "30",
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
            LearningCard(),
          ],
        ),
    );
  }
}
