import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import 'package:memo_dex_prototyp/services/check_internet_connection.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/validation_message_box.dart';
import 'file_handler.dart';

class RestServices{
  final BuildContext context;
  final storage = FlutterSecureStorage();
  FileHandler fileHandler = FileHandler();

  RestServices(this.context);

  Future<void> createUser(String eMail, String password) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:4000/register'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': eMail,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
        print("User wurde erstellt");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ValidationMessageBox(message: "Die E-Mail Adresse existiert bereits.");
        },
      );
      throw Exception('Failed to create user.');
    }
  }

  Future<void> loginUser(String eMail, String password) async {

    final response = await http.post(
      Uri.parse('http://10.0.2.2:4000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': eMail,
        'password': password,
      }),
    );
    if (response.statusCode == 200)
    {
      print("Erfolgreich eingeloggt");
      final Map<String, dynamic> data = json.decode(response.body); //nochmal genau ansehen was dieser teil macht
      print(data["accessToken"]);
      await storage.write(key: 'accessToken', value: data["accessToken"]);
      print(data["refreshToken"]);
      print(data["id"]);
      if (data["id"] != null) {
        await storage.write(key: 'user_id', value: data["id"].toString());
      } else {
        // Handle the case where data["id"] is null
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
      );

    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ValidationMessageBox(message: "E-Mail und/oder Passwort sind falsch.");
        },
      );
      throw http.ClientException('Failed to login1.');
    }
  }

  Future<void> getPosts() async {

    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3000/posts'),
        headers: <String, String>{
          'Authorization': "Bearer " + accessToken,
        },
      );
      if (response.statusCode == 200) {
        print("hat funktioniert");
        final List<dynamic> dataList = json.decode(response.body);
        // Überprüfe, ob dataList eine Liste ist
        if (dataList is List) {
          // Iterieren Sie durch die Liste der Beiträge (jeder Beitrag ist eine Map)
          print("Ist eine Liste");
          for (Map<String, dynamic> postData in dataList) {
              postData.forEach((key, value) {
            });
          }
        } else {
          throw FormatException('Ungültiges Datenformat: Erwartet wurde eine Liste von Beiträgen.');
        }
      } else {
        // Wenn der Statuscode nicht 200 ist, ist etwas schiefgegangen.
        throw http.ClientException('hat nicht geklappt. Statuscode: ${response.statusCode}');
      }
    } else {
      print("Token existiert nicht!");
    }
  }

  Future<void> createStack(String stackname, String color) async {

    String? accessToken = await storage.read(key: 'accessToken');
    String? userId = await storage.read(key: 'user_id');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/createStack'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          'stackname': stackname,
          'color': color,
          "is_deleted": 0,
          "user_user_id": userId
        }),
      );

      if (response.statusCode == 200) {
        print("Stack wurde erstellt");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Stack konnte nicht erstellt werden");
          },
        );
        throw Exception('Stack konnte nicht erstellt werden.');
      }
    }else {
    }
  }

  Future<dynamic> getAllStacks() async
  {
    String? accessToken = await storage.read(key: 'accessToken');
    String? userId = await storage.read(key: 'user_id');

    try{
      if (accessToken != null)
      {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/getAllStacks'),
          headers: <String, String>
          {
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + accessToken,
          },
          body: jsonEncode(<String, dynamic>{"user_id": userId}),
        ).timeout(Duration(seconds: 10));
        if (response.statusCode == 200)
        {
          dynamic jsonResponse = json.decode(response.body);
          // Daten werden zusätzlich lokal abgespeichert
          await fileHandler.saveJsonToLocalFile(jsonResponse, "allStacks");

          return jsonResponse;
        }else
        {
          throw http.ClientException('hat nicht geklappt. Statuscode: ${response.statusCode}');
        }
      }else
      {
        print("Token existiert nicht!");
      }
    } on TimeoutException catch (e) {
      // Timeout: Der Server ist wahrscheinlich nicht erreichbar
      print('Zeitüberschreitung: $e');
      return null;
    } on http.ClientException catch (e) {
      // Andere Clientfehler
      print('Clientfehler: $e');
      return null;
    } catch (e) {
      // Allgemeine Fehler
      print('Allgemeiner Fehler: $e');
      return null;
    }
  }

  Future<dynamic> getStack(stackId) async {

    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/getStack'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          "stack_id": stackId
        }),
      );

      if (response.statusCode == 200)
      {
        dynamic jsonResponse = json.decode(response.body);
        return jsonResponse;

      }else
      {
        throw http.ClientException('hat nicht geklappt. Statuscode: ${response.statusCode}');
      }
    }else
    {

    }
  }

  Future<void> updateStack(String stackname, String color, is_deleted, stackId) async {

    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/updateStack'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          'stackname': stackname,
          'color': color,
          "is_deleted": is_deleted,
          "stack_id": stackId
        }),
      );

      if (response.statusCode == 200) {
        print("Stack wurde bearbeitet");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Stack konnte nicht bearbeitet werden");
          },
        );
        throw Exception('Failed to edit stack.');
      }
    }else {
    }
  }

  Future<void> deleteStack(is_deleted, stackId) async {

    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/deleteStack'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          "stack_id": stackId,
          "is_deleted": is_deleted
        }),
      );

      if (response.statusCode == 200) {
        print("Stack wurde gelöscht");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Stack konnte nicht gelöscht werden");
          },
        );
        throw Exception('Failed to delete stack.');
      }
    }else {
    }
  }

  Future<dynamic> sortStacksAlphabetically(sort) async {

    String? accessToken = await storage.read(key: 'accessToken');
    String? userId = await storage.read(key: 'user_id');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/sortStacksAlphabetically'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userId,
          "sort": sort
        }),
      );

      if (response.statusCode == 200)
      {
        dynamic jsonResponse = json.decode(response.body);
        print("Alle Stacks");
        print(jsonResponse);
        return jsonResponse;

      }else
      {
        throw http.ClientException('hat nicht geklappt. Statuscode: ${response.statusCode}');
      }
    }else
    {

    }
  }

  Future<void> addCard(String question, String answer, stackId) async {

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
          "is_deleted": 0,
          "remember": 0,
          "stack_stack_id": stackId
        }),
      );

      if (response.statusCode == 200) {
        print("Karte wurde erstellt");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Karte konnte nicht erstellt werden");
          },
        );
        throw Exception('Failed to create stack.');
      }
    }else {
    }
  }

  Future<dynamic> getAllCards(stackId) async {

    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/getAllCards'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          "stack_id": stackId
        }),
      );

      if (response.statusCode == 200)
      {
        dynamic jsonResponse = json.decode(response.body);
        print(jsonResponse);
        return jsonResponse;

      }else
      {
        throw http.ClientException('hat nicht geklappt. Statuscode: ${response.statusCode}');
      }
    }else
    {

    }
  }

  Future<dynamic> getCard(cardId) async {

    String? accessToken = await storage.read(key: 'accessToken');

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
      );

      if (response.statusCode == 200)
      {
        dynamic jsonResponse = json.decode(response.body);
        print(jsonResponse);
        return jsonResponse;

      }else
      {
        throw http.ClientException('hat nicht geklappt. Statuscode: ${response.statusCode}');
      }
    }else
    {

    }
  }

  Future<void> updateCard(String question, String answer, is_deleted, remember, cardId) async {

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
          "is_deleted": is_deleted,
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

}

