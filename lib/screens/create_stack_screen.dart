import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import '../widgets/create_stack_form.dart';
import '../widgets/headline.dart';
import '../widgets/top_navigation_bar.dart';

class CreateStackScreen extends StatefulWidget {
  const CreateStackScreen({Key? key}) : super(key: key);

  @override
  State<CreateStackScreen> createState() => _CreateStackScreenState();
}

class _CreateStackScreenState extends State<CreateStackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xFF00324E),
            child: ListView(
              children: [
                Container(
                  height: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Headline(
                          text: "Create Stack"
                      ),
                    ],
                  ),
                ),
                Container(
                    child: CreateStackForm(),
                ),// Container LoginForm
              ],
            ),
          ),
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
        ],
      ),
    );
  }
}