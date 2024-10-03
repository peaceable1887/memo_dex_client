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
        onTap: widget.onPressed,
        child: Container(
          width: countTextLength(widget.btnText),
          child: AppBar(
            scrolledUnderElevation: 0,
            leadingWidth: 15,
            title: Text(
              widget.btnText,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            leading: IconButton(
              color: Theme.of(context).colorScheme.surface,
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
