import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import '../../widgets/forms/create_stack_form.dart';
import '../../widgets/text/headlines/headline_large.dart';
import '../../widgets/header/top_navigation_bar.dart';

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
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  height: 170,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,20,0,0),
                        child: const HeadlineLarge(
                            text: "Create Stack"
                        ),
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
          WillPopScope(
          onWillPop: () async => false,
          child:TopNavigationBar(
              btnText: "Home",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}