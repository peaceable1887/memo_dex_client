import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../widgets/dialogs/validation_message_box.dart';
import '../../local/file_handler.dart';

class StackApi
{
  final BuildContext context;
  final storage = FlutterSecureStorage();
  FileHandler fileHandler = FileHandler();

  StackApi(this.context);

  Future<String> createStack(String stackname, String color, int isDeleted) async {
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
          "is_deleted": isDeleted,
          "creation_date": DateTime.now().toIso8601String(),
          "is_updated": 0,
          "user_user_id": userId
        }),
      );

      if (response.statusCode == 200)
      {
        // Erfolgreiche Anfrage
        print("Stack wurde erfolgreich erstellt.");
        return response.body; // Hier wird der Response-Body zurückgegeben
      } else
      {
        showDialog(
          context: context,
          builder: (BuildContext context)
          {
            return ValidationMessageBox(message: "Stack konnte nicht erstellt werden");
          },
        );
        throw Exception('Stack konnte nicht erstellt werden.');
      }
    } else
    {
      // Handle the case when accessToken is null
      throw Exception('Access Token ist null.');
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
          body: jsonEncode(<String, dynamic>
          {
            "user_id": userId
          }),
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

  Future<dynamic> getStack(stackId) async {

    String? accessToken = await storage.read(key: 'accessToken');
    try{
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
        ).timeout(Duration(seconds: 10));

        if (response.statusCode == 200)
        {
          dynamic jsonResponse = json.decode(response.body);
          await fileHandler.saveJsonToLocalFile(jsonResponse, "singleStack");

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
    }else{}
  }

  Future<dynamic> insertStackRun(time, stackId) async {

    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/createStackRun'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          "date": DateTime.now().toIso8601String(),
          "time": time,
          "stack_stack_id": stackId,
        }),
      );

      if (response.statusCode == 200)
      {
        print("Durchlauf wurde in die Datenbank gespeichert.");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ValidationMessageBox(message: "Durchlauf konnte nicht gespeichert werden");
          },
        );
        throw Exception('Failed to insert data.');
      }
    }else {
    }
  }

  Future<dynamic> getStackRun(stackId) async
  {
    String? accessToken = await storage.read(key: 'accessToken');
    try
    {
      if (accessToken != null)
      {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/getStackRun'),
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
          // Daten werden zusätzlich lokal abgespeichert

          return jsonResponse;
        }else
        {
          throw http.ClientException('hat nicht geklappt. Statuscode: ${response.statusCode}');
        }
      }else
      {
        print("Token existiert nicht!");
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

  Future<dynamic> getAllStackRuns() async
  {
    String? accessToken = await storage.read(key: 'accessToken');
    String? userId = await storage.read(key: 'user_id');
    try
    {
      if (accessToken != null)
      {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/getAllStackRuns'),
          headers: <String, String>
          {
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + accessToken,
          },
          body: jsonEncode(<String, dynamic>
          {
            "user_id": userId
          }),
        ).timeout(Duration(seconds: 10));
        if (response.statusCode == 200)
        {
          dynamic jsonResponse = json.decode(response.body);

          await fileHandler.saveJsonToLocalFile(jsonResponse, "stackRuns");
          print("test getAllStackRuns: $jsonResponse");
          return jsonResponse;
        }else
        {
          throw http.ClientException('hat nicht geklappt. Statuscode: ${response.statusCode}');
        }
      }else
      {
        print("Token existiert nicht!");
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

}