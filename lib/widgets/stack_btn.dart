import 'package:flutter/material.dart';

class StackBtn extends StatelessWidget {

  final String iconColor;
  final String stackName;

  const StackBtn({Key? key, required this.iconColor, required this.stackName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){},
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
            color: Color(int.parse("0xFF$iconColor")),
          ),
          Text(
            stackName,
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
