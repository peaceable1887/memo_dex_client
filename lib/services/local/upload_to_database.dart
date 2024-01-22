import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/services/rest/rest_services.dart';

import 'file_handler.dart';

class UploadToDatabase
{
  final BuildContext context;
  FileHandler fileHandler = FileHandler();

  UploadToDatabase(this.context);

  Future<void> allLocalStackContent() async
  {
    String localStacks = await fileHandler.readJsonFromLocalFile("allLocalStacks");

    print("---------Upload all Local Stack Content------------");

    if (localStacks.isNotEmpty)
    {
      List<dynamic> stacks = jsonDecode(localStacks);

      for (var stack in stacks)
      {
        String responseBody = await RestServices(context).createStack(stack['stackname'], stack['color']);
        print("Response Body: $responseBody");
        allLocalCards(responseBody, stack['stack_id']);
        print("----------------NEXT STACK------------------");

      }
      FileHandler().clearFileContent("allLocalStacks");

    }else
    {
      print("Stacks are empty");

    }

  }

  Future<void> allLocalCards(stackId, localId) async
  {
    String localFileContent = await fileHandler.readJsonFromLocalFile("allLocalCards");

    print("---------Upload all Local Cards------------");

    if (localFileContent.isNotEmpty)
    {
      List<dynamic> localContent = jsonDecode(localFileContent);

      for (var card in localContent)
      {
        if(card['stack_stack_id'] == localId)
        {
          print(card["question"]);
          card['stack_stack_id'] = stackId;
          RestServices(context).addCard(card['question'], card['answer'], card['stack_stack_id']);
          print("----------------NEXT CARD------------------");
        }
      }
    }else
    {
      print("Local Cards are empty");
    }
  }

  Future<void> updateAllLocalCards(stackId) async
  {
    String localFileContent = await fileHandler.readJsonFromLocalFile("allCards");

    print("---------Upload all Local Cards------------");

    if (localFileContent.isNotEmpty)
    {
      List<dynamic> localContent = jsonDecode(localFileContent);

      for (var card in localContent)
      {
        if(card['stack_stack_id'] == stackId)
        {
          RestServices(context).updateCard(
              card['question'],
              card['answer'],
              card['is_deleted'],
              card['remember'],
              card['card_id']);
        }
      }
    }else
    {
      print("Local Cards are empty");
    }
  }

  Future<void> updateAllLocalStacks(stackId) async
  {
    String localFileContent = await fileHandler.readJsonFromLocalFile("allCards");

    print("---------Upload all Local Cards------------");

    if (localFileContent.isNotEmpty)
    {
      List<dynamic> localContent = jsonDecode(localFileContent);

      for (var card in localContent)
      {
        if(card['stack_stack_id'] == stackId)
        {
          RestServices(context).updateCard(
              card['question'],
              card['answer'],
              card['is_deleted'],
              card['remember'],
              card['card_id']);
        }
      }
    }else
    {
      print("Local Cards are empty");
    }

  }
}