import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/add_card_screen.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import 'package:memo_dex_prototyp/screens/standard_learning_screen.dart';
import 'package:memo_dex_prototyp/screens/edit_stack_screen.dart';
import 'package:memo_dex_prototyp/services/rest_services.dart';
import 'package:memo_dex_prototyp/widgets/stack_content_btn.dart';
import '../services/file_handler.dart';
import '../widgets/card_btn.dart';

import '../widgets/components/custom_snackbar.dart';
import '../widgets/headline.dart';
import '../widgets/top_navigation_bar.dart';
import 'individual_learning_screen.dart';

class StackContentScreen extends StatefulWidget {

  final dynamic stackId;

  const StackContentScreen({Key? key, this.stackId}) : super(key: key);

  @override
  State<StackContentScreen> createState() => _StackContentScreenState();
}

class _StackContentScreenState extends State<StackContentScreen> {

  String stackname = "";
  String color = "";
  dynamic cardId;
  FileHandler fileHandler = FileHandler();
  String selectedOption = "ALL CARDS";
  bool sortValue = false;
  bool showText = false;
  bool isMixed = false;
  final List<Widget> cards = [];
  final storage = FlutterSecureStorage();

  @override
  void initState()
  {
    super.initState();
    showSnackbarInformation();
    loadStack();
    loadCards();
    showButtons();
  }

  void showSnackbarInformation() async
  {
    String? stackCreated = await storage.read(key: 'stackUpdated');
    String? addCard = await storage.read(key: 'addCard');
    if(stackCreated == "true")
    {
      CustomSnackbar.showSnackbar(
          context,
          "Information",
          "A stack was successfully edited.",
          Colors.green,
          Duration(milliseconds: 500),
          Duration(milliseconds: 1500)
      );
      await storage.write(key: 'stackUpdated', value: "false");
    }
    if(addCard == "true")
    {
      CustomSnackbar.showSnackbar(
          context,
          "Information",
          "A card was successfully created.",
          Colors.green,
          Duration(milliseconds: 500),
          Duration(milliseconds: 1500)
      );
      await storage.write(key: 'addCard', value: "false");
    }
  }

  List<Widget> showButtons()
  {
    List<Widget> startLearningButtons = [
      StackContentBtn(
          iconColor: "FFFFFF",
          btnText: "Standard",
          backgroundColor: "34A853",
          onPressed: StandardLearningScreen(stackId: widget.stackId, isMixed: isMixed),
          icon: Icons.star_border_rounded
      ),
      StackContentBtn(
          iconColor: "FFFFFF",
          btnText: "Individual",
          backgroundColor: "E57435",
          onPressed: IndividualLearningScreen(stackId: widget.stackId, isMixed: isMixed),
          icon: Icons.my_library_books_rounded
      )
    ];

    return startLearningButtons;
  }

  Future<void> loadStack() async
  {
    try
    {
      final stack  = await RestServices(context).getStack(widget.stackId);

      setState(()
      {
        stackname = stack[0]["stackname"];
        color = stack[0]["color"];
      });

    }catch(error)
    {
      print('Fehler beim Laden der Daten: $error');
    }
  }

