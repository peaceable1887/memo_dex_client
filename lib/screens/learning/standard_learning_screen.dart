import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:horizontal_blocked_scroll_physics/horizontal_blocked_scroll_physics.dart';
import 'package:intl/intl.dart';
import 'package:memo_dex_prototyp/screens/stack/stack_content_screen.dart';
import 'package:carousel_slider/carousel_slider.dart'; // https://pub.dev/packages/carousel_slider
import 'package:memo_dex_prototyp/services/api/api_client.dart';

import '../../services/local/file_handler.dart';
import '../../services/local/upload_to_database.dart';
import '../../services/local/write_to_device_storage.dart';
import '../../widgets/dialogs/custom_snackbar.dart';
import '../../widgets/dialogs/message_box.dart';
import '../../widgets/header/headline.dart';
import '../../widgets/components/learning_card.dart';
import '../../widgets/header/top_navigation_bar.dart';
import '../bottom_navigation_screen.dart';

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
  final storage = FlutterSecureStorage();
  bool isFirstIfBranchExecuted = false;

  @override
  void initState()
  {
    super.initState();
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

  Future<void> handleCardClick(bool val) async
  {
    try
    {
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

      if(isConnected == false)
      {
        if(!isFirstIfBranchExecuted)
        {
          //create dummy stackRun data if stackRun with given stack_stack_id is not available
          await createLocalStackRun();
          isFirstIfBranchExecuted = true;
        }

        String localStackRunContent = await fileHandler.readJsonFromLocalFile("stackRuns");

        if (localStackRunContent.isNotEmpty)
        {
          List<dynamic> stackRunContent = jsonDecode(localStackRunContent);

          for (var run in stackRunContent)
          {
            int arrLength = localStackRunContent.length;
            String tempPassIndex = arrLength.toString();

            if(run["stack_stack_id"] == widget.stackId)
            {
              List<int> total = [];

              for(int i = 0; i < stackRunContent.length; i++)
              {
                if(stackRunContent[i]["stack_stack_id"] == widget.stackId)
                {
                  List<String> splitRun = stackRunContent[i]["time"].split(":");
                  int hours = int.parse(splitRun[0]);
                  int minutes = int.parse(splitRun[1]);
                  int seconds = int.parse(splitRun[2]);

                  int totalSecondsRun = (hours * 3600) + (minutes * 60) + seconds;
                  total.add(totalSecondsRun);
                }
              }

              //sort by the fastest time
              total.sort();
              print(total);
              final int fastestTime = total[0];

              List<String> splitFormatTime = formatTime().split(":");
              int hours = int.parse(splitFormatTime[0]);
              int minutes = int.parse(splitFormatTime[1]);
              int seconds = int.parse(splitFormatTime[2]);

              int formatTimeInteger = (hours * 3600) + (minutes * 60) + seconds;

              print("STACKRUNTIME: ${fastestTime}");
              print("FORMATTIME: ${formatTimeInteger}");

              setState(() async
              {
                wasClicked = val;

                if (wasClicked == true && activeIndex == indexCards.length - 1)
                {
                  if(formatTimeInteger.compareTo(fastestTime) < 0)
                  {
                    await WriteToDeviceStorage().addPass(
                      stackId: widget.stackId,
                      time: formatTime(),
                      fileName: "stackRuns",
                      tempPassIndex: tempPassIndex,
                    );

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
                    await WriteToDeviceStorage().addPass(
                      stackId: widget.stackId,
                      time: formatTime(),
                      fileName: "stackRuns",
                      tempPassIndex: tempPassIndex,
                    );

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
        var stackRunTime = await ApiClient(context).stackApi.getStackRun(widget.stackId);
        List<int> total = [];

        if (stackRunTime == null || stackRunTime.isEmpty)
        {
          stackRunTime = [{"time": "99:99:99"}];
        }

        for(int i = 0; i < stackRunTime.length; i++)
        {
          List<String> splitRun = stackRunTime[i]["time"].split(":");
          int hours = int.parse(splitRun[0]);
          int minutes = int.parse(splitRun[1]);
          int seconds = int.parse(splitRun[2]);

          int totalSecondsRun = (hours * 3600) + (minutes * 60) + seconds;
          total.add(totalSecondsRun);
        }

        //sort by the fastest time
        total.sort();

        final int fastestTime = total[0];

        List<String> splitFormatTime = formatTime().split(":");
        int hours = int.parse(splitFormatTime[0]);
        int minutes = int.parse(splitFormatTime[1]);
        int seconds = int.parse(splitFormatTime[2]);

        int formatTimeInteger = (hours * 3600) + (minutes * 60) + seconds;

        print("FORMATTIME: ${formatTimeInteger}");

        setState(() async
        {
          wasClicked = val;

          if (wasClicked == true && activeIndex == indexCards.length - 1)
          {
            if(formatTimeInteger.compareTo(fastestTime) < 0)
            {
              await ApiClient(context).stackApi.insertStackRun(formatTime(),widget.stackId);
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
              await ApiClient(context).stackApi.insertStackRun(formatTime(),widget.stackId);
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
    } catch (error) {
      print('Fehler beim Laden der Daten: $error');
    }
  }

  Future<void> createLocalStackRun() async
  {
    String localStackRunContent = await fileHandler.readJsonFromLocalFile("stackRuns");

    if (localStackRunContent.isNotEmpty)
    {
      List<dynamic> stackRunContent = jsonDecode(localStackRunContent);
      bool test = false;

      for(int i = 0; i < stackRunContent.length; i++)
      {
        int arrLength = localStackRunContent.length;
        String tempPassIndex = arrLength.toString();

        if(!test && stackRunContent[i]["stack_stack_id"] != widget.stackId)
        {
          await WriteToDeviceStorage().addPass(
            stackId: widget.stackId,
            time: "24:00:00",
            fileName: "stackRuns",
            tempPassIndex: tempPassIndex,
          );
          test = true;
        }
      }
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
