import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/widgets/buttons/trash_stack_btn.dart';

import '../../../services/api/api_client.dart';
import '../../../services/local/file_handler.dart';
import '../../../widgets/text/headlines/headline_large.dart';
import '../../../widgets/header/top_navigation_bar.dart';
import '../../../widgets/text/headlines/headline_medium.dart';
import '../../bottom_navigation_screen.dart';

class TrashSettingScreen extends StatefulWidget
{
  const TrashSettingScreen({super.key});

  @override
  State<TrashSettingScreen> createState() => _TrashSettingScreenState();
}

class _TrashSettingScreenState extends State<TrashSettingScreen>
{
  List<Widget> trashStacks = [];
  bool showLoadingCircular = true;
  FileHandler fileHandler = FileHandler();
  bool _isListEmpty = false;

  @override
  void initState()
  {
    super.initState();
    loadTrashStacks();
  }

  Future<void> loadTrashStacks() async
  {
    try
    {
      trashStacks.clear();
      await ApiClient(context).stackApi.getAllStacks();

      setState(()
      {
        showLoadingCircular = false;
      });

      String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

      if(fileContent.isNotEmpty)
      {
        _isListEmpty = false;
        List<dynamic> stackFileContent = jsonDecode(fileContent);

        for (var stack in stackFileContent)
        {
          if (stack['is_deleted'] == 1)
          {
            trashStacks.add(TrashStackBtn(
              stackId: stack['stack_id'],
              iconColor: stack['color'],
              stackName: stack['stackname'],
              onClicked: reloadList,
              )
            );
          }
        }
      }else
      {
        //TODO geht hier nicht rein weil allStacks nie leer ist...
        print("gehe hier rein");
        setState(()
        {
          _isListEmpty = true;
        });
      }
      if(mounted)
      {
        setState((){});
      }
    }catch(error)
    {
      print('Fehler beim Laden der Trash-Daten: $error');
    }
  }

  Future<void> reloadList(bool value) async
  {
    if (value == true)
    {
      await loadTrashStacks();
    } else
    {
      print("Fehler beim Laden von loadTrashStacks");
    }
  }

  Future<void> deleteAllStacksFromDatabase() async
  {
    String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

    if(fileContent.isNotEmpty)
    {
      List<dynamic> stackFileContent = jsonDecode(fileContent);

      for (var stack in stackFileContent)
      {
        if (stack['is_deleted'] == 1)
        {
          await ApiClient(context).stackApi.deleteStackFromDatabase(stack["stack_id"]);
        }
      }

      await loadTrashStacks();
    }
  }

  Future<void> undoAllStacks() async
  {
    String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

    if(fileContent.isNotEmpty)
    {
      List<dynamic> stackFileContent = jsonDecode(fileContent);

      for (var stack in stackFileContent)
      {
        if (stack['is_deleted'] == 1)
        {
          await ApiClient(context).stackApi.undoStack(stack["stack_id"]);
        }
      }

      await loadTrashStacks();
    }
  }

  @override
  void dispose()
  {
    print("dispose trash screen");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
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
                      btnText: "Settings",
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen(index: 2),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0,10,0,0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const HeadlineLarge(text: "Trash"),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const HeadlineMedium(text: "DELETED STACKS"),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showMenu(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        context: context,
                        position: RelativeRect.fromLTRB(1, 220, 0, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        items: [
                          PopupMenuItem(
                            onTap: (){
                              setState(()
                              {
                                undoAllStacks();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Undo All",
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.undo_rounded,
                                  size: 20.0,
                                  color: Colors.green,
                                ),
                              ],
                            ),
                            value: "UNDO",
                          ),
                          PopupMenuItem(
                            onTap: (){
                              setState(()
                              {
                                deleteAllStacksFromDatabase();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delete All",
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Icon(
                                  Icons.delete_forever_rounded,
                                  size: 20.0,
                                  color: Colors.red,
                                ),
                              ],
                            ),
                            value: "DELETE",
                          ),
                        ]
                    ).then((value) {
                        setState(()
                        {});
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.keyboard_control_rounded,
                        size: 32.0,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: showLoadingCircular ?
            Container(
              height: MediaQuery.of(context).size.height/2,
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
            ): _isListEmpty ? Text("Keine Stacks vorhanden") : Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: ListView.builder(
                itemCount: trashStacks.length,
                itemBuilder: (context, index)
                {
                  return trashStacks[index];
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
