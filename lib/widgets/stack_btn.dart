import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';

class StackBtn extends StatefulWidget {

  final dynamic stackId;
  final String iconColor;
  final String stackName;

  const StackBtn({Key? key, required this.iconColor, required this.stackName, this.stackId}) : super(key: key);

  @override
  State<StackBtn> createState() => _StackBtnState();
}

class _StackBtnState extends State<StackBtn> {

  late bool isTooLong;

  void pushToStackContent(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StackContentScreen(stackId: widget.stackId),
      ),
    );
  }

  String trimText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + "...";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: pushToStackContent,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 95.0,
            color: Color(int.parse("0xFF${widget.iconColor}")),
          ),
          Container(
            width: 150,
            child: Center(
              child: Text(
                trimText(widget.stackName, 30),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                  fontSize: 16,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
