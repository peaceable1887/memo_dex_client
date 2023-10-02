import 'package:flutter/material.dart';

class TopNavigationBar extends StatelessWidget {
  final VoidCallback onPressed;

  const TopNavigationBar({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: onPressed,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
