import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';

import '../services/local/file_handler.dart';
import '../services/local/upload_to_database.dart';
import '../services/rest/rest_services.dart';
import '../widgets/components/custom_snackbar.dart';
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
  final storage = FlutterSecureStorage();
  FileHandler fileHandler = FileHandler();
  bool showLoadingCircular = true;
  late StreamSubscription subscription;

  @override
  void initState()
  {
    super.initState();
    showSnackbarInformation();
    loadStack();
    loadCard();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    async {
      indexCards.clear();
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);
      if(isConnected == true)
      {
        await UploadToDatabase(context).updateAllLocalCards(widget.stackId);
      }else{}

      loadStack();
      loadCard();
    });
  }

  void showSnackbarInformation() async
  {
    String? stackCreated = await storage.read(key: 'editCard');
    if(stackCreated == "true")
    {
      CustomSnackbar.showSnackbar(
          context,
          Icons.check_rounded,
          "A card was successfully edited.",
          Colors.green,
          Duration(milliseconds: 500),
          Duration(milliseconds: 1500)
      );
      await storage.write(key: 'editCard', value: "false");
    }
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

        String serverFileStackContent = await fileHandler.readJsonFromLocalFile("allStacks");
        String localFileStackContent = await fileHandler.readJsonFromLocalFile("allLocalStacks");

        if (serverFileStackContent.isNotEmpty)
        {
          if(localFileStackContent.isEmpty)
          {
            localFileStackContent = "[]";
          }

          List<dynamic> stackFileContent = jsonDecode(serverFileStackContent);
          List<dynamic> localStackFileContent = jsonDecode(localFileStackContent);

          List<dynamic> combinedStackContent = [...stackFileContent, ...localStackFileContent];

          for (var stack in combinedStackContent)
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
        await UploadToDatabase(context).allLocalStackContent();

        await RestServices(context).getStack(widget.stackId);

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

  Future<void> loadCard() async
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

        String serverFileCardContent = await fileHandler.readJsonFromLocalFile("allCards");
        String localFileCardContent = await fileHandler.readJsonFromLocalFile("allLocalCards");

        if (serverFileCardContent.isNotEmpty)
        {
          if(localFileCardContent.isEmpty)
          {
            localFileCardContent = "[]";
          }

          List<dynamic> serverCardContent = jsonDecode(serverFileCardContent);
          List<dynamic> localCardContent = jsonDecode(localFileCardContent);

          List<dynamic> combinedCardContent = [...serverCardContent, ...localCardContent];

          for (var card in combinedCardContent)
          {
            if(card['stack_stack_id'] == widget.stackId && card['card_id'] == widget.cardId)
            {
              indexCards.add(LearningCard(
                question: card["question"],
                answer: card["answer"],
                cardIndex: card["card_id"],
                onClicked: (bool val){},
                isNoticed: card["remember"],
                isIndividual: true,
              ));

              question = card["question"];
              answer = card["answer"];
              if(card["remember"] == 1)
              {
                isNoticed = true;
              }
            }
          }
          // Widget wird aktualisiert nnach dem Laden der Daten.
          if (mounted)
          {
            setState(()
            {});
          }
        }
      }else
      {
        await UploadToDatabase(context).allLocalCards(widget.stackId, widget.stackId);
        await RestServices(context).getAllCards();

        FileHandler().deleteItemById("allLocalCards", widget.stackId);

        String fileContent = await fileHandler.readJsonFromLocalFile("allCards");

        if (fileContent.isNotEmpty)
        {
          List<dynamic> cardFileContent = jsonDecode(fileContent);

          for (var card in cardFileContent)
          {
            if (card['stack_stack_id'] == widget.stackId && card['card_id'] == widget.cardId)
            {
              indexCards.add(LearningCard(
                question: card["question"],
                answer: card["answer"],
                cardIndex: card["card_id"],
                onClicked: (bool val){},
                isNoticed: card["remember"],
                isIndividual: true,
              ));

              question = card["question"];
              answer = card["answer"];
              if(card["remember"] == 1)
              {
                isNoticed = true;
              }
            }
          }
          // Widget wird aktualisiert nnach dem Laden der Daten.
          if (mounted)
          {
            setState(()
            {});
          }
        }else{}
      }
    }catch(error)
    {
      print('Fehler beim Laden der loadCards Daten: $error');
    }
  }

  //TODO NOCHMAL ANSEHEN: wenn die Karte als "isNoticed" markiert wird, wird der wert nicht an den edit_card_screen übergben
  void pushToEditCard()
  {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditCardScreen(
          stackId: widget.stackId,
          cardId: widget.cardId,
          stackname: stackname,
          question: question,
          answer: answer,
          isNoticed: isNoticed,
        ),
      ),
    );
  }

  Widget buildIndexCard(Widget indexCard, int index) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: indexCard,
      );

  @override
  void dispose()
  {
    subscription.cancel();
    super.dispose();
  }


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
                        Navigator.pushReplacement(
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
