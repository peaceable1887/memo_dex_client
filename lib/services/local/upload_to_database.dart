import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/services/api/rest_services.dart';

import 'file_handler.dart';

//TODO Funktion ausdrucksstärker und konsistenter benennen

class UploadToDatabase
{
  final BuildContext context;
  FileHandler fileHandler = FileHandler();

  UploadToDatabase(this.context);

  Future<void> allLocalStackContent() async
  {
    String localStacks = await fileHandler.readJsonFromLocalFile("allStacks");

    print("---------Upload all Local Stack Content in der funktion------------");

    if (localStacks.isNotEmpty)
    {
      List<dynamic> stacks = jsonDecode(localStacks);

      for (var stack in stacks)
      {
        if(stack["created_locally"] == 1)
        {
          String responseBody = await RestServices(context).createStack(
              stack['stackname'], stack['color'], stack['is_deleted']);

          print("Response Body: $responseBody");

          await updateLocalStackStatistic(responseBody, stack['stack_id']);
          await allLocalCards(responseBody, stack['stack_id']);

          stack["is_updated"] = 0;
          print("----------------NEXT STACK------------------");
        }else
        {
          if(stack["is_updated"] == 1)
          {
            await updateLocalStackStatistic(stack['stack_id'], stack['stack_id']);
            await allLocalCards(stack['stack_id'], stack['stack_id']);

            stack["is_updated"] = 0;
            print("----------------NEXT STACK------------------");
          }

        }
      }
    }else
    {
      print("Stacks are empty");
    }
  }

  Future<void> updateAllLocalStacks() async
  {
    String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

    // Überprüfe ob der Inhalt Liste ist
    if (fileContent.isNotEmpty) {

      List<dynamic> stackFileContent = jsonDecode(fileContent);

      for (var stack in stackFileContent)
      {
        if (stack['is_updated'] == 1)
        {
          await RestServices(context).updateStack(stack["stackname"],
              stack["color"], stack["is_deleted"], stack['stack_id']);

          stack['is_updated'] = 0;
        }
      }
    }else
    {
      print("updateAllLocalStacks are empty");
    }
  }

  Future<void> allLocalCards(stackId, localId) async
  {
    String localFileContent = await fileHandler.readJsonFromLocalFile("allCards");

    print("---------Upload all Local Cards in der funktion ------------");

    if (localFileContent.isNotEmpty)
    {
      List<dynamic> localContent = jsonDecode(localFileContent);

      for (var cardIndex = 0; cardIndex < localContent.length; cardIndex++)
      {
        var card = localContent[cardIndex];

        if (card['stack_stack_id'] == localId)
        {
          card['stack_stack_id'] = stackId;

          if (card['is_updated'] == 1)
          {
            if(card["created_locally"] == 1)
            {
              String responseBody = await RestServices(context).addCard(
                  card['question'], card['answer'], card['remember'],
                  card['is_deleted'], card['stack_stack_id']);

              print("Response Body: $responseBody");

              await RestServices(context).updateCardStatistic(
                  responseBody, card['answered_correctly'],card['answered_incorrectly']);

              await fileHandler.editItemById("allCards", "card_id", card['card_id'], {"is_updated": 0});

              //kann eventuell raus...
              card["is_updated"] = 0;
              card["created_locally"] = 0;

              print("überarbeitete Upload all Local Cards Karte: ${card}");

              print("----------------NEXT CARD------------------");
            }
          }
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

    print("---------updateAllLocalCards in der funktion------------");

    if (localFileContent.isNotEmpty)
    {
      List<dynamic> localContent = jsonDecode(localFileContent);

      for (var card in localContent)
      {
        if(card['stack_stack_id'] == stackId)
        {
          if (card['is_updated'] == 1)
          {
            await RestServices(context).updateCard(
                card['question'],
                card['answer'],
                card['is_deleted'],
                card['remember'],
                card['card_id']);

            card['is_updated'] = 0;

             print("überarbeitete updateAllLocalCards Karte: ${card}");
          }
        }
      }
    }else
    {
      print("Local Cards are empty");
    }
  }

  Future<void> updateLocalStackStatistic(stackId, localId) async
  {
    try
    {
      String localStacks = await fileHandler.readJsonFromLocalFile("allStacks");

      print("---------updateLocalStackStatistic in der funktion-----------");

      if (localStacks.isNotEmpty)
      {
        List<dynamic> stacks = jsonDecode(localStacks);

        for (var stack in stacks)
        {
          if(stack["stack_id"] == localId)
          {
            stack["stack_id"] = stackId;

            if(stack["is_deleted"] == 0)
            {
              if(stack['is_updated'] == 1)
              {
                if(stack['fastest_time'] != null && stack['last_time'] != null)
                {
                  print("Update Stack: ${stack}");

                  await RestServices(context).updateStackStatistic(
                      stack["stack_id"],stack["fastest_time"] ,stack["last_time"], stack["pass"]-1);

                  stack['is_updated'] = 0;

                  print("----------------NEXT STACK------------------");
                }
              }
            }
          }
        }

      }else
      {
        print("updateLocalStackStatistic are empty");
      }
    }catch(error)
    {
      print("Fehler beim aktualisieren der updateLocalStackContent()-Funktion: $error");
    }

  }

  Future<void> updateAllLocalCardStatistic(stackId) async
  {
    String localFileContent = await fileHandler.readJsonFromLocalFile("allCards");

    print("---------updateAllLocalCardStatistic in der funktion------------");

    if (localFileContent.isNotEmpty)
    {
      List<dynamic> localContent = jsonDecode(localFileContent);

      for (var card in localContent)
      {
        if(card['stack_stack_id'] == stackId)
        {
          if(card['is_deleted'] == 0)
          {
            if(card['is_updated'] == 1)
            {
              await RestServices(context).updateCardStatistic(card['card_id'], card['answered_correctly'],card['answered_incorrectly']);
              card['is_updated'] = 0;
              print("überarbeitete updateAllLocalCardStatistic Karte: ${card}");
            }
          }
        }
      }
    }else
    {
      print("updateAllLocalCardStatistic are empty");
    }
  }
}