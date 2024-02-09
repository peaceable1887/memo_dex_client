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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
          child: Column(
            children: [
              Text("Monat",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400
                ),
              ),
              DropdownButton<int>(
                underline: Container(
                  height: 0,
                ),
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
                    child: Text((index + 1).toString()),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
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
          child: Column(
            children: [
              Text("Jahr",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400
                ),
              ),
              DropdownButton<int>(
                underline: Container(
                  height: 0,
                ),
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
      ],
    );
  }
}
