import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:memo_dex_prototyp/screens/welcome_screen.dart';
import 'package:memo_dex_prototyp/themes/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget
{
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
{
  late SharedPreferences _prefs;

  @override
  void initState()
  {
    super.initState();
    init();
  }

  Future init() async
  {
    _prefs = await SharedPreferences.getInstance();

    Get.changeThemeMode(
        _prefs.getBool("isDarkMode")! ? ThemeMode.dark : ThemeMode.light
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return GetMaterialApp(
      title: 'MemoDex App',
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode: ThemeMode.system,
      home: const WelcomeScreen(),
    );
  }
}