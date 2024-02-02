import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/widgets/buttons/stack_btn.dart';
import '../services/local/file_handler.dart';

class CustomSearchDelegate extends SearchDelegate
{

  List<Widget> stackButtons = [];
  FileHandler fileHandler = FileHandler();

  CustomSearchDelegate()
  {
    loadStacks();
  }

  Future<void> loadStacks() async
  {
    String localStackContent = await fileHandler.readJsonFromLocalFile("allStacks");

    // Überprüfe ob der Inhalt Liste ist
    if (localStackContent.isNotEmpty)
    {
      List<dynamic> stackContent = jsonDecode(localStackContent);

      for (var stack in stackContent)
      {
        if (stack['is_deleted'] == 0)
        {
          stackButtons.add(StackBtn(
              stackId: stack['stack_id'],
              iconColor: stack['color'],
              stackName: stack['stackname']));
        }
      }
    }
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: Color(0xFF00324E),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF00324E),
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.50),
          fontSize: 16,
          fontFamily: "Inter",
          fontWeight: FontWeight.w400,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        // Hier passt du das Padding an
        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
    );
  }

  @override
  TextStyle get queryStyle => TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: "Inter",
    fontWeight: FontWeight.w400
  );

  @override
  TextStyle get searchFieldStyle => TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: "Inter",
    fontWeight: FontWeight.w400, // Textfarbe im Suchfeld ändern
  );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return[
      Padding(
        padding: const EdgeInsets.fromLTRB(0,0,10,0),
        child: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.clear_rounded),
          onPressed: (){
            query = "";
          },
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10,0,0,0),
      child: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: (){
            close(context, null);
          },
        ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Widget> matchQuery = [];
    for (var stackBtn in stackButtons)
    {
      String stackName = (stackBtn as StackBtn).stackName;
      if (stackName.toLowerCase().contains(query.toLowerCase()))
      {
        matchQuery.add(stackBtn);
      }
    }
    return ListView(children: matchQuery);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Widget> matchQuery = [];
    for (var stackBtn in stackButtons)
    {
      String stackName = (stackBtn as StackBtn).stackName;
      if (stackName.toLowerCase().contains(query.toLowerCase()))
      {
        matchQuery.add(stackBtn);
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
        itemBuilder: (context, index)
        {
          return matchQuery[index];
        },
        itemCount: matchQuery.length,
      ),
    );
  }
}
