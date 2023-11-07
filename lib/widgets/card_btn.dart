import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/single_card_screen.dart';

class CardBtn extends StatefulWidget {

  final dynamic stackId;
  final dynamic cardId;
  final String btnText;

  const CardBtn({Key? key, required this.btnText, this.stackId, this.cardId}) : super(key: key);

  @override
  State<CardBtn> createState() => _CardBtnState();
}

class _CardBtnState extends State<CardBtn> {

  String trimText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + "...";
    }
  }


  void pushToCardContent(){
    print(widget.stackId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SingleCardScreen(stackId: widget.stackId, cardId: widget.cardId,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,0,0,15),
      child: ElevatedButton(
        onPressed: pushToCardContent,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 32.0,
                  color: Color(0xFFE59113),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                  child: Text(
                    trimText(widget.btnText, 25),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 28.0,
              color: Color(0xFF8597A1),
            ),
          ],
        ),
      ),
    );
  }
}
