import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/statistic_stack_screen.dart';
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

  late List<GDPData> _chartData;
  late double progressValue;

  @override
  void initState() {
    super.initState();
    progressInPercent(widget.noticed, widget.notNoticed);
    _chartData = getChartData(widget.notNoticed);
  }

  void progressInPercent(noticed, notNoticed)
  {
    if(notNoticed == 0)
    {
      notNoticed = 1;
    }

    setState(() {
      progressValue = (noticed/(noticed+notNoticed))*100;
    });
  }

  List<GDPData> getChartData(isNotNoticed)
  {

    if(isNotNoticed == 0)
    {
      isNotNoticed = 1;
    }

    final List<GDPData> chartData = [
      GDPData("Noticed", widget.noticed, Colors.white),
      GDPData("Noticed", isNotNoticed, Color(0xFFD1D1D1)),
    ];

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(int.parse("0xFF${widget.color}")),
            border: Border.all(color: Colors.white, width: 3),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StatisticStackScreen(stackId: widget.stackId,),
              ),
            );
          },
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5) ,
                height: 110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                          DoughnutSeries<GDPData, String>(
                              radius: "48",
                              dataSource: _chartData,
                              pointColorMapper:(GDPData data,  _) => data.color,
                              xValueMapper: (GDPData data, _) => data.continent,
                              yValueMapper: (GDPData data, _) => data.gdp,
                              innerRadius: '69%'
                          )
                        ],
                      ),
                    ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(5, MediaQuery.of(context).size.height/29, 10, 5),
                        child: Container(
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 2),
                                    child: Text(
                                      widget.stackName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 25.0,
                                    color: Colors.white, // Ändere diese Farbe nach deinen Wünschen
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GDPData{
  GDPData(this.continent, this.gdp, this.color);
  final String continent;
  final int gdp;
  final Color color;
}