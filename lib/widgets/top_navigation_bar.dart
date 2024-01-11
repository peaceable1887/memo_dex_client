import 'package:flutter/material.dart';

class TopNavigationBar extends StatefulWidget {
  final VoidCallback onPressed;
  final String btnText;

  const TopNavigationBar({Key? key, required this.onPressed, required this.btnText}) : super(key: key);

  @override
  State<TopNavigationBar> createState() => _TopNavigationBarState();
}

class _TopNavigationBarState extends State<TopNavigationBar> {

  @override
  void initState() {
    countTextLength(widget.btnText);
    super.initState();
  }

  @override
  void dispose() {
    countTextLength(widget.btnText);
    super.dispose();
  }

  //nochmal überabreiten! noch keine ideale lösung
  double countTextLength(String text){

    double textLength = ((text.length*10)*2)+30;
    if(textLength > 170)
    {
      return 170;
    }else
    {
      return textLength;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: InkWell(
        onTap: widget.onPressed, // Füge hier die gewünschte Funktion hinzu
        child: Container(
          width: countTextLength(widget.btnText),
          child: AppBar(
            leadingWidth: 15,
            title: Text(
              widget.btnText,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: "Inter",
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back_ios),
              onPressed: widget.onPressed,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
