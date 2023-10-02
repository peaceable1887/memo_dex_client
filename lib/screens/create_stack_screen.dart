import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';

import '../widgets/headline.dart';
import '../widgets/top_navigation_bar.dart';
import '../widgets/top_search_bar.dart';
import 'home_screen.dart';

class CreateStackScreen extends StatefulWidget {
  const CreateStackScreen({Key? key}) : super(key: key);

  @override
  State<CreateStackScreen> createState() => _CreateStackScreenState();
}

class _CreateStackScreenState extends State<CreateStackScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopNavigationBar(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigationScreen(),
              ),
            );
          },
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Headline(text: "Create Stack"),
            ],
          ),
        ),
      ],
    );
  }
}