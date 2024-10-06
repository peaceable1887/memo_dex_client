import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/widgets/buttons/statistic_card_btn.dart';
import 'package:memo_dex_prototyp/widgets/text/headlines/headline_medium.dart';
import '../utils/divide_painter.dart';
import '../utils/filters.dart';
import '../services/local/file_handler.dart';
import '../widgets/text/headlines/headline_large.dart';
import 'bottom_navigation_screen.dart';

class StatisticScreen extends StatefulWidget
{
  const StatisticScreen({Key? key}) : super(key: key);

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen>
{
  List<Widget> statisticCards = [];
  List<int> isNoticed = [];
  List<int> isNotNoticed = [];
  FileHandler fileHandler = FileHandler();
  String selectedOption = "ALL STACKS";
  bool sortValue = false;
  final filter = Filters();
  bool showLoadingCircular = true;
  final storage = FlutterSecureStorage();
  late StreamSubscription subscription;

  @override
  void initState()
  {
    super.initState();
    loadStatisticCards();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    async
    {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => BottomNavigationScreen()),
      );
    });

  }

  Future<void> loadStatisticCards() async
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

        if(fileContent.isNotEmpty)
        {
          List<dynamic> stackFileContent = jsonDecode(fileContent);

          filter.FilterStacks(statisticCards, stackFileContent, selectedOption, sortValue);

          for (var stack in stackFileContent)
          {
            if (stack['is_deleted'] == 0)
            {
              String secondFileContent = await fileHandler.readJsonFromLocalFile("allCards");

              if(secondFileContent.isNotEmpty)
              {
                List<dynamic> cardFileContent = jsonDecode(secondFileContent);

                for (var card in cardFileContent)
                {
                  if(card['stack_stack_id'] == stack["stack_id"])
                  {
                    if (card["remember"] == 1 && card["is_deleted"] == 0)
                    {
                      isNoticed.add(card["remember"]);
                    }
                    if (card["remember"] == 0 && card["is_deleted"] == 0)
                    {
                      isNotNoticed.add(card["remember"]);
                    }
                  }
                }

                statisticCards.add(StatisticCard(
                  stackId: stack['stack_id'],
                  color: stack['color'],
                  stackName: stack['stackname'],
                  noticed: isNoticed.length,
                  notNoticed: isNotNoticed.length,
                )
                );
                isNoticed.clear();
                isNotNoticed.clear();
              }
            }
          }
        }
      }else
      {
        await ApiClient(context).stackApi.getAllStacks();

        setState(()
        {
          showLoadingCircular = false;
        });

        String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

        if(fileContent.isNotEmpty)
        {
          List<dynamic> stackFileContent = jsonDecode(fileContent);

          filter.FilterStacks(statisticCards, stackFileContent, selectedOption, sortValue);

          for (var stack in stackFileContent)
          {
            if (stack['is_deleted'] == 0)
            {
              await ApiClient(context).cardApi.getAllCardsByStackId(stack['stack_id']);

              String secondFileContent = await fileHandler.readJsonFromLocalFile("allCards");

              if(secondFileContent.isNotEmpty)
              {
                List<dynamic> cardFileContent = jsonDecode(secondFileContent);

                for (var card in cardFileContent)
                {
                  if(card['stack_stack_id'] == stack["stack_id"])
                  {
                    if (card["remember"] == 1 && card["is_deleted"] == 0)
                    {
                      isNoticed.add(card["remember"]);
                    }
                    if (card["remember"] == 0 && card["is_deleted"] == 0)
                    {
                      isNotNoticed.add(card["remember"]);
                    }
                  }
                }
                statisticCards.add(StatisticCard(
                  stackId: stack['stack_id'],
                  color: stack['color'],
                  stackName: stack['stackname'],
                  noticed: isNoticed.length,
                  notNoticed: isNotNoticed.length,
                )
                );
                isNoticed.clear();
                isNotNoticed.clear();
              }
            }
          }
        }
      }
      if(mounted)
      {
        setState((){});
      }
    }catch(error)
    {
      print('Fehler beim Laden der Daten: $error');
    }
  }


  @override
  void dispose()
  {
    print("dispose statistic screen");
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBodyBehindAppBar: true, //TODO nochmal gucken was es macht
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
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
              title: const HeadlineLarge(text: "Statistic", isInSliverAppBar: true,),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      HeadlineMedium(text: selectedOption),
                      InkWell(
                        onTap: ()
                        {
                          setState(()
                          {
                            sortValue =! sortValue;
                            loadStatisticCards();
                          });
                        },
                        child: sortValue == false ? Icon(
                          Icons.arrow_downward_rounded,
                          size: selectedOption == "ALL STACKS" ? 0.0 : 28.0,
                          color: Theme.of(context).colorScheme.primary,
                        ) : Icon(
                          Icons.arrow_upward_rounded,
                          size: selectedOption == "ALL STACKS" ? 0.0 : 28.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        context: context,
                        builder: (BuildContext context){
                          return SizedBox(
                              height: 250,
                              child: Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Container(
                                        height: 7,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 45),
                                  CustomPaint(
                                    size: Size(MediaQuery.of(context).size.width, 0.2),
                                    painter: DividePainter(Theme.of(context).scaffoldBackgroundColor),
                                  ),
                                  SizedBox(height: 15),
                                  PopupMenuItem(
                                    onTap: (){
                                      setState(() {
                                        selectedOption = "STACKNAME";
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          child: Icon(
                                            Icons.sort_by_alpha_rounded,
                                            size: 30.0,
                                            color: selectedOption == "STACKNAME"
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          "Stackname",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: selectedOption == "STACKNAME"
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.onSurface,
                                            fontWeight: selectedOption == "STACKNAME"
                                                ?  FontWeight.w600
                                                :  FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    value: "STACKNAME",
                                  ),
                                  SizedBox(height: 5),
                                  PopupMenuItem(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          child: Icon(
                                            Icons.date_range_rounded,
                                            size: 30.0,
                                            color: selectedOption == "CREATION DATE"
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          "Creation Date",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: selectedOption == "CREATION DATE"
                                                ? Theme.of(context).colorScheme.primary
                                                : Theme.of(context).colorScheme.onSurface,
                                            fontWeight: selectedOption == "CREATION DATE"
                                                ?  FontWeight.w600
                                                :  FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    value: "CREATION DATE",
                                  ),
                                  SizedBox(height: 5),
                                  PopupMenuItem(
                                    onTap: (selectedOption == "STACKNAME" || selectedOption == "CREATION DATE") ? (){
                                      setState(() {
                                        selectedOption = "";
                                        loadStatisticCards();
                                      });
                                    } : (){},
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          child: Icon(
                                            Icons.refresh_rounded,
                                            size: 30.0,
                                            color: (selectedOption == "STACKNAME" || selectedOption == "CREATION DATE") ? Colors.white : Theme.of(context).colorScheme.tertiary,
                                          ),
                                        ),
                                        Text(
                                          "Reset",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: (selectedOption == "STACKNAME" || selectedOption == "CREATION DATE") ? Colors.white : Theme.of(context).colorScheme.tertiary,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                    value: "ALL STACKS",
                                  ),
                                ],
                              )
                          );
                        },
                      ).then((value) {
                        setState(() {
                          print(selectedOption);
                          selectedOption = value!;
                        });
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.filter_alt,
                          size: 32.0,
                          color: selectedOption == "STACKNAME" || selectedOption == "CREATION DATE"
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surface,
                          /*selectedOption == "STACKNAME" || selectedOption == "CREATION DATE"
                            ? Icons.filter_alt : Icons.filter_alt_outlined,
                        size: 32.0,
                        color: Colors.white,*/
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          showLoadingCircular ?
          SliverToBoxAdapter(
            child: Container(
                height: MediaQuery.of(context).size.height/2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                )
            ),
          ):
          SliverList(
              delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return statisticCards[index];
            },
            childCount: statisticCards.length,
          ))
          /*Expanded(
            child: showLoadingCircular ?
            Container(
                height: MediaQuery.of(context).size.height/2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ],
                )
            ): ListView.builder(
              itemCount: statisticCards.length,
              itemBuilder: (context, index) {
                return statisticCards[index];
              },
            ),
          )*/
        ],
      ),
    );
  }
}