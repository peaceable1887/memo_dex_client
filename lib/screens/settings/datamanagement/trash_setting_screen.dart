import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/widgets/buttons/trash_stack_btn.dart';

import '../../../services/api/api_client.dart';
import '../../../services/local/file_handler.dart';
import '../../../utils/divide_painter.dart';
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
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            leading: TopNavigationBar(
              btnText: "Settings",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationScreen(index: 1),
                  ),
                );
              },
            ),
            centerTitle: true,
            expandedHeight: 130,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              expandedTitleScale: 2,
              titlePadding: EdgeInsets.only(bottom: 15),
              centerTitle: true,
              title: HeadlineLarge(text: "Trash"),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
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
                      showModalBottomSheet(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        context: context,
                        builder: (BuildContext context){
                          return SizedBox(
                            height: 200,
                            child: Column(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Container(
                                        height: 7,
                                        width: 60,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 45),
                                  CustomPaint(
                                    size: Size(MediaQuery.of(context).size.width, 0.2),
                                    painter: DividePainter(Theme.of(context).scaffoldBackgroundColor),
                                  ),
                                  SizedBox(height: 15),
                                  PopupMenuItem(
                                    onTap: (){
                                      setState(()
                                      {
                                        undoAllStacks();
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          child: Icon(
                                            Icons.undo_rounded,
                                            size: 30.0,
                                            color: Colors.green,
                                          ),
                                        ),
                                        Text(
                                          "Undo All",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    value: "UNDO",
                                  ),
                                  SizedBox(height: 5),
                                  PopupMenuItem(
                                    onTap: (){
                                      setState(()
                                      {
                                        deleteAllStacksFromDatabase();
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                          child: Icon(
                                            Icons.delete_forever_rounded,
                                            size: 30.0,
                                            color: Colors.red,
                                          ),
                                        ),
                                        Text(
                                          "Delete All",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    value: "DELETE",
                                  ),
                                ]
                            )
                        );
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
          ),
          showLoadingCircular ?
            SliverToBoxAdapter(
              child: Container(
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
              ),
            ): _isListEmpty ? Text("Keine Stacks vorhanden") :
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver:
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    return trashStacks[index];
                  },
                  childCount: trashStacks.length,
                )),
          ),
        ],
      ),
    );
  }
}
