import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/setting_screen.dart';
import 'package:memo_dex_prototyp/screens/statistic_screen.dart';

import '../services/rest_services.dart';
import '../widgets/headline.dart';
import '../widgets/top_search_bar.dart';
import 'home_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {

  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    StatisticScreen(),
    SettingScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void printTest() {
    RestServices(context).getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00324E),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        iconSize: 50,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        selectedLabelStyle: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.w600,),
        unselectedLabelStyle: TextStyle(fontFamily: "Inter", fontWeight: FontWeight.w600,),
        selectedItemColor: Color(0xFFE59113),
        unselectedItemColor: Color(0xFF8597A1),
        items:[
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart_outlined_outlined),
              label: "Statistic"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              label: "Settings"
          ),
        ],
      ),
    );
  }
}
