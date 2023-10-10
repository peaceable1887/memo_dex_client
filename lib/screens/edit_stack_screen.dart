import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import '../widgets/create_stack_form.dart';
import '../widgets/edit_stack_form.dart';
import '../widgets/headline.dart';
import '../widgets/top_navigation_bar.dart';

class EditStackScreen extends StatefulWidget {

  final dynamic stackId;

  const EditStackScreen({Key? key, this.stackId}) : super(key: key);

  @override
  State<EditStackScreen> createState() => _EditStackScreenState();
}

class _EditStackScreenState extends State<EditStackScreen> {
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
                          text: "Edit Stack"
                      ),
                    ],
                  ),
                ),
                Container(
                  child: EditStackForm(stackId: widget.stackId),
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