  Future<void> loadCards() async
  {
    try
    {
      final checkRequest = await RestServices(context).getAllCards(widget.stackId);

      if(checkRequest.isEmpty)
      {
        showText = true;
      }
      if(checkRequest == null)
      {
        String fileContent = await fileHandler.readJsonFromLocalFile("allCards");
        if (fileContent.isNotEmpty)
        {
          List<dynamic> cardFileContent = jsonDecode(fileContent);

          if(selectedOption == "QUESTION" && sortValue == false)
          {
            cardFileContent.sort((a, b) => a['question'].compareTo(b['question']));
            cards.clear();
          }
          if(selectedOption == "QUESTION" && sortValue == true)
          {
            cardFileContent.sort((a, b) => b['question'].compareTo(a['question']));
            cards.clear();
          }
          if(selectedOption == "CREATION DATE" && sortValue == false)
          {
            cardFileContent.sort((a, b) => DateTime.parse(a['creation_date']).compareTo(DateTime.parse(b['creation_date'])));
            cards.clear();
          }
          if(selectedOption == "CREATION DATE" && sortValue == true)
          {
            cardFileContent.sort((a, b) => DateTime.parse(b['creation_date']).compareTo(DateTime.parse(a['creation_date'])));
            cards.clear();
          }
          if(selectedOption == "NOTICED" && sortValue == false)
          {
            cardFileContent.sort((a, b) => b['remember'].compareTo(a['remember']));
            cards.clear();
          }
          if(selectedOption == "NOTICED" && sortValue == true)
          {
            cardFileContent.sort((a, b) => a['remember'].compareTo(b['remember']));
            cards.clear();
          }
          else
          {
            cards.clear();
          }

          for (var card in cardFileContent)
          {

            if (card['is_deleted'] == 0)
            {
              cards.add(CardBtn(btnText: card["question"], stackId: widget.stackId, cardId: card["card_id"],));
              showText = false;
            }
          }
          // Widget wird aktualisiert nnach dem Laden der Daten.
          if (mounted)
          {
            setState(() {});
          }
        }
      }else
      {
        String fileContent = await fileHandler.readJsonFromLocalFile("allCards");

        if (fileContent.isNotEmpty)
        {
          List<dynamic> cardFileContent = jsonDecode(fileContent);


          if(selectedOption == "QUESTION" && sortValue == false)
          {
            cardFileContent.sort((a, b) => a['question'].compareTo(b['question']));
            cards.clear();
          }
          if(selectedOption == "QUESTION" && sortValue == true)
          {
            cardFileContent.sort((a, b) => b['question'].compareTo(a['question']));
            cards.clear();
          }
          if(selectedOption == "CREATION DATE" && sortValue == false)
          {
            cardFileContent.sort((a, b) => DateTime.parse(a['creation_date']).compareTo(DateTime.parse(b['creation_date'])));
            cards.clear();
          }
          if(selectedOption == "CREATION DATE" && sortValue == true)
          {
            cardFileContent.sort((a, b) => DateTime.parse(b['creation_date']).compareTo(DateTime.parse(a['creation_date'])));
            cards.clear();
          }
          if(selectedOption == "NOTICED" && sortValue == false)
          {
            cardFileContent.sort((a, b) => b['remember'].compareTo(a['remember']));
            cards.clear();
          }
          if(selectedOption == "NOTICED" && sortValue == true)
          {
            cardFileContent.sort((a, b) => a['remember'].compareTo(b['remember']));
            cards.clear();
          }
          else
          {
            cards.clear();
          }

          for (var card in cardFileContent)
          {
            if (card['is_deleted'] == 0)
            {
              cards.add(CardBtn(btnText: card["question"], stackId: widget.stackId, cardId: card["card_id"], isNoticed: card["remember"]));
              showText = false;
            }else
            {
              //TODO BUG: wenn die karte an den letzten index-position gelöscht wird, wird der wert auch true gesetzt
              showText = true;
            }

          }

          // Widget wird aktualisiert nnach dem Laden der Daten.
          if (mounted)
          {
            setState(() {});
          }
        }
      }
    }catch(error)
    {
      print('Fehler beim Laden der Daten: $error');
    }
  }

