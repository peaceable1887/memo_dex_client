import 'package:flutter/material.dart';

class DropdownMenuBtn extends StatefulWidget
{
  final List<String> list;

  const DropdownMenuBtn({super.key, required this.list});

  @override
  State<DropdownMenuBtn> createState() => _DropdownMenuBtn();
}

class _DropdownMenuBtn extends State<DropdownMenuBtn>
{
  late String dropdownValue;

  @override
  void initState()
  {
    super.initState();
    dropdownValue = widget.list.first;
  }

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: DropdownButton<String>(
        value: dropdownValue,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.white,
        ),
        elevation: 16,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: "Inter",
            fontWeight: FontWeight.w500
        ),
        onChanged: (String? value) {
          // This is called when the user selects an item.
          setState(() {
            dropdownValue = value!;
          });
        },
        items: widget.list.map<DropdownMenuItem<String>>((String value)
        {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
