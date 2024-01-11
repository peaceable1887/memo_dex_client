import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/widgets/statistic_card.dart';
import '../helperClasses/filters.dart';
import '../services/file_handler.dart';
import '../services/rest_services.dart';
import '../widgets/headline.dart';

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

  @override
  void initState()
  {
    loadStatisticCards();
    super.initState();
  }

  Future<void> loadStatisticCards() async
  {
    try
    {
      final allStacks = await RestServices(context).getAllStacks();

      if(allStacks == null)
      {
        String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

        if(fileContent.isNotEmpty)
        {
          List<dynamic> stackFileContent = jsonDecode(fileContent);

          filter.FilterStacks(statisticCards, stackFileContent, selectedOption, sortValue);

          for (var stack in stackFileContent)
          {
            if (stack['is_deleted'] == 0)
            {
              final allCards = await RestServices(context).getAllCards(stack['stack_id']);

              String secondFileContent = await fileHandler.readJsonFromLocalFile("allCards");

              if(secondFileContent.isNotEmpty)
              {
                List<dynamic> cardFileContent = jsonDecode(secondFileContent);

                for (var card in cardFileContent)
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
        String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

        if(fileContent.isNotEmpty)
        {
          List<dynamic> stackFileContent = jsonDecode(fileContent);

          filter.FilterStacks(statisticCards, stackFileContent, selectedOption, sortValue);

          for (var stack in stackFileContent)
          {
            if (stack['is_deleted'] == 0)
            {
              final allCards = await RestServices(context).getAllCards(stack['stack_id']);

              String secondFileContent = await fileHandler.readJsonFromLocalFile("allCards");

              if(secondFileContent.isNotEmpty)
              {
                List<dynamic> cardFileContent = jsonDecode(secondFileContent);

                for (var card in cardFileContent)
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
    loadStatisticCards();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00324E),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,80,0,0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Headline(text: "Statistic"),
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
                    Text(
                      selectedOption,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600
                      ),
                    ),
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
                        color: Color(0xFFE59113),
                      ) : Icon(
                        Icons.arrow_upward_rounded,
                        size: selectedOption == "ALL STACKS" ? 0.0 : 28.0,
                        color: Color(0xFFE59113),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showMenu(
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
                                      ? Color(0xFFE59113)
                                      : Colors.black,
                                  fontWeight: selectedOption == "STACKNAME"
                                      ?  FontWeight.w600
                                      :  FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.sort_by_alpha_rounded,
                                size: 20.0,
                                color: selectedOption == "STACKNAME"
                                    ? Color(0xFFE59113)
                                    : Colors.black,
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
                                      ? Color(0xFFE59113)
                                      : Colors.black,
                                  fontWeight: selectedOption == "CREATION DATE"
                                      ?  FontWeight.w600
                                      :  FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.date_range_rounded,
                                size: 20.0,
                                color: selectedOption == "CREATION DATE"
                                    ? Color(0xFFE59113)
                                    : Colors.black,
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
                                    color: Colors.grey,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 20.0,
                                  color: Colors.grey,
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
                            ? Color(0xFFE59113)
                            : Colors.white,
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
            child: ListView.builder(
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

