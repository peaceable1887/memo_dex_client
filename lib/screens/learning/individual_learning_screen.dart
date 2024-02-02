import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/stack/stack_content_screen.dart';
import 'package:carousel_slider/carousel_slider.dart'; // https://pub.dev/packages/carousel_slider
import 'package:memo_dex_prototyp/services/api/api_client.dart';

import '../../services/local/file_handler.dart';
import '../../services/local/upload_to_database.dart';
import '../../widgets/header/headline.dart';
import '../../widgets/components/learning_card.dart';
import '../../widgets/header/top_navigation_bar.dart';
import '../bottom_navigation_screen.dart';

class IndividualLearningScreen extends StatefulWidget {

  final dynamic stackId;
  final bool? isMixed;

  const IndividualLearningScreen({Key? key, this.stackId, this.isMixed}) : super(key: key);

  @override
  State<IndividualLearningScreen> createState() => _CardLearningScreenState();
}

class _CardLearningScreenState extends State<IndividualLearningScreen> with TickerProviderStateMixin{

  late AnimationController controller;
  int activeIndex = 0;
  final List<dynamic> indexCards = [];
  bool emptyCards = false;
  String stackname = "";
  final storage = FlutterSecureStorage();
  FileHandler fileHandler = FileHandler();
  bool showLoadingCircular = true;
  late StreamSubscription subscription;

  @override
  void initState()
  {
    super.initState();
    loadStack();
    loadCards();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    async {
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);
      if(isConnected == true)
      {
        await UploadToDatabase(context).updateLocalCardContent(widget.stackId);
      }else{}
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => BottomNavigationScreen()),
      );
    });
  }

  Future<void> loadStack() async
  {
    try
    {
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

      if(isConnected == false)
      {
        setState(()
        {
          showLoadingCircular = false;
        });

        String localStackContent = await fileHandler.readJsonFromLocalFile("allStacks");

        if (localStackContent.isNotEmpty)
        {
          List<dynamic> stackContent = jsonDecode(localStackContent);

          for (var stack in stackContent)
          {
            if (stack["stack_id"] == widget.stackId)
            {
              setState(()
              {
                stackname = stack["stackname"];
              });
              // breche Schleife ab, da die gewünschten Daten gefunden wurden
              break;
            }
          }
        }
      }else
      {
        await ApiClient(context).stackApi.getStack(widget.stackId);

        String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

        if (fileContent.isNotEmpty)
        {
          List<dynamic> stacks = jsonDecode(fileContent);

          for (var stack in stacks)
          {
            if (stack["stack_id"] == widget.stackId)
            {
              setState(() {
                stackname = stack["stackname"];
              });
              break;
            }
          }
        }else{}
      }
    }catch(error)
    {
      print('Fehler beim Laden der loadStack Daten: $error');
    }
  }

  Future<void> loadCards() async
  {
    try
    {
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

      if(isConnected == false)
      {
        setState(()
        {
          showLoadingCircular = false;
        });

        String localCardContent = await fileHandler.readJsonFromLocalFile("allCards");

        if (localCardContent.isNotEmpty)
        {
          List<dynamic> cardContent = jsonDecode(localCardContent);

          for (var card in cardContent)
          {
            if(card['stack_stack_id'] == widget.stackId)
            {
              if(card["remember"] == 0 && card["is_deleted"] == 0)
              {
                indexCards.add(LearningCard(
                  stackId: card['stack_stack_id'],
                  question: card["question"],
                  answer: card["answer"],
                  cardIndex: card["card_id"],
                  onClicked: (bool val){},
                  isNoticed: card["remember"],
                  isIndividual: true,
                ));
              }
            }
          }
          if(widget.isMixed == true)
          {
            indexCards.shuffle();
          }else{}
          // Widget wird aktualisiert nnach dem Laden der Daten.
          if (mounted)
          {
            setState(() {});
          }
        }
      }else
      {
        await UploadToDatabase(context).createLocalCardContent(widget.stackId, widget.stackId);
        await ApiClient(context).cardApi.getAllCards();

        String fileContent = await fileHandler.readJsonFromLocalFile("allCards");

        if (fileContent.isNotEmpty)
        {
          List<dynamic> cardFileContent = jsonDecode(fileContent);

          for (var card in cardFileContent)
          {
            if (card['stack_stack_id'] == widget.stackId)
            {
              if(card["remember"] == 0 && card["is_deleted"] == 0)
              {
                //TODO card_id einbauen
                indexCards.add(LearningCard(
                  question: card["question"],
                  answer: card["answer"],
                  cardIndex: card["card_id"],
                  onClicked: (bool val){},
                  isNoticed: card["remember"],
                  isIndividual: true,
                ));
              }
            }
          }
          if(widget.isMixed == true)
          {
            indexCards.shuffle();
          }else{}
          // Widget wird aktualisiert nnach dem Laden der Daten.
          if (mounted)
          {
            setState(() {});
          }
        }else{}
      }
    }catch(error)
    {
      print('Fehler beim Laden der loadCards Daten: $error');
    }
  }

  @override
  void dispose() {
    loadStack();
    loadCards();
    subscription.cancel();
    super.dispose();
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
                autoPlayInterval: Duration(seconds: 1),
                onPageChanged: (index, reason) => setState(()
                {
                  activeIndex = index;
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
