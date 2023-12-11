import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/services/rest_services.dart';
import 'package:memo_dex_prototyp/widgets/create_stack_btn.dart';
import 'package:memo_dex_prototyp/widgets/stack_btn.dart';
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

  @override
  void initState() {
    super.initState();
    loadStacks(widget.selectedOption, widget.sortValue);
  }

  @override
  void didUpdateWidget(covariant StackViewGrid oldWidget) {
    if (oldWidget.selectedOption != widget.selectedOption || oldWidget.sortValue != widget.sortValue) {
      loadStacks(widget.selectedOption, widget.sortValue);
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> loadStacks(String? selectedOption, bool? sortValue) async {
    try
    {
      final checkRequest = await RestServices(context).getAllStacks();

      if(checkRequest == null)
      {
        String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");
        // Überprüfe ob der Inhalt eine Liste ist
        if (fileContent.isNotEmpty)
        {
          List<dynamic> stackFileContent = jsonDecode(fileContent);

          if(selectedOption == "STACKNAME" && sortValue == false)
          {
            stackFileContent.sort((a, b) => a['stackname'].compareTo(b['stackname']));
            stackButtons.clear();
          }
          if(selectedOption == "STACKNAME" && sortValue == true)
          {
            stackFileContent.sort((a, b) => b['stackname'].compareTo(a['stackname']));
            stackButtons.clear();
          }
          if(selectedOption == "CREATION DATE" && sortValue == false)
          {
            stackFileContent.sort((a, b) => DateTime.parse(a['creation_date']).compareTo(DateTime.parse(b['creation_date'])));
            stackButtons.clear();
          }
          if(selectedOption == "CREATION DATE" && sortValue == true)
          {
            stackFileContent.sort((a, b) => DateTime.parse(b['creation_date']).compareTo(DateTime.parse(a['creation_date'])));
            stackButtons.clear();
          }
          else
          {
            stackButtons.clear();
          }

          print("------------------lokale daten----------------:");
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
        String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");
        // Überprüfe ob der Inhalt eine Liste ist
        if (fileContent.isNotEmpty)
        {
          List<dynamic> stackFileContent = jsonDecode(fileContent);
          print("hier: $selectedOption");
          if(selectedOption == "STACKNAME" && sortValue == false)
          {
            stackFileContent.sort((a, b) => a['stackname'].compareTo(b['stackname']));
            stackButtons.clear();
          }
          if(selectedOption == "STACKNAME" && sortValue == true)
          {
            stackFileContent.sort((a, b) => b['stackname'].compareTo(a['stackname']));
            stackButtons.clear();
          }
          if(selectedOption == "CREATION DATE" && sortValue == false)
          {
            stackFileContent.sort((a, b) => DateTime.parse(a['creation_date']).compareTo(DateTime.parse(b['creation_date'])));
            stackButtons.clear();
          }
          if(selectedOption == "CREATION DATE" && sortValue == true)
          {
            stackFileContent.sort((a, b) => DateTime.parse(b['creation_date']).compareTo(DateTime.parse(a['creation_date'])));
            stackButtons.clear();
          }
          else
          {
            stackButtons.clear();
          }

          print("------------------lokale daten----------------:");
          print("sort value: $selectedOption");
          print(stackFileContent);
          for (var stack in stackFileContent)
          {
            if (stack['is_deleted'] == 0)
            {
              stackButtons.add(StackBtn(stackId: stack['stack_id'], iconColor: stack['color'], stackName: stack['stackname']));
            }
          }
          stackButtons.add(CreateStackBtn());
        }
      }
      // Widget wird aktualisiert nach dem Laden der Daten.
      if (mounted) {
        setState((){});
      }
    }catch (error)
    {
      print('Fehler beim Laden der Daten: $error');
    }
  }

  @override
  void dispose() {
    super.dispose();
    loadStacks(widget.selectedOption, widget.sortValue);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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