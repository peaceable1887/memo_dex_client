import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import 'package:memo_dex_prototyp/screens/stack/stack_content_screen.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';
import '../../services/local/file_handler.dart';
import '../../widgets/dialogs/delete_message_box.dart';
import '../../widgets/forms/edit_stack_form.dart';
import '../../widgets/header/headline.dart';
import '../../widgets/header/top_navigation_bar.dart';

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
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => BottomNavigationScreen()),
      );*/
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
              await ApiClient(context).stackApi.deleteStack(1, widget.stackId);
            }else
            {
              await fileHandler.editItemById(
                  "allStacks", "stack_id", widget.stackId,
                  {"is_deleted":1, "is_updated": 1});
            }

            //Overlay wird aus dem Widget-Tree entfernt
            Navigator.of(context).pop();

            //Route und ersetze das Widget
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
  void dispose()
  {
    print("dispose edt stack screen");
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