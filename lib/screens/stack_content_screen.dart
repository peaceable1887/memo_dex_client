import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import 'package:memo_dex_prototyp/widgets/stack_content_btn.dart';

import '../widgets/card_btn.dart';
import '../widgets/headline.dart';
import '../widgets/top_navigation_bar.dart';

class StackContentScreen extends StatefulWidget {
  const StackContentScreen({Key? key}) : super(key: key);

  @override
  State<StackContentScreen> createState() => _StackContentScreenState();
}

class _StackContentScreenState extends State<StackContentScreen> {

  final List<Widget> startLearningButtons = [
    StackContentBtn(iconColor: "FFFFFF", btnText: "Chronologic", backgroundColor: "34A853"),
    StackContentBtn(iconColor: "FFFFFF", btnText: "Mixed", backgroundColor: "E57435")
  ];

  final List<Widget> cards = [
    CardBtn(btnText: "Capital of Germany?"),
    CardBtn(btnText: "Capital of Germany?"),
    CardBtn(btnText: "Capital of Germany?"),
    CardBtn(btnText: "Capital of Germany?"),
    CardBtn(btnText: "Capital of Germany?"),
    CardBtn(btnText: "Capital of Germany?"),
    CardBtn(btnText: "Capital of Germany?"),
    CardBtn(btnText: "Capital of Germany?"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00324E),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0,5,0,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: 100,
                  child: TopNavigationBar(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavigationScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,20,0),
                  child: Container(
                    width: 80,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              // Aktion, die bei einem Klick auf das Icon ausgeführt wird
                            },
                            child: Icon(
                              Icons.add_rounded,
                              size: 38.0,
                              color: Colors.white,
                            ), // Icon als klickbares Element
                          ),
                          InkWell(
                            onTap: () {
                              // Aktion, die bei einem Klick auf das Icon ausgeführt wird
                            },
                            child: Icon(
                              Icons.edit_outlined,
                              size: 30.0,
                              color: Colors.white,
                            ), // Icon als klickbares Element
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0.0 ,10,0,0),
            child: Headline(
                text: "Computer Science"
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,40,0,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "START LEARNING",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 200, // Feste Höhe von 200
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                crossAxisCount: 2,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 2.3),
              ),
              itemBuilder: (context, index) {
                return startLearningButtons[index];
              },
              itemCount: startLearningButtons.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "ALL CARDS",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
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
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 20.0,
                crossAxisCount: 1,
                childAspectRatio: MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.height / 14),
              ),
              itemBuilder: (context, index) {
                return cards[index];
              },
              itemCount: cards.length,
            ),
          ),

        ],
      ),
    );
  }
}
