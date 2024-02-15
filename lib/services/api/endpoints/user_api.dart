import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/screens/welcome_screen.dart';

import '../../../screens/bottom_navigation_screen.dart';
import '../../../widgets/dialogs/validation_message_box.dart';
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
      throw http.ClientException('Failed to login.');
    }
  }

  Future<void> logoutUser() async
  {
    String? accessToken = await storage.read(key: 'accessToken');
    bool userLoggedOut;

    try
    {
      if(accessToken != null)
      {
        final response = await http.delete(
          Uri.parse('http://10.0.2.2:4000/logout'),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'token': accessToken
          }),
        );

        if (response.statusCode == 204)
        {
          print("Successfully logged out!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WelcomeScreen(),
            ),
          );
        } else
        {
          print("Can not logged out!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavigationScreen(index: 2,),
            ),
          );
        }
      }else
      {
        print("No Token available");
      }
    }catch(error)
    {
      print("ERROR: $error");
    }
  }

  Future<dynamic> getUserEmail() async
  {
    String? accessToken = await storage.read(key: 'accessToken');
    String? userId = await storage.read(key: 'user_id');

    try{
      if (accessToken != null)
      {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/getUserEmail'),
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
          return jsonResponse;
        }else
        {
          throw http.ClientException('Can not get User E-Mail. ERROR: ${response.statusCode}');
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

  Future<dynamic> updateUserEmail(String eMail) async
  {
    String? accessToken = await storage.read(key: 'accessToken');
    String? userId = await storage.read(key: 'user_id');

    try{
      if (accessToken != null)
      {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/updateUserEmail'),
          headers: <String, String>
          {
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + accessToken,
          },
          body: jsonEncode(<String, dynamic>
          {
            "user_id": userId,
            "email": eMail,
          }),
        ).timeout(Duration(seconds: 10));
        if (response.statusCode == 200)
        {
          print("User E-Mail is successfully updated!");
          dynamic jsonResponse = json.decode(response.body);
          // Daten werden zusätzlich lokal abgespeichert
          return jsonResponse;
        }else
        {
          throw http.ClientException('Can not update User E-Mail. ERROR: ${response.statusCode}');
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

  Future<dynamic> updateUserPassword(String password) async
  {
    String? accessToken = await storage.read(key: 'accessToken');
    String? userId = await storage.read(key: 'user_id');

    try{
      if (accessToken != null)
      {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/updateUserPassword'),
          headers: <String, String>
          {
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + accessToken,
          },
          body: jsonEncode(<String, dynamic>
          {
            "user_id": userId,
            "password": password,
          }),
        ).timeout(Duration(seconds: 10));
        if (response.statusCode == 200)
        {
          print("Password was successfully updated!");

          // Daten werden zusätzlich lokal abgespeichert
        }else
        {
          throw http.ClientException('Can not update User E-Mail. ERROR: ${response.statusCode}');
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

  Future<dynamic> verifyUserPassword(String password) async
  {
    String? accessToken = await storage.read(key: 'accessToken');
    String? userId = await storage.read(key: 'user_id');
    bool passwordIsVerified;

    try{
      if (accessToken != null)
      {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:3000/verifyPassword'),
          headers: <String, String>
          {
            'Content-Type': 'application/json',
            'Authorization': "Bearer " + accessToken,
          },
          body: jsonEncode(<String, dynamic>
          {
            "user_id": userId,
            "password": password
          }),
        ).timeout(Duration(seconds: 10));
        if (response.statusCode == 200)
        {
          print("Password was successfully verified!");
          passwordIsVerified = true;
          // Daten werden zusätzlich lokal abgespeichert
          return passwordIsVerified;
        }else
        {
          print("Password was wrong!");
          passwordIsVerified = false;
          // Daten werden zusätzlich lokal abgespeichert
          return passwordIsVerified;
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