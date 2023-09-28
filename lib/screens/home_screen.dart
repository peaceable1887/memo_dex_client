import 'package:flutter/material.dart';

import '../services/rest_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    printTest();
    super.initState();
  }

  void printTest(){
    RestServices(context).getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Willkommen!"),
    );
  }
}
