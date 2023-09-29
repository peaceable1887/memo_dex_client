import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/setting_screen.dart';
import 'package:memo_dex_prototyp/screens/statistic_screen.dart';
import 'package:memo_dex_prototyp/widgets/stack_view_grid.dart';

import '../services/rest_services.dart';
import '../widgets/headline.dart';
import '../widgets/top_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopSearchBar(
          onPressed: () {},
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Headline(text: "Home"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ALL STACKS",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600
                ),
              ),
              InkWell(
                onTap: () {
                  // Aktion, die bei einem Klick auf das Icon ausgeführt wird
                },
                child: Icon(
                  Icons.filter_alt,
                  size: 32.0,
                  color: Colors.white,
                ), // Icon als klickbares Element
              )
            ],
          ),
        ),
        Flexible(
          child: StackViewGrid(),
        ),
      ],
    );

  }
}