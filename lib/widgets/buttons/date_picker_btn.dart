import 'package:flutter/material.dart';

class DatePickerBtn extends StatefulWidget
{
  final Function(int year, int month) onDateSelected;

  const DatePickerBtn({super.key, required this.onDateSelected});

  @override
  State<DatePickerBtn> createState() => _DatePickerBtnState();
}

class _DatePickerBtnState extends State<DatePickerBtn>
{
  DateTime selectedDate = DateTime.now();
  late int selectedYear;
  late int selectedMonth;

  Widget showMonthAsText(int monthValue)
  {
    if(monthValue == 1)
    {
      return Text("January");
    }
    if(monthValue == 2)
    {

      return Text("February");
    }
    if(monthValue == 3)
    {

      return Text("March");
    }
    if(monthValue == 4)
    {

      return Text("April");
    }
    if(monthValue == 5)
    {

      return Text("May");
    }
    if(monthValue == 6)
    {

      return Text("June");
    }
    if(monthValue == 7)
    {

      return Text("July");
    }
    if(monthValue == 8)
    {

      return Text("August");
    }
    if(monthValue == 9)
    {

      return Text("September");
    }
    if(monthValue == 10)
    {

      return Text("October");
    }
    if(monthValue == 11)
    {

      return Text("Novemeber");
    }
    if(monthValue == 12)
    {

      return Text("December");
    }
    else
    {
      return Text("");
    }
  }

  @override
  void initState()
  {
    super.initState();
    selectedYear = DateTime.now().year;
    selectedMonth = DateTime.now().month;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("MONTH",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400
                ),
              ),
              DropdownButton<int>(
                underline: Container(
                  height: 0,
                ),
                isDense: true,
                dropdownColor: Color(0xFF00324E),
                iconEnabledColor: Colors.white,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w500
                ),
                value: selectedMonth,
                items: List.generate(
                  12, (index) => DropdownMenuItem<int>(
                    value: index + 1,
                    child: showMonthAsText(index +1),
                  ),
                ),
                onChanged: (value)
                {
                  setState(()
                  {
                    selectedMonth = value!;
                    widget.onDateSelected(selectedYear, selectedMonth);
                  });
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("YEAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400
                  ),
                ),
                DropdownButton<int>(
                  underline: Container(
                    height: 0,
                  ),
                  isDense: true,
                  dropdownColor: Color(0xFF00324E),
                  iconEnabledColor: Colors.white,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500
                  ),
                  value: selectedYear,
                  items: List.generate(
                    101, (index) => DropdownMenuItem<int>(
                      value: 2000 + index,
                      child: Text((2000 + index).toString()),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedYear = value!;
                      widget.onDateSelected(selectedYear, selectedMonth);
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
