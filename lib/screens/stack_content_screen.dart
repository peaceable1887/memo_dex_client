import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/add_card_screen.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import 'package:memo_dex_prototyp/screens/standard_learning_screen.dart';
import 'package:memo_dex_prototyp/screens/edit_stack_screen.dart';
import 'package:memo_dex_prototyp/services/rest_services.dart';
import 'package:memo_dex_prototyp/widgets/stack_content_btn.dart';
import '../helperClasses/filters.dart';
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
  final filter = Filters();
  bool showLoadingCircular = true;
  bool showConnectionInformation = true;

  @override
  void initState()
  {
    super.initState();
    showSnackbarInformation();
    loadStack();
    loadCards();
    showButtons();
  }

  Future<void> tryToConnect() async
  {
    final checkRequest = await RestServices(context).getAllStacks();

    if(checkRequest == null)
    {
      await storage.write(key: 'notConnected', value: "true");
      CustomSnackbar.showSnackbar(
        context,
        Icons.info_outline_rounded,
        "Connection failed. You are still offline.",
        Colors.red,
        Duration(milliseconds: 500),
        Duration(milliseconds: 1500),
      );
      setState(() {
        showLoadingCircular = false;
      });

    }else
    {
      await storage.write(key: 'notConnected', value: "false");
      CustomSnackbar.showSnackbar(
        context,
        Icons.check_rounded,
        "Connection successful. You are online.",
        Colors.green,
        Duration(milliseconds: 500),
        Duration(milliseconds: 1500),
      );
      setState(() {
        showLoadingCircular = false;
      });
    }
  }

  void showSnackbarInformation() async
  {
    String? stackCreated = await storage.read(key: 'stackUpdated');
    String? addCard = await storage.read(key: 'addCard');
    if(stackCreated == "true")
    {
      CustomSnackbar.showSnackbar(
          context,
          Icons.check_rounded,
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
          Icons.check_rounded,
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
      String? notConnected = await storage.read(key: "notConnected");
      print(notConnected);

      if(notConnected == "true")
      {
        await storage.write(key: 'notConnected', value: "true");

        if(showConnectionInformation == true)
        {
          //TODO iconButton verwenden, wenn kein inet vorhanden ist
          tryToConnect();
        }
        showConnectionInformation = false;
        showLoadingCircular = false;

        String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");
        List<dynamic> stacks = jsonDecode(fileContent);

        if (fileContent.isNotEmpty)
        {
          for (var stack in stacks)
          {
            if (stack["stack_id"] == widget.stackId)
            {
              setState(()
              {
                stackname = stack["stackname"];
                color = stack["color"];
              });
              // breche Schleife ab, da die gewünschten Daten gefunden wurden
              break;
            }
          }
        }

      }else
      {
        final stack  = await RestServices(context).getStack(widget.stackId);

        if(stack == null)
        {
          await storage.write(key: 'notConnected', value: "true");
          showLoadingCircular = false;

          CustomSnackbar.showSnackbar(
            context,
            Icons.info_outline_rounded,
            "Connection failed. You are offline.",
            Color(0xFFE59113),
            Duration(milliseconds: 500),
            Duration(milliseconds: 1500),
          );

          setState(()
          {
            showLoadingCircular = false;
          });

          String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");
          List<dynamic> stacks = jsonDecode(fileContent);

          if (fileContent.isNotEmpty)
          {
            for (var stack in stacks)
            {
              if (stack["stack_id"] == widget.stackId)
              {
                setState(()
                {
                  stackname = stack["stackname"];
                  color = stack["color"];
                });
                // breche Schleife ab, da die gewünschten Daten gefunden wurden
                break;
              }
            }
          }

        }else
        {
          showLoadingCircular = false;
          await storage.write(key: 'notConnected', value: "false");

          String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");
          List<dynamic> stacks = jsonDecode(fileContent);

          if (fileContent.isNotEmpty)
          {
            for (var stack in stacks)
            {
              if (stack["stack_id"] == widget.stackId)
              {
                setState(()
                {
                  stackname = stack["stackname"];
                  color = stack["color"];
                });
                // breche Schleife ab, da die gewünschten Daten gefunden wurden
                break;
              }
            }
          }
        }
      }
    }catch(error)
    {
      print('Fehler beim Laden der loadStack Daten: $error');
    }
  }

  Future<void> loadCards() async
  {
    try
    {
      String? notConnected = await storage.read(key: "notConnected");
      print(notConnected);

      if(notConnected == "true")
      {
        await storage.write(key: 'notConnected', value: "true");

        if(showConnectionInformation == true)
        {
          //TODO iconButton verwenden, wenn kein inet vorhanden ist
          tryToConnect();
        }
        showConnectionInformation = false;
        showLoadingCircular = false;

        String fileContent = await fileHandler.readJsonFromLocalFile("allCards");

        if (fileContent.isNotEmpty)
        {
          List<dynamic> cardFileContent = jsonDecode(fileContent);

          filter.FilterCards(cards, cardFileContent, selectedOption, sortValue);

          for (var card in cardFileContent)
          {
            if(card['stack_stack_id'] == widget.stackId)
            {
              if (card['is_deleted'] == 0)
              {
                cards.add(CardBtn(btnText: card["question"], stackId: widget.stackId, cardId: card["card_id"], isNoticed: card["remember"]));
                showText = false;
              }
            }
          }
          // Widget wird aktualisiert nnach dem Laden der Daten.
          if (mounted)
          {
            setState(() {});
          }
        }
      }
      else
      {
        final checkRequest = await RestServices(context).getAllCards();

        if(checkRequest.isEmpty)
        {
          showText = true;
        }
        if(checkRequest == null)
        {
          await storage.write(key: 'notConnected', value: "true");
          showLoadingCircular = false;

          CustomSnackbar.showSnackbar(
            context,
            Icons.info_outline_rounded,
            "Connection failed. You are offline.",
            Color(0xFFE59113),
            Duration(milliseconds: 500),
            Duration(milliseconds: 1500),
          );

          setState(()
          {
            showLoadingCircular = false;
          });

          String fileContent = await fileHandler.readJsonFromLocalFile("allCards");

          if (fileContent.isNotEmpty)
          {
            List<dynamic> cardFileContent = jsonDecode(fileContent);

            filter.FilterCards(cards, cardFileContent, selectedOption, sortValue);

            for (var card in cardFileContent)
            {
              if(card['stack_stack_id'] == widget.stackId)
              {
                if (card['is_deleted'] == 0)
                {
                  cards.add(CardBtn(btnText: card["question"], stackId: widget.stackId, cardId: card["card_id"],));
                  showText = false;
                }
              }

            }
            // Widget wird aktualisiert nnach dem Laden der Daten.
            if (mounted)
            {
              setState(() {

              });
            }
          }
        }else
        {
          await storage.write(key: 'notConnected', value: "false");
          String fileContent = await fileHandler.readJsonFromLocalFile("allCards");
          showLoadingCircular = false;

          if (fileContent.isNotEmpty)
          {
            List<dynamic> cardFileContent = jsonDecode(fileContent);

            filter.FilterCards(cards, cardFileContent, selectedOption, sortValue);

            for (var card in cardFileContent)
            {
              if(card['stack_stack_id'] == widget.stackId)
              {
                if (card['is_deleted'] == 0)
                {
                  cards.add(CardBtn(btnText: card["question"], stackId: widget.stackId, cardId: card["card_id"], isNoticed: card["remember"]));
                  showText = false;
                }
              }
            }
            // Widget wird aktualisiert nnach dem Laden der Daten.
            if (mounted)
            {
              setState(() {});
            }
          }
        }
      }
    }catch(error)
    {
      print('Fehler beim Laden der loadCards Daten: $error');
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
    showSnackbarInformation();
    loadStack();
    loadCards();
    showButtons();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00324E),
      body: showLoadingCircular ? Container(
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            ],
          )
      ): Column(
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
                      if(isMixed)
                      {
                        CustomSnackbar.showSnackbar(
                            context,
                            Icons.warning_amber_rounded,
                            "The cards are being shuffled.",
                            Color(0xFFE59113),
                            Duration(seconds: 0),
                            Duration(milliseconds: 1500)
                        );
                      }else{
                        CustomSnackbar.showSnackbar(
                            context,
                            Icons.warning_amber_rounded,
                            "The cards are no longer shuffled.",
                            Color(0xFFE59113),
                            Duration(seconds: 0),
                            Duration(milliseconds: 1500)
                        );
                      }
                    });
                  },
                  child: isMixed ? Icon(
                    Icons.shuffle_rounded,
                    size: 32.0,
                    color: Color(0xFFE59113),
                  ): Icon(
                    Icons.shuffle_rounded,
                    size: 32.0,
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
                      position: RelativeRect.fromLTRB(1, 445, 0, 0),
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
