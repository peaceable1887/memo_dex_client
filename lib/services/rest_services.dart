import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:memo_dex_prototyp/screens/bottom_navigation_screen.dart';
import '../screens/home_screen.dart';
import '../widgets/validation_message_box.dart';

class RestServices{
  final BuildContext context;
  final storage = FlutterSecureStorage();

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
    print("test");
    if (response.statusCode == 200) {
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
            print("Beitrag:");
            postData.forEach((key, value) {
              print("Daten: ");
              print("$key: $value");
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
      // Wenn accessToken null ist, behandeln Sie diesen Fall.
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
        throw Exception('Failed to create stack.');
      }
    }else {
    }
  }

  Future<dynamic> getAllStacks() async {

    String? accessToken = await storage.read(key: 'accessToken');
    String? userId = await storage.read(key: 'user_id');

    if (accessToken != null) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/getAllStacks'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': "Bearer " + accessToken,
        },
        body: jsonEncode(<String, dynamic>{
          "user_id": userId
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
}

