import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/widgets/stack_btn.dart';
import '../services/file_handler.dart';

class CustomSearchDelegate extends SearchDelegate{

  List<Widget> stackButtons = [];
  FileHandler fileHandler = FileHandler();

  CustomSearchDelegate() {
    loadStacks();
  }

  Future<void> loadStacks() async
  {

    String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");
    List<dynamic> stackFileContent = jsonDecode(fileContent);
    // Überprüfe ob der Inhalt eine Liste ist
    if (fileContent.isNotEmpty)
    {
      for (var stack in stackFileContent)
      {
        if (stack['is_deleted'] == 0)
        {
          stackButtons.add(StackBtn(stackId: stack['stack_id'], iconColor: stack['color'], stackName: stack['stackname']));
        }
      }
    }
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: Color(0xFF00324E), // Hintergrundfarbe der gesamten AppBar ändern
        elevation: 0, // BoxShadow entfernen

      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF00324E),
        hintStyle: TextStyle(
          color: Colors.white, // Textfarbe des Placeholder "Search" ändern
        ),
        focusedBorder: InputBorder.none,
        // Hintergrundfarbe der Suchleiste ändern
      ),
    );
  }

  @override
  TextStyle get queryStyle => TextStyle(
    color: Colors.white, // Textfarbe der Suchleiste ändern
  );

  @override
  TextStyle get searchFieldStyle => TextStyle(
    color: Colors.white, // Textfarbe im Suchfeld ändern
  );

  @override
  List<Widget>? buildActions(BuildContext context) {

    return[
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: (){
          query = "";
        },
      ),
    ];
    throw UnimplementedError();
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: (){
          close(context, null);
        },
      );

    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Widget> matchQuery = [];
    for (var stackBtn in stackButtons) {
      String stackName = (stackBtn as StackBtn).stackName;
      if (stackName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(stackBtn); // Füge das StackBtn-Widget hinzu, nicht nur den Namen
      }
    }
    return ListView(children: matchQuery);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Widget> matchQuery = [];
    for (var stackBtn in stackButtons) {
      String stackName = (stackBtn as StackBtn).stackName;
      if (stackName.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(stackBtn); // Füge das StackBtn-Widget hinzu, nicht nur den Namen
      }
    }
    return Scaffold(
      backgroundColor: Color(0xFF00324E),
      body: GridView.builder(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          crossAxisCount: 2,
          childAspectRatio: MediaQuery.of(context).size.width /
              (MediaQuery.of(context).size.height / 2.3),
        ),
        itemBuilder: (context, index) {
          return matchQuery[index];
        },
        itemCount: matchQuery.length,
      ),
    );
  }
}
