import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/card/single_card_screen.dart';

class CardBtn extends StatefulWidget {

  final dynamic stackId;
  final dynamic cardId;
  final String btnText;
  final int? isNoticed;

  const CardBtn({Key? key, required this.btnText, this.stackId, this.cardId, this.isNoticed}) : super(key: key);

  @override
  State<CardBtn> createState() => _CardBtnState();
}

class _CardBtnState extends State<CardBtn> {

  bool showIcon = false;

  @override
  void initState() {
    validateIsNoticed(widget.isNoticed);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CardBtn oldWidget) {
    if (oldWidget.isNoticed != widget.isNoticed) {
      validateIsNoticed(widget.isNoticed);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    validateIsNoticed(widget.isNoticed);
    super.dispose();
  }

  String trimText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + "...";
    }
  }

  void validateIsNoticed(int? isNoticed)
  {
    if(isNoticed == 1)
    {
      showIcon = true;
    }else
    {
      showIcon = false;
    }
  }

  void pushToCardContent(){
    print(widget.stackId);
    Navigator.pushReplacement(
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
      child: Container(
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
          onPressed: pushToCardContent,
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)
                ),
              ),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              elevation: 0
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                child: Row(
                  children: [
                    Image(
                      image: AssetImage("assets/images/card_btn_icon.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,0,0),
                      child: Text(
                        trimText(widget.btnText, 25),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.lightbulb_rounded,
                    size: showIcon == true ? 22.0 : 0.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 22.0,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
