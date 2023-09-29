import 'package:flutter/material.dart';

class TopSearchBar extends StatelessWidget {

  final VoidCallback? onPressed;

  const TopSearchBar({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        leading: PreferredSize(
          preferredSize: Size(0, 0), // sorgt dafür das der Pfeil nicht dargestellt wird
          child: Container(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: onPressed,
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}