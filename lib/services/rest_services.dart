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
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
        print("User wurde erstellt");
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
      );

    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
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
}

