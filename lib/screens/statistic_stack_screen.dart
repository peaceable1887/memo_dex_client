import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/models/stack_statistic_data.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../utils/trim_text.dart';
import '../services/local/file_handler.dart';
import '../widgets/header/headline.dart';
import '../widgets/header/top_navigation_bar.dart';
import 'bottom_navigation_screen.dart';

class StatisticStackScreen extends StatefulWidget {

  final dynamic stackId;
  final String stackname;
  final String color;
  final int noticed;
  final int notNoticed;

  const StatisticStackScreen({super.key, this.stackId, required this.noticed, required this.notNoticed, required this.stackname, required this.color});

  @override
  State<StatisticStackScreen> createState() => _StatisticStackScreenState();
}

class _StatisticStackScreenState extends State<StatisticStackScreen>
{
  late List<StackStatisticData> _stackStatisticData;

  List<Map<String, dynamic>> combinedData = [
    {
      'question': 'no question',
      'answered_incorrectly': 0,
    },
    {
      'question': 'no question',
      'answered_incorrectly': 0,
    },
    {
      'question': 'no question',
      'answered_incorrectly': 0,
    },
  ];
  late double progressValue;
  late String fastestRun = "00:00:00";
  late String latestRun = "00:00:00";
  final storage = FlutterSecureStorage();
  FileHandler fileHandler = FileHandler();
  bool showLoadingCircular = true;
  late StreamSubscription subscription;
  bool snackbarIsDisplayed = false;

