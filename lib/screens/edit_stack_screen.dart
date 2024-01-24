import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import 'package:memo_dex_prototyp/screens/stack_content_screen.dart';
import '../services/local/file_handler.dart';
import '../services/rest/rest_services.dart';
import '../widgets/create_stack_form.dart';
import '../widgets/delete_message_box.dart';
import '../widgets/edit_stack_form.dart';
import '../widgets/headline.dart';
import '../widgets/top_navigation_bar.dart';

class EditStackScreen extends StatefulWidget {

  final dynamic stackId;
  final dynamic stackname;
  final dynamic color;

  const EditStackScreen({Key? key, this.stackId, this.stackname, this.color}) : super(key: key);

  @override
  State<EditStackScreen> createState() => _EditStackScreenState();
}

class _EditStackScreenState extends State<EditStackScreen> {

  late StreamSubscription subscription;
  FileHandler fileHandler = FileHandler();
  bool online = true;

  @override
  void initState()
  {
    super.initState();
    _checkInternetConnection();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    async
    {
      _checkInternetConnection();
    });
  }

  void _checkInternetConnection() async
  {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);

    if(isConnected == false)
    {
      online = false;
    } else
    {
      online = true;
    }
  }

  void showDeleteMessageBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteMessageBox(
          onDelete: () async {
            if(online)
            {
              await RestServices(context).deleteStack(1, widget.stackId);
            }else
            {
              if(widget.stackId is int)
              {
                await fileHandler.editItemById("allStacks", "stack_id", widget.stackId, {"is_deleted":1, "is_updated": 1});
              }else
              {
                await fileHandler.editItemById("allLocalStacks", "stack_id", widget.stackId, {"is_deleted":1, "is_updated": 1});
              }
            }

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigationScreen(),
              ),
            );
          },
          boxMessage: "Möchtest du den Stapel wirklich löschen?",
        );
      },
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00324E),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              WillPopScope(
                onWillPop: () async => false,
                child: Container(
                  child: TopNavigationBar(
                    btnText: "Back",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StackContentScreen(stackId: widget.stackId),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,15,10),
                child: Container(
                  child: InkWell(
                        onTap: showDeleteMessageBox,
                        child: Icon(
                          Icons.delete_forever_rounded,
                          size: 35.0,
                          color: Colors.white,
                        ), // Icon als klickbares Element
                      ),
                ),
              ),
            ],
          ),
          Container(
            color: Color(0xFF00324E),
            child: Column(
              children: [
                Container(
                  child:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,15,0,50),
                      child: Headline(
                          text: "Edit Stack"
                      ),
                    ),
                ),
                Container(
                  child: EditStackForm(stackId: widget.stackId, stackname: widget.stackname, color: widget.color),
                ),// Container LoginForm
              ],
            ),
          ),
        ],
      ),
    );
  }
}