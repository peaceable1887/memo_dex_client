import 'package:flutter/material.dart';

class TopSearchBar extends StatelessWidget {

  final VoidCallback? onPressed;

  const TopSearchBar({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: PreferredSize(
        preferredSize: Size(0, 0),
        child: Container(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15,0,15,0),
          child: IconButton(
            icon: Icon(Icons.search, size: 32.0,),
            onPressed: onPressed,
          ),
        ),
      ],
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false, // Damit der Zurück-Pfeil nicht erscheint
    );
  }
}