  @override
  void initState ()
  {
    super.initState();
    loadStackStatistcic();
    loadCardStatistic();
    checkInternetConnection();
    progressInPercent(widget.noticed, widget.notNoticed);
    _stackStatisticData = getStackStatisticData(widget.notNoticed);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    async
    {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => BottomNavigationScreen()),
      );
    });

  }

  Future<void> checkInternetConnection() async
  {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

    setState(() {
      if (!isConnected) {
        snackbarIsDisplayed = true;
      } else {
        snackbarIsDisplayed = false;
      }
    });
  }

  Future<void> loadStackStatistcic() async
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

        String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

        if (fileContent.isNotEmpty)
        {
          List<dynamic> stacks = jsonDecode(fileContent);

          for (var stack in stacks)
          {
            if (stack["stack_id"] == widget.stackId)
            {
              setState(()
              {
                if (stack["fastest_time"] != null || stack["last_time"] != null)
                {
                  fastestRun = stack["fastest_time"] ?? "00:00:00";
                  latestRun = stack["last_time"] ?? "00:00:00";
                }
                else
                {
                  fastestRun = "00:00:00";
                  latestRun = "00:00:00";
                }
              });
            }
          }
        }
      }else
      {
        await ApiClient(context).stackApi.getStack(widget.stackId);

        setState(()
        {
          showLoadingCircular = false;
        });

        String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

        if (fileContent.isNotEmpty)
        {
          List<dynamic> stacks = jsonDecode(fileContent);

          for (var stack in stacks)
          {
            if (stack["stack_id"] == widget.stackId)
            {
              setState(()
              {
                if (stack["fastest_time"] != null || stack["last_time"] != null)
                {
                  fastestRun = stack["fastest_time"] ?? "00:00:00";
                  latestRun = stack["last_time"] ?? "00:00:00";
                }
                else
                {
                  fastestRun = "00:00:00";
                  latestRun = "00:00:00";
                }
              });
            }
          }
        }
      }
    }catch(error)
    {
      print('Fehler beim Laden der loadStackStatistcic: $error');
    }
  }

  Future<void> loadCardStatistic() async
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

        String fileContent = await fileHandler.readJsonFromLocalFile("allCards");

        if (fileContent.isNotEmpty)
        {
          List<dynamic> cardFileContent = jsonDecode(fileContent);

          setState(()
          {
            for (var card in cardFileContent)
            {
              if(card['stack_stack_id'] == widget.stackId)
              {
                String question = card["question"];
                int answeredIncorrectly = card['answered_incorrectly'];

                combinedData.add({'question': question, 'answered_incorrectly': answeredIncorrectly,});
              }
            }
            combinedData.sort((a, b) => b['answered_incorrectly'].compareTo(a['answered_incorrectly']));
          });

        }
      }else
      {
        await ApiClient(context).cardApi.getAllCardsByStackId(widget.stackId);

        setState(()
        {
          showLoadingCircular = false;
        });

        String fileContent = await fileHandler.readJsonFromLocalFile("allCards");

        if (fileContent.isNotEmpty)
        {
          List<dynamic> cardFileContent = jsonDecode(fileContent);

          setState(()
          {
            for (var card in cardFileContent)
            {
              if(card['stack_stack_id'] == widget.stackId)
              {
                String question = card["question"];
                int answeredIncorrectly = card['answered_incorrectly'];

                combinedData.add({'question': question, 'answered_incorrectly': answeredIncorrectly,});
              }
            }
            combinedData.sort((a, b) => b['answered_incorrectly'].compareTo(a['answered_incorrectly']));
          });
        }
      }
    } catch (error)
    {
      print('Fehler beim Laden der loadCardStatistic: $error');
    }
  }

  void progressInPercent(noticed, notNoticed)
  {
    if(notNoticed == 0 && widget.noticed == 0)
    {
      notNoticed = 1;
    }

    setState(() {
      progressValue = (noticed/(noticed+notNoticed))*100;
    });
  }

  List<StackStatisticData> getStackStatisticData(notNoticed)
  {
    if(notNoticed == 0 && widget.noticed == 0)
    {
      notNoticed = 1;
    }

    Color originalColor = Color(int.parse("0xFF${widget.color}"));
    Color darkerColor = Color.fromARGB(
      originalColor.alpha,
      (originalColor.red * 0.7).round(),
      (originalColor.green * 0.7).round(),
      (originalColor.blue * 0.7).round(),
    );

    final List<StackStatisticData> statisticData = [
      StackStatisticData("Noticed", widget.noticed, originalColor),
      StackStatisticData("Noticed", notNoticed, darkerColor),
    ];

    return statisticData;
  }

  String calculateDifference(String timeStringOne, String timeStringTwo) {
    try
    {
      DateTime timeOne = DateTime.parse("2022-01-01 $timeStringOne");
      DateTime timeTwo = DateTime.parse("2022-01-01 $timeStringTwo");

      Duration difference = timeTwo.difference(timeOne);

      String hours = difference.inHours.toString().padLeft(2, '0');
      String minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
      String seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');

      return "$hours:$minutes:$seconds";

    }catch (error)
    {
      print('Fehler beim Berechnen der Zeitdifferenz: $error');
      return 'Fehler';
    }
  }

  @override
  void dispose()
  {
    print("dispose stack statistic screen");
    loadStackStatistcic();
    loadCardStatistic();
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
            padding: const EdgeInsets.fromLTRB(0,5,0,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                WillPopScope(
                  onWillPop: () async => false,
                  child: Container(
                    child: TopNavigationBar(
                      btnText: "Statistic",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen(index: 1),
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
                text: widget.stackname
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,30,0,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "DETAILS",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    padding:  const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 15.0,
                          offset: Offset(4, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.insert_chart_outlined_rounded,
                              size: 24.0,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                "PROGRESS",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 165,
                          child: SfCircularChart(
                            annotations:  <CircularChartAnnotation>[
                              CircularChartAnnotation(
                                widget: Padding(
                                  padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${progressValue.toInt()}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 30,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                          child: const Text(
                                            '%',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontFamily: "Inter",
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            series: <CircularSeries>[
                              DoughnutSeries<StackStatisticData, String>(
                                radius: "70",
                                dataSource: _stackStatisticData,
                                pointColorMapper:(StackStatisticData data,  _) => data.color,
                                xValueMapper: (StackStatisticData data, _) => data.stackName,
                                yValueMapper: (StackStatisticData data, _) => data.memorized,
                                innerRadius: '65%',
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 20,
                                        child: Image(
                                          image: AssetImage("assets/images/card_btn_icon.png"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                        child: Text(
                                          '${widget.noticed.toInt() + widget.notNoticed.toInt()}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "TOTAL CARDS",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.lightbulb_rounded,
                                        size: 22.0,
                                        color: Color(0xFFE59113),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                        child: Text(
                                          '${widget.noticed.toInt()}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "NOTICED",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.lightbulb_outline_rounded,
                                        size: 22.0,
                                        color: Color(0xFFE59113),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                                        child: Text(
                                          '${widget.notNoticed.toInt()}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20,
                                            fontFamily: "Inter",
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "NOT NOTICED",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontFamily: "Inter",
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          height: MediaQuery.of(context).size.height /6.7,
                          width:  MediaQuery.of(context).size.width /3.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                blurRadius: 15.0,
                                offset: Offset(4, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timelapse_rounded,
                                      size: 22.0,
                                      color: Colors.green,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${fastestRun}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "FASTEST RUN",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          height: MediaQuery.of(context).size.height /6.7,
                          width:  MediaQuery.of(context).size.width /3.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                blurRadius: 15.0,
                                offset: Offset(4, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.timelapse_rounded,
                                      size: 22.0,
                                      color: Color(0xFFE59113),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${latestRun}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "LATEST RUN",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Container(
                          height: MediaQuery.of(context).size.height /6.7,
                          width:  MediaQuery.of(context).size.width /3.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.15),
                                blurRadius: 15.0,
                                offset: Offset(4, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.difference_rounded,
                                      size: 22.0,
                                      color: Colors.red,
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${calculateDifference(fastestRun, latestRun)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "DIFFERENCE",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: snackbarIsDisplayed ? EdgeInsets.fromLTRB(20, 5, 20, 70) : EdgeInsets.fromLTRB(20, 5, 20, 20),
                  child: Container(
                    padding:  const EdgeInsets.fromLTRB(15, 10, 15, 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.15),
                          blurRadius: 15.0,
                          offset: Offset(4, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                size: 24.0,
                                color: Colors.red,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                                child: Text(
                                  "COMMONLY ANSWERED WRONG",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    "PLACE",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                                Text(
                                  "1.",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(
                                  "2.",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(
                                  "3.",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    "QUESTION",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                                Text(
                                  '${TrimText().trimText(combinedData[0]['question'], 15)}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                Text(
                                  '${TrimText().trimText(combinedData[1]['question'], 15)}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                Text(
                                  '${TrimText().trimText(combinedData[2]['question'], 15)}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: Text(
                                    "NUMBER",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 15,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w400
                                    ),
                                  ),
                                ),
                                Text(
                                  '${combinedData[0]['answered_incorrectly'].toInt()}',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(
                                  '${combinedData[1]['answered_incorrectly'].toInt()}',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                                Text(
                                  '${combinedData[2]['answered_incorrectly'].toInt()}',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w600
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}

