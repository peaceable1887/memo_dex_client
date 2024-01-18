import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/services/rest/rest_services.dart';

import 'file_handler.dart';

class UploadToDatabase
{
  final BuildContext context;
  FileHandler fileHandler = FileHandler();

  UploadToDatabase(this.context);

  Future<void> allLocalStacks() async
  {
    String localFileContent = await fileHandler.readJsonFromLocalFile("allLocalStacks");

    print("---------allLocalStacks------------");
    print(localFileContent);

    if (localFileContent.isNotEmpty)
    {
      List<dynamic> localContent = jsonDecode(localFileContent);
      print("Länge der Liste: ${localContent.length}");

      for (var stack in localContent)
      {
        print(stack['stackname']);
        print(stack['color']);
        print(stack['is_deleted']);
        print(stack['creation_date']);
        print(stack['user_user_id']);
        RestServices(context).createStack(stack['stackname'], stack['color']);
        print("----------------NEXT------------------");

      }
      FileHandler().clearFileContent("allLocalStacks");
    }else
    {
      print("loadLocalStacks are empty");
    }

  }

  Future<void> allLocalCards() async
  {
    String localFileContent = await fileHandler.readJsonFromLocalFile("allLocalCards");

    print("---------allLocalCards------------");
    print(localFileContent);

    if (localFileContent.isNotEmpty)
    {
      List<dynamic> localContent = jsonDecode(localFileContent);
      print("Länge der Liste: ${localContent.length}");

      for (var card in localContent)
      {
        print(card['question']);
        print(card['answer']);
        print(card['stack_stack_id']);
        RestServices(context).addCard(card['question'], card['answer'], card['stack_stack_id']);
        print("----------------NEXT------------------");

      }
      FileHandler().clearFileContent("allLocalCards");
    }else
    {
      print("loadLocalCards are empty");
    }

  }
}