import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/widgets/buttons/statistic_card_btn.dart';
import 'package:memo_dex_prototyp/widgets/text/headlines/headline_medium.dart';
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,80,0,0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const HeadlineLarge(text: "Statistic"),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
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
                    showMenu(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      context: context,
                      position: RelativeRect.fromLTRB(1, 220, 0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      items: [
                        PopupMenuItem(
                          onTap: (){
                            setState(() {
                              selectedOption = "STACKNAME";
                              loadStatisticCards();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Stackname",
                                style: TextStyle(
                                  color: selectedOption == "STACKNAME"
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.surface,
                                  fontWeight: selectedOption == "STACKNAME"
                                      ?  FontWeight.w600
                                      :  FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.sort_by_alpha_rounded,
                                size: 20.0,
                                color: selectedOption == "STACKNAME"
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surface,
                              ),
                            ],
                          ),
                          value: "STACKNAME",
                        ),
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Creation Date",
                                style: TextStyle(
                                  color: selectedOption == "CREATION DATE"
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.surface,
                                  fontWeight: selectedOption == "CREATION DATE"
                                      ?  FontWeight.w600
                                      :  FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.date_range_rounded,
                                size: 20.0,
                                color: selectedOption == "CREATION DATE"
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.surface,
                              ),
                            ],
                          ),
                          value: "CREATION DATE",
                        ),
                        if (selectedOption == "STACKNAME" || selectedOption == "CREATION DATE")
                          PopupMenuItem(
                            onTap: (){
                              setState(() {
                                selectedOption = "";
                                loadStatisticCards();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reset",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 20.0,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ],
                            ),
                            value: "ALL STACKS",
                          ),
                      ],
                    ).then((value) {
                      setState(() {
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
          Expanded(
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
          )
        ],
      ),
    );
  }
}