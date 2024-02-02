import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';
import 'package:intl/intl.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';
import 'package:carousel_slider/carousel_slider.dart'; // https://pub.dev/packages/carousel_slider
import 'package:memo_dex_prototyp/services/api/api_client.dart';

import '../services/local/file_handler.dart';
import '../services/local/upload_to_database.dart';
import '../widgets/dialogs/custom_snackbar.dart';
import '../widgets/dialogs/message_box.dart';
import '../widgets/header/headline.dart';
import '../widgets/components/learning_card.dart';
import '../widgets/header/top_navigation_bar.dart';
import 'bottom_navigation_screen.dart';

class StandardLearningScreen extends StatefulWidget {

  final dynamic stackId;
  final bool? isMixed;

  const StandardLearningScreen({Key? key, this.stackId, this.isMixed}) : super(key: key);

  @override
  State<StandardLearningScreen> createState() => _CardLearningScreenState();
}

class _CardLearningScreenState extends State<StandardLearningScreen> with TickerProviderStateMixin{

  late AnimationController controller;
  int activeIndex = 0;
  final List<dynamic> indexCards = [];
  bool emptyCards = false;
  String stackname = "";
  late bool wasClicked = false;
  int seconds = 0;
  late Timer timer;
  bool snackbarShown = false;
  late StreamSubscription subscription;
  FileHandler fileHandler = FileHandler();
  bool showLoadingCircular = true;

  @override
  void initState()
  {
    super.initState();
    print("Stackid: ${widget.stackId}");
    startTimer();
    loadStack();
    loadCards();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    async {
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);
      if(isConnected == true)
      {
        await UploadToDatabase(context).updateLocalCardContent(widget.stackId);
        await UploadToDatabase(context).updateLocalCardStatistic(widget.stackId);

      }else{}
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => BottomNavigationScreen()),
      );
    });
  }

  void startTimer()
  {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(()
      {
        seconds++;
      });
    });
  }

  String formatTime()
  {
    Duration duration = Duration(seconds: seconds);

    return DateFormat('HH:mm:ss').format(DateTime(0, 1, 1).add(duration));
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
                  onClicked: handleCardClick,
                  isNoticed: card["remember"],
                  isIndividual: false,
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
                indexCards.add(LearningCard(
                  stackId: card['stack_stack_id'],
                  question: card["question"],
                  answer: card["answer"],
                  cardIndex: card["card_id"],
                  onClicked: handleCardClick,
                  isNoticed: card["remember"],
                  isIndividual: false,
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

  //TODO muss noch für die den offline modus angepasst werden (Daten werden nicht erfasst wenn der Stack komplett offline erstellt wurde)
  Future<void> handleCardClick(bool val) async {
    try
    {
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

      if(isConnected == false)
      {
        String localStackStatisticContent = await fileHandler.readJsonFromLocalFile("allStacks");

        if (localStackStatisticContent.isNotEmpty) {

          List<dynamic> stackStatisticContent = jsonDecode(localStackStatisticContent);

          for (var stack in stackStatisticContent)
          {
            if(stack["stack_id"] == widget.stackId)
            {
              if(stack["fastest_time"] == null)
              {
                stack["fastest_time"] = "99:99:99";
              }

              final fastestTime = stack["fastest_time"];

              setState(() {
                wasClicked = val;

                if (wasClicked == true && activeIndex == indexCards.length - 1) {

                  Duration fastestDuration = parseDuration(fastestTime);
                  Duration currentDuration = parseDuration(formatTime());

                  int stackPass = stack["pass"] + 1;
                  print("Stack Passes: ${stackPass}");

                  if(currentDuration.compareTo(fastestDuration) < 0)
                  {

                    fileHandler.editItemById(
                        "allStacks", "stack_id", widget.stackId,
                        {"fastest_time": formatTime(),"last_time": formatTime(),"pass": stackPass ,"is_updated": 1});

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MessageBox(
                          headline: "Fertig!",
                          message: "Du hast eine neue Bestzeit erreicht.",
                          stackId: widget.stackId,
                        );
                      },
                    );

                  }else
                  {
                    fileHandler.editItemById(
                        "allStacks", "stack_id", widget.stackId,
                        {"fastest_time": fastestTime,"last_time": formatTime(), "pass": stackPass , "is_updated": 1});

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MessageBox(
                          headline: "Fertig!",
                          message: "Du hast deine Bestzeit nicht übertroffen.",
                          stackId: widget.stackId,
                        );
                      },
                    );
                  }
                }
              });
            }
          }
        } else{}
      }else
      {
        final stackStatistic= await ApiClient(context).stackApi.getStackStatistic(widget.stackId);

        if(stackStatistic[0]["fastest_time"] == null)
        {
          stackStatistic[0]["fastest_time"] = "99:99:99";
        }

        final fastestTime = stackStatistic[0]["fastest_time"];

          print(wasClicked);
          wasClicked = val;

          if (wasClicked == true && activeIndex == indexCards.length - 1) {

            Duration fastestDuration = parseDuration(fastestTime);
            Duration currentDuration = parseDuration(formatTime());

            if(currentDuration.compareTo(fastestDuration) < 0)
            {
              await ApiClient(context).stackApi.updateStackStatistic(widget.stackId, formatTime(), formatTime(), stackStatistic[0]["pass"]);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MessageBox(
                    headline: "Fertig!",
                    message: "Du hast eine neue Bestzeit erreicht.",
                    stackId: widget.stackId,
                  );
                },
              );

            }else
            {
              await ApiClient(context).stackApi.updateStackStatistic(widget.stackId, fastestTime, formatTime(), stackStatistic[0]["pass"]);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return MessageBox(
                    headline: "Fertig!",
                    message: "Du hast deine Bestzeit nicht übertroffen.",
                    stackId: widget.stackId,
                  );
                },
              );
            }
          }

      }
    } catch (error) {
      print('Fehler beim Laden der Daten: $error');
    }
  }

  Duration parseDuration(String timeString)
  {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  @override
  void dispose() {
    print("dispose standard learning screen");
    loadStack();
    loadCards();
    timer.cancel();
    startTimer();
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
              child: GestureDetector(
                onPanUpdate: (details)
                {
                    if (!snackbarShown) {
                    CustomSnackbar.showSnackbar(
                        context,
                        Icons.info_outline_rounded,
                        "You need to answer the card.",
                        Colors.red,
                        Duration(seconds: 0),
                        Duration(milliseconds: 2000)
                    );
                    setState(() {
                      snackbarShown = true;
                    });
                    Future.delayed(Duration(seconds: 3), () {
                      setState(() {
                        snackbarShown = false;
                      });
                    });
                  }
                },
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
                      scrollPhysics: wasClicked ? RightBlockedScrollPhysics() : NeverScrollableScrollPhysics(),
                      autoPlayInterval: Duration(seconds: 1),
                      onPageChanged: (index, reason) => setState(()
                      {
                        activeIndex = index;
                        wasClicked = false;
                      }
                      ),
                    ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
