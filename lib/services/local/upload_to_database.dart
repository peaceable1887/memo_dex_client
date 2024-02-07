import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/services/api/api_client.dart';

import 'file_handler.dart';

//TODO Funktion ausdrucksstärker und konsistenter benennen

class UploadToDatabase
{
  final BuildContext context;
  FileHandler fileHandler = FileHandler();

  UploadToDatabase(this.context);

  Future<void> createLocalStackContent() async
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
          print("test");
          String responseBody = await ApiClient(context).stackApi.createStack(
              stack['stackname'], stack['color'], stack['is_deleted']);

          print("Response Body: $responseBody");

          await createLocalStackRunsContent(responseBody, stack['stack_id']);
          await createLocalCardContent(responseBody, stack['stack_id']);

          stack["is_updated"] = 0;

          print("----------------NEXT STACK------------------");
        }else
        {
          if(stack["is_updated"] == 1)
          {
            print("--------------dsadasdas------------------");
            await createLocalCardContent(stack['stack_id'], stack['stack_id']);
            await updateLocalCardContent(stack['stack_id']);
            await createLocalStackRunsContent(stack['stack_id'], stack['stack_id']);
            await updateLocalCardStatistic(stack['stack_id']);
            print("----------------NEXT STACK------------------");
          }
        }
      }
    }else
    {
      print("Stacks are empty");
    }
  }

  Future<void> updateLocalStackContent() async
  {
    String fileContent = await fileHandler.readJsonFromLocalFile("allStacks");

    // Überprüfe ob der Inhalt Liste ist
    if (fileContent.isNotEmpty) {

      List<dynamic> stackFileContent = jsonDecode(fileContent);

      for (var stack in stackFileContent)
      {
        if (stack['is_updated'] == 1)
        {
          await ApiClient(context).stackApi.updateStack(stack["stackname"],
              stack["color"], stack["is_deleted"], stack['stack_id']);

          stack['is_updated'] = 0;
        }
      }
    }else
    {
      print("updateAllLocalStacks are empty");
    }
  }

  Future<void> createLocalCardContent(stackId, localId) async
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
          print(card);
          card['stack_stack_id'] = stackId;

          if (card['is_updated'] == 1)
          {
            print("5xxxxxxxxxxxxxxxxxxxxx");
            if(card["created_locally"] == 1)
            {
              print("6xxxxxxxxxxxxxxxxxxxxx");
              String responseBody = await ApiClient(context).cardApi.addCard(
                  card['question'], card['answer'], card['remember'],
                  card['is_deleted'], card['stack_stack_id']);

              print("Response Body: $responseBody");

              await ApiClient(context).cardApi.updateCardStatistic(
                  responseBody, card['answered_correctly'],card['answered_incorrectly']);

              await fileHandler.editItemById("allCards", "card_id", card['card_id'], {"is_updated": 0});

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

  Future<void> updateLocalCardContent(stackId) async
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
            await ApiClient(context).cardApi.updateCard(card['question'],
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

  Future<void> updateLocalCardStatistic(stackId) async
  {
    String localFileContent = await fileHandler.readJsonFromLocalFile("allCards");

    print("---------updateAllLocalCardStatistic in der funktion------------");

    if (localFileContent.isNotEmpty)
    {
      List<dynamic> localContent = jsonDecode(localFileContent);

      for (var card in localContent)
      {
        print("ausführung 1");
        if(card['stack_stack_id'] == stackId)
        {
          print("ausführung 2");
          if(card['is_deleted'] == 0)
          {
            print("ausführung 3");
            if(card['is_updated'] == 1)
            {
              print("ausführung 4");
              await ApiClient(context).cardApi.updateCardStatistic(
                  card['card_id'], card['answered_correctly'],card['answered_incorrectly']);
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

  Future<void> createLocalStackRunsContent(stackId, localId) async
  {
    String localStackRun = await fileHandler.readJsonFromLocalFile("stackRuns");

    print("---------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx------------");

    if (localStackRun.isNotEmpty)
    {
      List<dynamic> stackRuns = jsonDecode(localStackRun);

      for (var cardIndex = 0; cardIndex < stackRuns.length; cardIndex++)
      {
        var stackRun = stackRuns[cardIndex];

        if (stackRun['stack_stack_id'] == localId)
        {
          stackRun['stack_stack_id'] = stackId;

          if(stackRun["created_locally"] == 1 && stackRun["time"] != "24:00:00")
          {
            await ApiClient(context).stackApi.insertStackRun(
                stackRun["time"], stackId);

            print("----------------NEXT PASS------------------");
          }
        }
      }


    }else
    {
      print("createLocalStackRunsContent are empty");
    }
  }
}