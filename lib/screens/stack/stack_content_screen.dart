import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/card/create_card_screen.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import 'package:memo_dex_prototyp/screens/learning/standard_learning_screen.dart';
import 'package:memo_dex_prototyp/screens/stack/edit_stack_screen.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import 'package:memo_dex_prototyp/services/local/upload_to_database.dart';
import 'package:memo_dex_prototyp/widgets/buttons/stack_content_btn.dart';
import '../../utils/filters.dart';
import '../../services/local/file_handler.dart';
import '../../widgets/buttons/card_btn.dart';
import '../../widgets/dialogs/custom_snackbar.dart';
import '../../widgets/text/headlines/headline_large.dart';
import '../../widgets/header/top_navigation_bar.dart';
import '../../widgets/text/headlines/headline_medium.dart';
import '../learning/individual_learning_screen.dart';

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
  late StreamSubscription subscription;
  bool switchOnlineStatus = false;
  bool deactivateBtn = false;
  bool snackbarIsDisplayed = false;

  List<Widget> showButtons(bool isDeactivated)
  {
    List<Widget> startLearningButtons = [
      StackContentBtn(
        iconColor: "FFFFFF",
        btnText: "Standard",
        backgroundColor: "34A853",
        onPressed: StandardLearningScreen(stackId: widget.stackId, isMixed: isMixed),
        icon: Icons.star_border_rounded,
        isDeactivated: isDeactivated,
      ),
      StackContentBtn(
        iconColor: "FFFFFF",
        btnText: "Individual",
        backgroundColor: "E57435",
        onPressed: IndividualLearningScreen(stackId: widget.stackId, isMixed: isMixed),
        icon: Icons.my_library_books_rounded,
        isDeactivated: isDeactivated,
      )
    ];

    return startLearningButtons;
  }

  @override
  void initState()
  {
    super.initState();
    showSnackbarInformation();
    loadStack();
    loadCards();
    checkInternetConnection();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    async
    {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => BottomNavigationScreen()),
      );

    });
  }

  Future<void> checkInternetConnection() async
  {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

    setState(() {
      if (!isConnected) {
        snackbarIsDisplayed = true;
      } else {
        snackbarIsDisplayed = false;
      }
    });
  }

  //TODO REDUNDANZ: muss noch ausgelagert werden
  void showSnackbarInformation() async
  {
    String? stackCreated = await storage.read(key: 'stackUpdated');
    String? addCard = await storage.read(key: 'addCard');

    if (mounted)
    {
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
  }

  Future<void> loadStack() async
  {
    try
    {
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

      if(isConnected == false)
      {
        setState(()
        {
          showLoadingCircular = false;
        });

        String localStackContent = await fileHandler.readJsonFromLocalFile("allStacks");

        if (localStackContent.isNotEmpty)
        {
          List<dynamic> stackContent = jsonDecode(localStackContent);

          for (var stack in stackContent)
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
        await UploadToDatabase(context).createLocalStackContent();
        await ApiClient(context).stackApi.getAllStacks();

        String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

        setState(()
        {
          showLoadingCircular = false;
        });

        if (fileContent.isNotEmpty)
        {
          List<dynamic> stacks = jsonDecode(fileContent);

          for (var stack in stacks)
          {
            if (stack["stack_id"] == widget.stackId)
            {
              setState(() {
                stackname = stack["stackname"];
                color = stack["color"];
              });
              break;
            }else
            {}
          }
        }else{}
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
      ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
      bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

      if(isConnected == false)
      {
        setState(()
        {
          showLoadingCircular = false;
        });

        String localCardContent = await fileHandler.readJsonFromLocalFile("allCards");

        if (localCardContent.isNotEmpty)
        {
          List<dynamic> cardContent = jsonDecode(localCardContent);

          filter.FilterCards(cards, cardContent, selectedOption, sortValue);

          for (var card in cardContent)
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

          int arrLength = cardContent.length;
          String tempCardIndex = arrLength.toString();

          print(tempCardIndex);
          await storage.write(key: 'tempCardIndex', value: tempCardIndex);

          // Widget wird aktualisiert nnach dem Laden der Daten.
          if (mounted)
          {
            setState(() {});
          }
        }
      }else
      {
        await ApiClient(context).cardApi.getAllCards();

        String fileContent = await fileHandler.readJsonFromLocalFile("allCards");

        if (fileContent.isNotEmpty)
        {
          List<dynamic> cardFileContent = jsonDecode(fileContent);
          filter.FilterCards(cards, cardFileContent, selectedOption, sortValue);

          for (var card in cardFileContent)
          {
            if (card['stack_stack_id'] == widget.stackId)
            {
              if (card['is_deleted'] == 0)
              {
                cards.add(CardBtn(btnText: card["question"], stackId: widget.stackId, cardId: card["card_id"],isNoticed: card["remember"]));
                showText = false;
              }
            }/*else
            {
              print("ich gehe hier rein");
              print(deactivateBtn);
              setState(()
              {
                deactivateBtn = true;
              });
              print(deactivateBtn);
            }*/
          }
          // Widget wird aktualisiert nach dem Laden der Daten.
          if (mounted)
          {
            setState(() {});
          }
        }
      }
    }catch(error)
    {
      print('Fehler beim Laden der loadCards Daten: $error');
    }
  }

  void pushToAddCard(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AddCardScreen(stackId: widget.stackId, stackname: stackname),
      ),
    );
  }

  void pushToEditStack(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EditStackScreen(stackId: widget.stackId, stackname: stackname, color: color),
      ),
    );
  }

  @override
  void dispose()
  {
    print("dispose stack content screen");
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: showLoadingCircular ? Container(
          height: MediaQuery.of(context).size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.surface,
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
                        Navigator.pushReplacement(
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
                              color: Theme.of(context).colorScheme.surface
                            ), // Icon als klickbares Element
                          ),
                          InkWell(
                            onTap: pushToEditStack,
                            child: Icon(
                              Icons.edit_outlined,
                              size: 32.0,
                              color: Theme.of(context).colorScheme.surface,
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
            child: HeadlineLarge(
                text: stackname
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,40,22,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const HeadlineMedium(text: "START LEARNING"),
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
                            Theme.of(context).colorScheme.primary,
                            Duration(seconds: 0),
                            Duration(milliseconds: 1500)
                        );
                      }else{
                        CustomSnackbar.showSnackbar(
                            context,
                            Icons.warning_amber_rounded,
                            "The cards are no longer shuffled.",
                            Theme.of(context).colorScheme.primary,
                            Duration(seconds: 0),
                            Duration(milliseconds: 1500)
                        );
                      }
                    });
                  },
                  child: isMixed ? Icon(
                    Icons.shuffle_rounded,
                    size: 32.0,
                    color: Theme.of(context).colorScheme.primary,
                  ): Icon(
                    Icons.shuffle_rounded,
                    size: 32.0,
                    color: Theme.of(context).colorScheme.surface,// Icon als klickbares Element
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
                return showButtons(deactivateBtn)[index];
              },
              itemCount: showButtons(deactivateBtn).length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    HeadlineMedium(text: selectedOption),
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
                        color: Theme.of(context).colorScheme.primary
                      ) : Icon(
                        Icons.arrow_upward_rounded,
                        size: selectedOption == "ALL CARDS" ? 0.0 : 28.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showMenu(
                      color: Theme.of(context).popupMenuTheme.color,
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
                                  fontSize: 14,
                                  color: selectedOption == "QUESTION"
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: selectedOption == "QUESTION"
                                      ?  FontWeight.w600
                                      :  FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.sort_by_alpha_rounded,
                                size: 20.0,
                                color: selectedOption == "QUESTION"
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
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
                                  fontSize: 14,
                                  color: selectedOption == "CREATION DATE"
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: selectedOption == "CREATION DATE"
                                      ?  FontWeight.w600
                                      :  FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.date_range_rounded,
                                size: 20.0,
                                color: selectedOption == "CREATION DATE"
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
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
                                  fontSize: 14,
                                  color: selectedOption == "NOTICED"
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: selectedOption == "NOTICED"
                                      ?  FontWeight.w600
                                      :  FontWeight.w400,
                                ),
                              ),
                              Icon(
                                Icons.lightbulb_outline,
                                size: 20.0,
                                color: selectedOption == "NOTICED"
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
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
                                    fontSize: 14,
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontFamily: "Inter",
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(
                                  Icons.refresh_rounded,
                                  size: 20.0,
                                  color: Theme.of(context).colorScheme.tertiary,
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
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
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
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ) :
          Expanded(
            child: ListView.builder(
              padding: snackbarIsDisplayed ? EdgeInsets.fromLTRB(20, 20, 20, 60) : EdgeInsets.fromLTRB(20, 20, 20, 20),
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