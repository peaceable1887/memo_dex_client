import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../screens/bottom_navigation_screen.dart';
import '../../../widgets/components/validation_message_box.dart';
import '../../local/file_handler.dart';

class UserApi
{
  final BuildContext context;
  final storage = FlutterSecureStorage();
  FileHandler fileHandler = FileHandler();

  UserApi(this.context);

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
      Navigator.pushReplacement(
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
}