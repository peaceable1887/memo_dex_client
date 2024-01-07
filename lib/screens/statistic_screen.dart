import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/widgets/statistic_card.dart';

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

  @override
  void initState()
  {
    loadStatisticCards();
    super.initState();
  }

  Future<void> loadStatisticCards() async
  {
    final allStacks = await RestServices(context).getAllStacks();

      for (var stack in allStacks)
      {
        if (stack['is_deleted'] == 0)
        {
          final allCards = await RestServices(context).getAllCards(stack['stack_id']);

          for (var card in allCards)
          {
            if(card["remember"] == 1)
            {
              isNoticed.add(card["remember"]);
            }else
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
      if(mounted)
      {
        setState((){});
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "OVERVIEW",
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "STACKS",
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
