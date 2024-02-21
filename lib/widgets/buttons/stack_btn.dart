import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:memo_dex_prototyp/screens/stack/stack_content_screen.dart';

import '../../utils/trim.dart';

class StackBtn extends StatefulWidget {

  final dynamic stackId;
  final String iconColor;
  final String stackName;

  const StackBtn({Key? key, required this.iconColor, required this.stackName, this.stackId}) : super(key: key);

  @override
  State<StackBtn> createState() => _StackBtnState();
}

class _StackBtnState extends State<StackBtn>
{
  void pushToStackContent()
  {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => StackContentScreen(stackId: widget.stackId),
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.15),
            blurRadius: 15.0,
            offset: Offset(4, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: pushToStackContent,
        style: ElevatedButton.styleFrom(
          //backgroundColor: Color(int.parse("0xFF${widget.iconColor}")),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          elevation: 0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                CupertinoIcons.square_stack_3d_up_fill,
                size: 85.0,
                color: Color(int.parse("0xFF${widget.iconColor}")), // Ändere diese Farbe nach deinen Wünschen
              ),
            ),
            Container(
              width: 150,
              child: Center(
                child: Text(
                  Trim().trimText(widget.stackName, 10),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
