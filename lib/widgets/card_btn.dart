import 'package:flutter/material.dart';

class CardBtn extends StatefulWidget {

  final String btnText;

  const CardBtn({Key? key, required this.btnText}) : super(key: key);

  @override
  State<CardBtn> createState() => _CardBtnState();
}

class _CardBtnState extends State<CardBtn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0,0,0,15),
      child: ElevatedButton(
        onPressed: (){},
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
                    widget.btnText,
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
