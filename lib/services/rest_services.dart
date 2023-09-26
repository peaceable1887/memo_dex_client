import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../widgets/validation_message_box.dart';

class RestServices{
  final BuildContext context;

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

    if (response.statusCode == 200) {
      // then parse the JSON.
      print("Erfolgreich eingeloggt");
      final Map<String, dynamic> data = json.decode(response.body); //nochmal genau ansehen was dieser teil macht
      print(data["accessToken"]);
      print(data["refreshToken"]);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
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
}

