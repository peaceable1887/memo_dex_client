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

  void pushToStackContent(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StackContentScreen(stackId: widget.stackId),
      ),
    );
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
          Text(
            widget.stackName,
            style: TextStyle(
                color: Colors.black,
              fontSize: 16,
              fontFamily: "Inter",
              fontWeight: FontWeight.w700,

            ),
          ),
        ],
      ),
    );
  }
}
