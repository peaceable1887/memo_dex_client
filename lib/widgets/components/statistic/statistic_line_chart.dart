import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StatisticLineChart extends StatefulWidget {

  final List<Map<String, dynamic>> runInformation;
  final int year;
  final int month;

  const StatisticLineChart({super.key, required this.month, required this.runInformation, required this.year});

  @override
  State<StatisticLineChart> createState() => _StatisticLineChartState();
}

class _StatisticLineChartState extends State<StatisticLineChart>
{
  double _maxNumberOfRuns = 25.0;
  late int _currentYear;
  late int _currentMonth;

  @override
  void initState()
  {
    super.initState();
  }

  int getMonthLength(int month)
  {
    if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
    {
      return 31;
    }
    if(month == 4 || month == 6 || month == 9 || month == 11)
    {
      return 30;
    }
    if(month == 2)
    {
      return 28;
    }else
    {
      return 0;
    }
  }

  List<FlSpot> getFlSpots()
  {
    List<FlSpot> list = [];

    if (widget.runInformation.isNotEmpty)
    {
      for(int i = 0; i < widget.runInformation.length; i++)
      {
        List<String> splitFormattedDate = widget.runInformation[i]["date"].split("-");
        int year = int.parse(splitFormattedDate[0].trim());
        int month = int.parse(splitFormattedDate[1].trim());
        int day = int.parse(splitFormattedDate[2].trim());

        setState(()
        {
          _currentYear = widget.year;
          _currentMonth = widget.month;
        });

        if(year == _currentYear && month == _currentMonth)
        {
          list.add(FlSpot(day.toDouble(), widget.runInformation[i]["numberOfRuns"].toDouble()));
        }

      }
      calculateMaxNumberOfRuns();
      return list;

    }else
    {
      print("Die Liste von getFlSpots ist leer.");
      return [];
    }
  }

  void calculateMaxNumberOfRuns()
  {
    if (widget.runInformation.isNotEmpty)
    {
      double maxRuns = widget.runInformation[0]["numberOfRuns"].toDouble();

      for (int i = 0; i < widget.runInformation.length; i++)
      {
        double currentRuns = widget.runInformation[i]["numberOfRuns"].toDouble();
        if (currentRuns >= maxRuns)
        {
          setState(()
          {
            if(currentRuns >= _maxNumberOfRuns)
            {
              _maxNumberOfRuns = currentRuns;
            }

          });
        }
      }
      print("Der maximale Wert der Anzahl der Läufe ist: $_maxNumberOfRuns");
    } else
    {
      print("Die Liste von runInformation ist leer.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: getFlSpots(),
              isCurved: true,
              dotData: FlDotData(show: true),
              color: Color(0xFFE59113),
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.white.withOpacity(0.0),
              ),
            ),
          ],
          minX: 0,
          maxX: getMonthLength(widget.month).toDouble(),
          minY: 0,
          maxY: _maxNumberOfRuns,
          backgroundColor: Color(0xFF00324E),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5,
                getTitlesWidget: (value, meta)
                {
                  int runText = value.toInt();
                  String text = runText.toString();
                  return Text(
                    text,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: const Text(
                "Day",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500
                ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                interval: 5,
                getTitlesWidget: (value, meta)
                {
                  int monthText = value.toInt();
                  String text = monthText.toString();

                  return Text(
                    text,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500
                    ),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.5),
              strokeWidth: 0.2,
            ),
            drawVerticalLine: true,
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.white.withOpacity(0.5),
              strokeWidth: 0.2,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.white,
              width: 0,
            ),
          ),
        ),
      ),
    );
  }
}
