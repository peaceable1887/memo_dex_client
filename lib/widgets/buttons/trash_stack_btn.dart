import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/widgets/buttons/button.dart';

import '../../services/api/api_client.dart';
import '../../utils/trim.dart';

class TrashStackBtn extends StatefulWidget
{
  final dynamic stackId;
  final String iconColor;
  final String stackName;
  final Function(bool) onClicked;

  const TrashStackBtn({
    super.key,
    this.stackId,
    required this.iconColor,
    required this.stackName, required this.onClicked});

  @override
  State<TrashStackBtn> createState() => _TrashStackBtnState();
}

class _TrashStackBtnState extends State<TrashStackBtn>
{
  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(int.parse("0xFF${widget.iconColor}")),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Icon(
                      CupertinoIcons.square_stack_3d_up_fill,
                      size: 85.0,
                      color: Colors.white, // Ändere diese Farbe nach deinen Wünschen
                    ),
                  ),
                  Container(
                    width: 125,
                    height: 50,
                    child: Center(
                      child: Text(
                        Trim().trimText(widget.stackName, 10),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                child: Column(
                  children: [
                    Button(
                      backgroundColor: Colors.green,
                      textColor: Color(0xFF00324E),
                      text: "Undo",
                      onPressed: () async {
                        await ApiClient(context).stackApi.undoStack(widget.stackId);
                        widget.onClicked(true);
                      },
                      borderColor: Colors.green,
                    ),
                    Button(
                      backgroundColor: Color(0xFF00324E),
                      textColor: Colors.red,
                      text: "Delete",
                      onPressed: () async
                      {
                        await ApiClient(context).stackApi.deleteStackFromDatabase(widget.stackId);
                        widget.onClicked(true);
                      },
                      borderColor: Colors.red,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
