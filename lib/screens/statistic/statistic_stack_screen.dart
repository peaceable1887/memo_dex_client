import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/models/stack_statistic_data.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/utils/converter.dart';
import 'package:memo_dex_prototyp/widgets/buttons/date_picker_btn.dart';
import 'package:memo_dex_prototyp/widgets/components/statistic/statistic_line_chart.dart';
import 'package:memo_dex_prototyp/widgets/text/headlines/headline_small.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../utils/divide_painter.dart';
import '../../utils/trim.dart';
import '../../services/local/file_handler.dart';
import '../../widgets/text/headlines/headline_large.dart';
import '../../widgets/header/top_navigation_bar.dart';
import '../../widgets/text/headlines/headline_medium.dart';
import '../bottom_navigation_screen.dart';

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
  late String fastestRun = "No Time";
  late String latestRun = "No Time";
  String averageTime = "No Time";
  final storage = FlutterSecureStorage();
  FileHandler fileHandler = FileHandler();
  bool showLoadingCircular = true;
  late StreamSubscription subscription;
  bool snackbarIsDisplayed = false;
  late int selectedYear;
  late int selectedMonth;
  int currentDay = 1;
  late int currentMonth;
  List<Map<String, dynamic>> runInformation = [];
  bool showShadow = false;
  final double scrollThreshold = 30.0;
  int _totalRuns = 0;

  @override
  void initState ()
  {
    super.initState();
    loadStackStatistcic();
    loadCardStatistic();
    loadStackRuns();
    selectedYear = DateTime.now().year;
    selectedMonth = DateTime.now().month;
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

        String runContent = await fileHandler.readJsonFromLocalFile("stackRuns");

        if (runContent.isNotEmpty)
        {
          List<dynamic> runs = jsonDecode(runContent);

          setState(()
          {
            String fastestTime = "99:99:99";

            for (var run in runs)
            {
              if (run["stack_stack_id"] == widget.stackId)
              {
                String currentTime = run['time'];

                if (currentTime.compareTo(fastestTime) < 0)
                {
                  fastestTime = currentTime;
                  fastestRun = fastestTime;
                }
                latestRun = run['time'];
              }
            }
          });

          calculateAverage(runs);
        }
      }else
      {
        await ApiClient(context).stackApi.getStack(widget.stackId);
        await ApiClient(context).stackApi.getAllStackRuns();

        setState(()
        {
          showLoadingCircular = false;
        });

        String runContent = await fileHandler.readJsonFromLocalFile("stackRuns");

        if (runContent.isNotEmpty)
        {
          List<dynamic> runs = jsonDecode(runContent);

          setState(()
          {
            String fastestTime = "99:99:99";

            for (var run in runs)
            {
              if (run["stack_stack_id"] == widget.stackId)
              {
                String currentTime = run['time'];

                if (currentTime.compareTo(fastestTime) < 0)
                {
                  fastestTime = currentTime;
                  fastestRun = fastestTime;
                }
                latestRun = run['time'];
              }
            }
          });

          calculateAverage(runs);

        }else
        {
          print("File stackRuns is empty.");
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

  Future<void> loadStackRuns() async
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

        String fileContent = await fileHandler.readJsonFromLocalFile("stackRuns");

        if (fileContent.isNotEmpty)
        {
          List<dynamic> stackRunFileContent = jsonDecode(fileContent);
          setState(()
          {
            List<dynamic> information = [];
            String formattedDate = "";

            for (var stackRun in stackRunFileContent)
            {
              if(stackRun['stack_stack_id'] == widget.stackId)
              {
                DateTime dateTime = DateTime.parse(stackRun["date"]);
                formattedDate = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

                splitFormattedDate(formattedDate);
                information.add(formattedDate);

                print("DATE INFORMATION: $information");

              }
            }

            List<dynamic> dateInformation = information;
            Map<String, int> dateCountMap = {};

            for (int i = 0; i < dateInformation.length; i++)
            {
              String currentDate = dateInformation[i];

              if (dateCountMap.containsKey(currentDate))
              {
                dateCountMap[currentDate] = dateCountMap[currentDate]! + 1;
              } else
              {
                dateCountMap[currentDate] = 1;
              }
            }

            dateCountMap.forEach((date, numberOfRuns)
            {
              print("[$date, $numberOfRuns]");
              runInformation.add({'date': date, 'numberOfRuns': numberOfRuns});
            });

            print("RUN INFORMATION: $runInformation");
            print("DATE INFORMATION: ${information.length}");
            _totalRuns = information.length;

          });
        }
      }else
      {
        await ApiClient(context).stackApi.getAllStackRuns();

        setState(()
        {
          showLoadingCircular = false;
        });

        String fileContent = await fileHandler.readJsonFromLocalFile("stackRuns");
        print("FILE CONTENT: $fileContent");
        if (fileContent.isNotEmpty)
        {
          List<dynamic> stackRunFileContent = jsonDecode(fileContent);
          setState(()
          {
            List<dynamic> information = [];
            String formattedDate = "";

            for (var stackRun in stackRunFileContent)
            {
              if(stackRun['stack_stack_id'] == widget.stackId)
              {
                DateTime dateTime = DateTime.parse(stackRun["date"]);
                formattedDate = "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";

                splitFormattedDate(formattedDate);
                information.add(formattedDate);

                print("DATE INFORMATION: $information");
                print("DATE INFORMATION: ${information.length}");
                _totalRuns = information.length;

              }
            }

            List<dynamic> dateInformation = information;
            Map<String, int> dateCountMap = {};

            for (int i = 0; i < dateInformation.length; i++)
            {
              String currentDate = dateInformation[i];

              if (dateCountMap.containsKey(currentDate))
              {
                dateCountMap[currentDate] = dateCountMap[currentDate]! + 1;
              } else
              {
                dateCountMap[currentDate] = 1;
              }
            }

            dateCountMap.forEach((date, numberOfRuns)
            {
              print("[$date, $numberOfRuns]");
              runInformation.add({'date': date, 'numberOfRuns': numberOfRuns});
            });

          });
        }
      }
    } catch (error)
    {
      print('Fehler beim Laden des StackRunContent: $error');
    }
  }

  void splitFormattedDate(String formattedDate)
  {
    List<String> splitFormattedDate = formattedDate.split("-");
    try
    {
      int month = int.parse(splitFormattedDate[1].trim());
      int day = int.parse(splitFormattedDate[2].trim());

      setState(()
      {
        currentMonth = month;
        currentDay = day;
      });

    } catch (e)
    {
      print("Fehler beim Parsen der Zeitangabe: $e");
    }
  }

  void updateSelectedValues(int year, int month) {
    setState(()
    {
      selectedYear = year;
      selectedMonth = month;
    });
  }

  //TODO noch auslagern
  void progressInPercent(noticed, notNoticed)
  {
    if(notNoticed == 0 && widget.noticed == 0)
    {
      notNoticed = 1;
    }

    setState(()
    {
      progressValue = (noticed/(noticed+notNoticed))*100;
    });
  }
  //TODO noch auslagern
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
  
  //TODO noch auslagern
  Future<void> calculateAverage(List<dynamic> runs) async
  {
    List<String> runList = [];
    int totalSeconds = 0;
    int numberOfRuns = 0;

    for (var run in runs)
    {
      if (run["stack_stack_id"] == widget.stackId)
      {
        if(run["time"] != "24:00:00")
        {
          runList.add(run["time"]);
        }
      }
    }

    for (var runString in runList)
    {
      List<String> splitRun = runString.split(":");
      try
      {
        int hours = int.parse(splitRun[0].trim());
        int minutes = int.parse(splitRun[1].trim());
        int seconds = int.parse(splitRun[2].trim());

        int totalSecondsRun = (hours * 3600) + (minutes * 60) + seconds;

        totalSeconds += totalSecondsRun;
        numberOfRuns++;
      } catch (e) {
        print("Fehler beim Parsen der Zeitangabe: $e");
      }
    }

    if (numberOfRuns > 0)
    {
      int averageTotalSeconds = totalSeconds ~/ numberOfRuns;
      int averageHours = averageTotalSeconds ~/ 3600;
      int averageMinutes = (averageTotalSeconds % 3600) ~/ 60;
      int averageSeconds = averageTotalSeconds % 60;

      // formatierung der zeitangabe
      averageTime = "${averageHours.toString().padLeft(2, '0')}:${averageMinutes.toString().padLeft(2, '0')}:${averageSeconds.toString().padLeft(2, '0')}";
      print(averageTime);
      setState(()
      {
        averageTime = averageTime;
      });
    } else
    {
      print("Keine Laufzeiten gefunden.");
    }
  }
  //TODO noch auslagern
  String calculateDifference(String timeStringOne, String timeStringTwo) {
    try
    {
      DateTime timeOne = DateTime.parse("2022-01-01 $timeStringOne");
      DateTime timeTwo = DateTime.parse("2022-01-01 $timeStringTwo");

      Duration difference = timeTwo.difference(timeOne);

      String hours = difference.inHours.toString().padLeft(2, '0');
      String minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
      String seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');

      String time = "$hours:$minutes:$seconds";

      return time;

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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            leading: TopNavigationBar(
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
            centerTitle: true,
            expandedHeight: 130,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              expandedTitleScale: 2,
              titlePadding: EdgeInsets.only(bottom: 15),
              centerTitle: true,
              title: HeadlineLarge(text: widget.stackname, isInSliverAppBar: true,),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0,25,0,0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20,5,0,5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const HeadlineMedium(text: "OVERVIEW"),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
              child: Container(
                padding:  const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Column(
                  children: [
                    Container(
                      height: 137,
                      width: 137,
                      child: SfCircularChart(
                        annotations:  <CircularChartAnnotation>[
                          CircularChartAnnotation(
                              widget: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${progressValue.toInt()}',
                                      style: Theme.of(context).textTheme.headlineLarge,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                      child: Text(
                                        '%',
                                        style: Theme.of(context).textTheme.headlineSmall,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ),
                        ],
                        series: <CircularSeries>[
                          DoughnutSeries<StackStatisticData, String>(
                            radius: "110",
                            dataSource: _stackStatisticData,
                            pointColorMapper:(StackStatisticData data,  _) => data.color,
                            xValueMapper: (StackStatisticData data, _) => data.stackName,
                            yValueMapper: (StackStatisticData data, _) => data.memorized,
                            innerRadius: '70%',
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.15),
                              blurRadius: 8.0,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "TOTAL CARDS",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: Text(
                                          '${widget.noticed.toInt() + widget.notNoticed.toInt()}',
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "NOTICED",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: Text(
                                          '${widget.noticed.toInt()}',
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "NOT NOTICED",
                                        style: Theme.of(context).textTheme.bodySmall,
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                        child: Text(
                                          '${widget.notNoticed.toInt()}',
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: [
                  const HeadlineSmall(text: "RUN DETAILS"),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      height: MediaQuery.of(context).size.height /6.7,
                      width:  MediaQuery.of(context).size.width /3.6,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
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
                                  Icons.fast_forward_rounded,
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
                                  style: Theme.of(context).textTheme.labelMedium,
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
                                  style: Theme.of(context).textTheme.titleSmall,
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
                        color: Theme.of(context).colorScheme.secondary,
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
                                  Icons.av_timer_rounded,
                                  size: 22.0,
                                  color: Theme.of(context).colorScheme.primary,
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
                                  style: Theme.of(context).textTheme.labelMedium,
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
                                  style: Theme.of(context).textTheme.titleSmall,
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
                        color: Theme.of(context).colorScheme.secondary,
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
                                  Icons.bar_chart,
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
                                  averageTime,
                                  style: Theme.of(context).textTheme.labelMedium,
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
                                  "AVERAGE",
                                  style: Theme.of(context).textTheme.titleSmall,
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
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      "TOTAL RUNS",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 2),
                      painter: DividePainter(Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                       Text(
                         '$_totalRuns',
                         style: Theme.of(context).textTheme.bodyLarge,
                       ),
                        Row(
                          children: [
                            Text(
                              Converter().showMonthAsText(selectedMonth),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                              child: Text(
                                '${selectedYear}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            DatePickerBtn(onDateSelected: (year, month) {
                              updateSelectedValues(year, month);
                            },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 2),
                      painter: DividePainter(Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 30, 0),
                    child: StatisticLineChart(
                      year: selectedYear,
                      month: selectedMonth,
                      runInformation: runInformation,
                    ),
                  ),
                ],
              ),
            ),
          ),
                    
          SliverToBoxAdapter(
            child: Padding(
              padding: snackbarIsDisplayed ? EdgeInsets.fromLTRB(0, 5, 0, 70) : EdgeInsets.fromLTRB(0, 5, 0, 20),
              child: Container(
                padding:  const EdgeInsets.fromLTRB(20, 5, 20, 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      blurRadius: 15.0,
                      offset: Offset(0, -15),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                      child: Row(
                        children: [
                          const HeadlineSmall(text: "COMMONLY ANSWERED WRONG"),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.format_list_numbered,
                              size: 22.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                "Place",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              "1.",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "2.",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(height: 10),
                            Text(
                              "3.",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.question_answer_rounded,
                              size: 22.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                "Question",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              '${Trim().trimText(combinedData[0]['question'], 15)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${Trim().trimText(combinedData[1]['question'], 15)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${Trim().trimText(combinedData[2]['question'], 15)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 22.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                "Number",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              '${combinedData[0]['answered_incorrectly'].toInt()}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${combinedData[1]['answered_incorrectly'].toInt()}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${combinedData[2]['answered_incorrectly'].toInt()}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