  void pushToAddCard(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCardScreen(stackId: widget.stackId, stackname: stackname),
      ),
    );
  }

  void pushToEditStack(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStackScreen(stackId: widget.stackId, stackname: stackname, color: color),
      ),
    );
  }

  @override
  void dispose() {
    super.initState();
    showSnackbarInformation();
    loadStack();
    loadCards();
    showButtons();
  }

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
                WillPopScope(
                onWillPop: () async => false,
                child: Container(
                    child: TopNavigationBar(
                      btnText: "Home",
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
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,15,0),
                  child: Container(
                    width: 80,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: pushToAddCard,
                            child: Icon(
                              Icons.add_rounded,
                              size: 38.0,
                              color: Colors.white,
                            ), // Icon als klickbares Element
                          ),
                          InkWell(
                            onTap: pushToEditStack,
                            child: Icon(
                              Icons.edit_outlined,
                              size: 32.0,
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
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: Headline(
                text: stackname
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,40,22,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                InkWell(
                  onTap: (){
                    setState(() {
                      isMixed =! isMixed;
                    });
                    print(isMixed);
                  },
                  child: isMixed ? Icon(
                    Icons.shuffle_rounded,
                    size: 30.0,
                    color: Color(0xFFE59113),
                  ): Icon(
                    Icons.shuffle_rounded,
                    size: 30.0,
                    color: Colors.white,// Icon als klickbares Element
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 185, // Feste Höhe von 200
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
                return showButtons()[index];
              },
              itemCount: showButtons().length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      selectedOption,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600
                      ),
                    ),
                    InkWell(
                      onTap: ()
                      {
                        setState(()
                        {
                          sortValue =! sortValue;
                          loadCards();
                        });
                      },
                      child: sortValue == false ? Icon(
                        Icons.arrow_downward_rounded,
                        size: selectedOption == "ALL CARDS" ? 0.0 : 28.0,
                        color: Color(0xFFE59113),
                      ) : Icon(
                        Icons.arrow_upward_rounded,
                        size: selectedOption == "ALL CARDS" ? 0.0 : 28.0,
                        color: Color(0xFFE59113),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(1, 475, 0, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      items: [
                        PopupMenuItem(
                          onTap: (){
                            setState(() {
                              selectedOption = "QUESTION";
                              loadCards();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Question",
                                style: TextStyle(
                                  color: selectedOption == "QUESTION"
                                      ? Color(0xFFE59113)
                                      : Colors.black,
                                  fontWeight: selectedOption == "QUESTION"
                                      ?  FontWeight.w600
                                      :  FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.sort_by_alpha_rounded,
                                size: 20.0,
                                color: selectedOption == "QUESTION"
                                    ? Color(0xFFE59113)
                                    : Colors.black,
                              ),
                            ],
                          ),
                          value: "QUESTION",
                        ),
                        PopupMenuItem(
                          onTap: (){
                            setState(() {
                              selectedOption = "CREATION DATE";
                              loadCards();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Creation Date",
                                style: TextStyle(
                                  color: selectedOption == "CREATION DATE"
                                      ? Color(0xFFE59113)
                                      : Colors.black,
                                  fontWeight: selectedOption == "CREATION DATE"
                                      ?  FontWeight.w600
                                      :  FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.date_range_rounded,
                                size: 20.0,
                                color: selectedOption == "CREATION DATE"
                                    ? Color(0xFFE59113)
                                    : Colors.black,
                              ),
                            ],
                          ),
                          value: "CREATION DATE",
                        ),
                        PopupMenuItem(
                          onTap: (){
                            setState(() {
                              selectedOption = "NOTICED";
                              loadCards();
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Noticed",
                                style: TextStyle(
                                  color: selectedOption == "NOTICED"
                                      ? Color(0xFFE59113)
                                      : Colors.black,
                                  fontWeight: selectedOption == "NOTICED"
                                      ?  FontWeight.w600
                                      :  FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.lightbulb_outline,
                                size: 20.0,
                                color: selectedOption == "NOTICED"
                                    ? Color(0xFFE59113)
                                    : Colors.black,
                              ),
                            ],
                          ),
                          value: "NOTICED",
                        ),
                        if (selectedOption == "QUESTION" || selectedOption == "CREATION DATE" || selectedOption == "NOTICED")
                          PopupMenuItem(
                            onTap: (){
                              setState(() {
                                selectedOption = "ALL CARDS";
                                loadCards();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Reset",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 20.0,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                            value: "ALL CARDS",
                          ),
                      ],
                    ).then((value) {
                      setState(() {
                        selectedOption = value!;
                      });
                    });
                  },
                  child: Icon(
                    Icons.filter_alt,
                    size: 32.0,
                    color: selectedOption == "QUESTION" || selectedOption == "CREATION DATE" || selectedOption == "NOTICED"
                        ? Color(0xFFE59113)
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          showText == true ? Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    "No cards available.",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ) :
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                  return cards[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}
