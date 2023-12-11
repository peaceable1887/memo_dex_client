import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/services/rest_services.dart';
import 'package:memo_dex_prototyp/widgets/create_stack_btn.dart';
import 'package:memo_dex_prototyp/widgets/stack_btn.dart';
import '../services/file_handler.dart';

class StackViewGrid extends StatefulWidget {
  final String? sortValue;

  StackViewGrid({Key? key, this.sortValue}) : super(key: key);

  @override
  State<StackViewGrid> createState() => _StackViewGridState();
}

class _StackViewGridState extends State<StackViewGrid> {
  List<Widget> stackButtons = [];
  FileHandler fileHandler = FileHandler();

  @override
  void initState() {
    super.initState();
    loadStacks(widget.sortValue);
  }

  @override
  void didUpdateWidget(covariant StackViewGrid oldWidget) {
    if (oldWidget.sortValue != widget.sortValue) {
      loadStacks(widget.sortValue);
    }
    super.didUpdateWidget(oldWidget);
  }

  Future<void> loadStacks(String? sortValue) async {
    try
    {
      final stacksData = await RestServices(context).getAllStacks();

      if(stacksData == null)
      {
        String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");
        // Überprüfe ob der Inhalt eine Liste ist
        if (fileContent.isNotEmpty)
        {
          List<dynamic> stackFileContent = jsonDecode(fileContent);
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
        for (var stack in stacksData)
        {
          if (stack['is_deleted'] == 0)
          {
            stackButtons.add(StackBtn(stackId: stack['stack_id'], iconColor: stack['color'], stackName: stack['stackname']));
          }
        }
        stackButtons.add(CreateStackBtn());
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
    loadStacks(widget.sortValue);
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