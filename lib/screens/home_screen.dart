import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/setting_screen.dart';
import 'package:memo_dex_prototyp/screens/statistic_screen.dart';

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
    return Stack(
      children: [
        Container(
          child: ListView(
            children: [
              Container(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Headline(text: "Home"),
                  ],
                ),
              ),
            ],
          ),
        ),
        TopSearchBar(
          onPressed: () {},
        ),
      ],
    );
  }
}