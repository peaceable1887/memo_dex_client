import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/models/stack_statistic_data.dart';
import 'package:memo_dex_prototyp/utils/trim.dart';
import 'package:memo_dex_prototyp/screens/statistic/statistic_stack_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class StatisticCard extends StatefulWidget {

  final dynamic stackId;
  final String color;
  final String stackName;
  final int noticed;
  final int notNoticed;

  const StatisticCard({super.key, this.stackId, required this.color, required this.stackName, required this.noticed, required this.notNoticed});

  @override
  State<StatisticCard> createState() => _StatisticCardState();
}

class _StatisticCardState extends State<StatisticCard> {

  late List<StackStatisticData> _stackData;
  late double progressValue;

  @override
  void initState() {
    super.initState();
    progressInPercent(widget.noticed, widget.notNoticed);
    _stackData = getStackData(widget.notNoticed);
  }

  @override
  void didUpdateWidget(covariant StatisticCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Überprüfe, ob die Daten geändert wurden, bevor du sie aktualisierst
    if (widget.noticed != oldWidget.noticed || widget.notNoticed != oldWidget.notNoticed) {
      progressInPercent(widget.noticed, widget.notNoticed);
      _stackData = getStackData(widget.notNoticed);
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

  List<StackStatisticData> getStackData(notNoticed)
  {

    if(notNoticed == 0 && widget.noticed == 0)
    {
      notNoticed = 1;
    }

    Color originalColor = Colors.white;
    Color darkerColor = Color.fromARGB(
      originalColor.alpha,
      (originalColor.red * 0.7).round(),
      (originalColor.green * 0.7).round(),
      (originalColor.blue * 0.7).round(),
    );

    final List<StackStatisticData> stackData = [
      StackStatisticData("Noticed", widget.noticed, originalColor),
      StackStatisticData("Noticed", notNoticed, darkerColor),
    ];

    return stackData;
  }

  @override
  void dispose()
  {
    print("dispose statistic card");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(int.parse("0xFF${widget.color}")), /*Color(int.parse("0xFF${widget.color}")),*/
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.15),
              blurRadius: 15.0,
              offset: Offset(4, 10),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => StatisticStackScreen(
                  stackId: widget.stackId,
                  stackname: widget.stackName,
                  color: widget.color,
                  noticed: widget.noticed,
                  notNoticed: widget.notNoticed,
                ),
              ),
            );
          },
          child: Container(
            height: 110,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.square_stack_3d_up_fill,
                              size: 28.0,
                              color: Colors.white, // Ändere diese Farbe nach deinen Wünschen
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                              child: Text(
                                Trim().trimText(widget.stackName, 14),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Click to see more details",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 2,),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14.0,
                              color: Colors.white, // Ändere diese Farbe nach deinen Wünschen
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: 130,
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
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                                  child: const Text(
                                    '%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
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
                          radius: "47",
                          dataSource: _stackData,
                          pointColorMapper:(StackStatisticData data,  _) => data.color,
                          xValueMapper: (StackStatisticData data, _) => data.stackName,
                          yValueMapper: (StackStatisticData data, _) => data.memorized,
                          innerRadius: '67%',
                          animationDuration: 0,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
