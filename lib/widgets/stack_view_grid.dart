import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/services/local/upload_to_database.dart';
import 'package:memo_dex_prototyp/services/rest/rest_services.dart';
import 'package:memo_dex_prototyp/widgets/create_stack_btn.dart';
import 'package:memo_dex_prototyp/widgets/stack_btn.dart';
import '../helperClasses/filters.dart';
import '../services/local/file_handler.dart';

class StackViewGrid extends StatefulWidget {
  final String? selectedOption;
  final bool? sortValue;

  StackViewGrid({Key? key, this.selectedOption, this.sortValue}) : super(key: key);

  @override
  State<StackViewGrid> createState() => _StackViewGridState();
}

class _StackViewGridState extends State<StackViewGrid> {
  List<Widget> stackButtons = [];
  FileHandler fileHandler = FileHandler();
  final filter = Filters();
  bool showLoadingCircular = true;
  late StreamSubscription subscription;
  final storage = FlutterSecureStorage();

  @override
  void initState()
  {
    super.initState();
    loadStacks(widget.selectedOption, widget.sortValue);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result)
    {
      loadStacks(widget.selectedOption, widget.sortValue);
    });
  }

  @override
  void didUpdateWidget(covariant StackViewGrid oldWidget)
  {
    if (oldWidget.selectedOption != widget.selectedOption || oldWidget.sortValue != widget.sortValue) {
      loadStacks(widget.selectedOption, widget.sortValue);
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> loadStacks(String? selectedOption, bool? sortValue) async
  {
    ConnectivityResult connectivityResult = await Connectivity().checkConnectivity();
    bool isConnected = (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi);


    if(isConnected == false)
    {
      print("bin offline");
      setState(()
      {
        showLoadingCircular = false;
      });

      String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");
      String fileLocalContent = await fileHandler.readJsonFromLocalFile("allLocalStacks");

      // Überprüfe ob der Inhalt Liste ist
      if (fileContent.isNotEmpty) {
        if(fileLocalContent.isEmpty)
        {
          fileLocalContent = "[]";
        }
        List<dynamic> stackFileContent = jsonDecode(fileContent);
        List<dynamic> localStackFileContent = jsonDecode(fileLocalContent);

        // Füge die Inhalte der beiden Listen zusammen
        List<dynamic> combinedStackContent = [...stackFileContent, ...localStackFileContent];
        filter.FilterStacks(stackButtons, combinedStackContent, selectedOption!, sortValue!);

        for (var stack in combinedStackContent)
        {
          if (stack['is_deleted'] == 0) {
            stackButtons.add(StackBtn(
              stackId: stack['stack_id'],
              iconColor: stack['color'],
              stackName: stack['stackname'],
            ));
          }
        }
        stackButtons.add(CreateStackBtn());
      } else
      {
        // Handle den Fall, wenn eine der Dateien leer ist
      }

    }else
    {
      await UploadToDatabase(context).allLocalStacks();
      await RestServices(context).getAllStacks();
      print("bin online");

      setState(()
      {
        showLoadingCircular = false;
      });

      String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");
      // Überprüfe ob der Inhalt eine Liste ist
      if (fileContent.isNotEmpty)
      {
        List<dynamic> stackFileContent = jsonDecode(fileContent);

        filter.FilterStacks(stackButtons, stackFileContent, selectedOption!, sortValue!);

        for (var stack in stackFileContent)
        {
          if (stack['is_deleted'] == 0)
          {
            stackButtons.add(StackBtn(
                stackId: stack['stack_id'],
                iconColor: stack['color'],
                stackName: stack['stackname']
            ));
          }
        }
        stackButtons.add(CreateStackBtn());
      }else{}

    }
    // Widget wird aktualisiert nach dem Laden der Daten.
    if (mounted)
    {
      setState((){});
    }
  }

  @override
  void dispose()
  {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return showLoadingCircular ?
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
      )
      : GridView.builder(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        crossAxisCount: 2,
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2.3),
      ),
      itemBuilder: (context, index) {
        return stackButtons[index];
      },
      itemCount: stackButtons.length,
    );
  }
}