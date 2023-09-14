import 'package:flutter/material.dart';

class TopNavigationBar extends StatelessWidget {
  final Widget onPressed;

  const TopNavigationBar({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => onPressed,
              ),);}
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
