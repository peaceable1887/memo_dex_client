import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../widgets/dialogs/validation_message_box.dart';
import '../../local/file_handler.dart';

class CardApi
{
  final BuildContext context;
  final storage = FlutterSecureStorage();
  FileHandler fileHandler = FileHandler();

  CardApi(this.context);

  Future<String> addCard(String question, String answer, int remember, int isDeleted, stackId) async {

    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/addCard'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          "question": question,
          "answer": answer,
          "is_deleted": isDeleted,
          "remember": remember,
          "creation_date": DateTime.now().toIso8601String(),
          "stack_stack_id": stackId
        }),
      );

      if (response.statusCode == 200) {
        print("Karte wurde erfolgreich erstellt.");
        return response.body;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Karte konnte nicht erstellt werden");
          },
        );
        throw Exception('Failed to create stack.');
      }
    }else
    {
      // Handle the case when accessToken is null
      throw Exception('Access Token ist null.');
    }
  }

  Future<dynamic> getAllCards() async
  {
    String? accessToken = await storage.read(key: 'accessToken');
    try
    {
      if (accessToken != null)
      {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/getAllCards'),
          headers: <String, String>
          {
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + accessToken,
          },
        ).timeout(Duration(seconds: 10));

        if (response.statusCode == 200)
        {
          dynamic jsonResponse = json.decode(response.body);
          await fileHandler.saveJsonToLocalFile(jsonResponse, "allCards");

          return jsonResponse;
        }else
        {
          throw http.ClientException('hat nicht geklappt. Statuscode: ${response.statusCode}');
        }
      }else
      {
        print("Accesstoken not available!");
      }
    }on TimeoutException catch (e)
    {
      print('Zeitüberschreitung: $e');
      //var auf grad kein netz einbauen
      return null;
    }on http.ClientException catch (e)
    {
      print('Clientfehler: $e');
      return null;
    }catch (e)
    {
      print('Allgemeiner Fehler: $e');
      return null;
    }
  }

  Future<dynamic> getAllCardsByStackId(stackId) async
  {
    String? accessToken = await storage.read(key: 'accessToken');
    try
    {
      if (accessToken != null)
      {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/getAllCardsByStackId'),
          headers: <String, String>
          {
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + accessToken,
          },
          body: jsonEncode(<String, dynamic>
          {
            "stack_id": stackId
          }),
        ).timeout(Duration(seconds: 10));

        if (response.statusCode == 200)
        {
          dynamic jsonResponse = json.decode(response.body);
          await fileHandler.saveJsonToLocalFile(jsonResponse, "allCardsByStackId");

          print("test: $jsonResponse");

          return jsonResponse;
        }else
        {
          throw http.ClientException('hat nicht geklappt. Statuscode: ${response.statusCode}');
        }
      }else
      {
        print("Accesstoken not available!");
      }
    }on TimeoutException catch (e)
    {
      print('Zeitüberschreitung: $e');
      //var auf grad kein netz einbauen
      return null;
    }on http.ClientException catch (e)
    {
      print('Clientfehler: $e');
      return null;
    }catch (e)
    {
      print('Allgemeiner Fehler: $e');
      return null;
    }
  }

  Future<dynamic> getCard(cardId) async
  {
    String? accessToken = await storage.read(key: 'accessToken');
    try
    {
      if (accessToken != null) {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/getCard'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + accessToken,
          },
          body: jsonEncode(<String, dynamic>{
            "card_id": cardId
          }),
        ).timeout(Duration(seconds: 10));

        if (response.statusCode == 200)
        {
          dynamic jsonResponse = json.decode(response.body);
          await fileHandler.saveJsonToLocalFile(jsonResponse, "singleCard");

          return jsonResponse;

        }else
        {
          throw http.ClientException('hat nicht geklappt. Statuscode: ${response.statusCode}');
        }
      }else
      {
        print("Zugangstoken existiert nicht!");
      }
    }on TimeoutException catch (e)
    {
      print('Zeitüberschreitung: $e');
      //var auf grad kein netz einbauen
      return null;
    }on http.ClientException catch (e)
    {
      print('Clientfehler: $e');
      return null;
    }catch (e)
    {
      print('Allgemeiner Fehler: $e');
      return null;
    }
  }

  Future<void> updateCard(String question, String answer, int isDeleted, remember, cardId) async {

    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/updateCard'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          "card_id": cardId,
          "question": question,
          "answer": answer,
          "is_deleted": isDeleted,
          "remember": remember
        }),
      );

      if (response.statusCode == 200) {
        print("Karte wurde bearbeitet");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Karte konnte nicht bearbeitet werden");
          },
        );
        throw Exception('Failed to edit stack.');
      }
    }else {
    }
  }

  Future<void> answeredCorrectly(cardId) async {

    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/answeredCorrectly'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          "card_id": cardId
        }),
      );

      if (response.statusCode == 200) {
        print("Korrekte antwort wurde gepeichert.");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Karte konnte nicht bearbeitet werden");
          },
        );
        throw Exception('Failed to insert data.');
      }
    }else {
    }
  }

  Future<void> answeredIncorrectly(cardId) async {

    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/answeredIncorrectly'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          "card_id": cardId
        }),
      );

      if (response.statusCode == 200) {
        print("Falsche antwort wurde gespeichert.");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Karte konnte nicht bearbeitet werden");
          },
        );
        throw Exception('Failed to insert data.');
      }
    }else {
    }
  }

  Future<void> updateCardStatistic(cardId, int answeredCorrectly, int answeredIncorrectly) async {

    String? accessToken = await storage.read(key: 'accessToken');
    print("answeredCorrectly: ${answeredCorrectly}");
    print("answeredIncorrectly: ${answeredIncorrectly}");
    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/updateCardStatistic'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          "card_id": cardId,
          "answered_correctly": answeredCorrectly,
          "answered_incorrectly": answeredIncorrectly,
        }),
      );

      if (response.statusCode == 200) {
        print("Antwort (Richtig/Falsch) wurde in die Datenbank gespeichert.");
      } else {
        /*showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Antwort (Richtig/Falsch) konnte nicht gespeichert werden");
          },
        );*/
        print("Antwort (Richtig/Falsch) konnte nicht gespeichert werden");
        throw Exception('Failed to insert data.');
      }
    }else {
    }
  }
}