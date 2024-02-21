import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/setting_screen.dart';
import 'package:memo_dex_prototyp/screens/statistic_screen.dart';

import 'home_screen.dart';

class BottomNavigationScreen extends StatefulWidget {

  final int? index;

  const BottomNavigationScreen({Key? key, this.index}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {

  int currentIndex = 0;
  bool snackbarIsDisplayed = false;
  final screens = [HomeScreen(), StatisticScreen(), SettingScreen(),];
  late StreamSubscription subscription;

  @override
  void initState()
  {
    super.initState();
    updateIndex();
    checkInternetConnection();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    {
      checkInternetConnection();
    });
  }

  void updateIndex()
  {
    if(widget.index == 1)
    {
      currentIndex = 1;
    }
    if(widget.index == 2)
    {
      currentIndex = 2;
    }
  }

  Future<void> checkInternetConnection() async
  {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

    setState(() {
      if (!isConnected) {
        snackbarIsDisplayed = false;
      } else {
        snackbarIsDisplayed = true;
      }
    });
  }

  @override
  void dispose()
  {
    subscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: screens[currentIndex],
      bottomNavigationBar: Padding(
        padding: snackbarIsDisplayed ? const EdgeInsets.fromLTRB(0, 0, 0, 0) : const EdgeInsets.fromLTRB(0, 0, 0, 52),
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          iconSize: 50,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600,),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600,),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.tertiary,
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
      ),
    );
  }
}
