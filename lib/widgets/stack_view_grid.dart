import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/services/rest_services.dart';
import 'package:memo_dex_prototyp/widgets/create_stack_btn.dart';
import 'package:memo_dex_prototyp/widgets/stack_btn.dart';
import '../helperClasses/filters.dart';
import '../services/file_handler.dart';

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
  final storage = FlutterSecureStorage();

  @override
  void initState()
  {
    super.initState();
    loadStacks(widget.selectedOption, widget.sortValue);
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
    String? internetConnection = await storage.read(key: "internet_connection");

    if(internetConnection == "false")
    {
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

    }else
    {
      await RestServices(context).getAllStacks();

      setState(() {
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

 /* Future<void> loadStacks(String? selectedOption, bool? sortValue) async
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
        // Überprüfe ob der Inhalt eine Liste ist
        if (fileContent.isNotEmpty)
        {
          List<dynamic> stackFileContent = jsonDecode(fileContent);

          filter.FilterStacks(stackButtons, stackFileContent, selectedOption!, sortValue!);

          for (var stack in stackFileContent)
          {
            if (stack['is_deleted'] == 0)
            {
              stackButtons.add(StackBtn(stackId: stack['stack_id'], iconColor: stack['color'], stackName: stack['stackname']));
            }
          }
            stackButtons.add(CreateStackBtn());
          }
      }else
      {
        final checkRequest = await RestServices(context).getAllStacks();

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
          setState(() {
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
                stackButtons.add(StackBtn(stackId: stack['stack_id'], iconColor: stack['color'], stackName: stack['stackname']));
              }
            }
            stackButtons.add(CreateStackBtn());
          }
        }else
        {
          showLoadingCircular = false;
          await storage.write(key: 'notConnected', value: "false");


          String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");
          // Überprüfe, ob der Inhalt eine Liste ist
          if (fileContent.isNotEmpty)
          {
            List<dynamic> stackFileContent = jsonDecode(fileContent);

            filter.FilterStacks(stackButtons, stackFileContent, selectedOption!, sortValue!);

            for (var stack in stackFileContent) {
              if (stack['is_deleted'] == 0) {
                stackButtons.add(StackBtn(stackId: stack['stack_id'], iconColor: stack['color'], stackName: stack['stackname']));
              }
            }
            stackButtons.add(CreateStackBtn());
          }
        }
      }
      // Widget wird aktualisiert nach dem Laden der Daten.
      if (mounted) {
        setState((){});
      }
  }*/

  @override
  void dispose() {
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