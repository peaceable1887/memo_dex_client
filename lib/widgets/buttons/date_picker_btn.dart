import 'package:flutter/cupertino.dart';
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
    return CupertinoButton(
      child: Icon(
        Icons.calendar_month_rounded,
        size: 22.0,
        color: Colors.white,
      ),
      onPressed: (){
        showModalBottomSheet(
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          context: context,
          builder: (BuildContext context) => SizedBox(
            height: 300,
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
                SizedBox(
                  height: 200, // Set a bounded height here
                  child: CupertinoDatePicker(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    initialDateTime: selectedDate,
                    onDateTimeChanged: (DateTime newTime) {
                      setState(() {
                        selectedDate = newTime;
                        selectedMonth = newTime.month;
                        selectedYear = newTime.year;
                        widget.onDateSelected(selectedYear, selectedMonth);
                      });
                    },
                    mode: CupertinoDatePickerMode.monthYear,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
