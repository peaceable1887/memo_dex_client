import 'package:flutter/material.dart';

class StackContentBtn extends StatefulWidget {

  final String iconColor;
  final String backgroundColor;
  final String btnText;
  final Widget onPressed;
  final IconData icon;

  const StackContentBtn({Key? key, required this.iconColor, required this.btnText, required this.backgroundColor, required this.onPressed, required this.icon}) : super(key: key);

  @override
  State<StackContentBtn> createState() => _StackContentBtnState();
}

class _StackContentBtnState extends State<StackContentBtn> {

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget.onPressed,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(100, 200),
        backgroundColor: Color(int.parse("0xFF${widget.backgroundColor}")),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            widget.icon,
            size: 95.0,
            color: Color(int.parse("0xFF${widget.iconColor}")),
          ),
          Text(
            widget.btnText,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: "Inter",
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

