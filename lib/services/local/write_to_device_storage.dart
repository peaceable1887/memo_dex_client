import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:memo_dex_prototyp/helperClasses/generator.dart';
import 'package:path_provider/path_provider.dart';

class WriteToDeviceStorage
{
  final storage = FlutterSecureStorage();

  Future<void> addStack({
    required String stackname,
    required String color,
    required int userId,
    required String fileName,
  }) async
  {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.json';
      final file = File(filePath);

      // Lese vorhandene Daten
      List<Map<String, dynamic>> existingData = [];
      if (await file.exists())
      {
        final content = await file.readAsString();
        if (content.isNotEmpty)
        {
          existingData = List<Map<String, dynamic>>.from(jsonDecode(content));
        }
      }

      // Füge neuen Eintrag hinzu
      existingData.add({
        "stack_id": Generator().generateRandomDecimal(),
        'stackname': stackname,
        'color': color,
        'is_deleted': 0,
        'creation_date': DateTime.now().toIso8601String(),
        'is_updated': 1,
        'user_user_id': userId,
      });

      // Speichere aktualisierte Daten
      final encodedJson = jsonEncode(existingData);
      await file.writeAsString(encodedJson);
      print('Stack wurde erfolgreich zur JSON-Datei hinzugefügt: $filePath');
    } catch (e) {
      print('Fehler beim Hinzufügen zum JSON-File: $e');
    }
  }

  Future<void> addCard({
    required String question,
    required String answer,
    required dynamic stackId,
    required String fileName,
    required String? tempCardIndex,
  }) async
  {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.json';
      final file = File(filePath);

      // Lese vorhandene Daten
      List<Map<String, dynamic>> existingData = [];
      if (await file.exists())
      {
        final content = await file.readAsString();
        if (content.isNotEmpty)
        {
          existingData = List<Map<String, dynamic>>.from(jsonDecode(content));
        }
      }

      if (tempCardIndex != null)
      {
        int retrievedIntValue = int.tryParse(tempCardIndex) ?? 0;
        print('Retrieved value as int: $retrievedIntValue');

        // Füge neuen Eintrag hinzu
        existingData.add({
          "card_id": retrievedIntValue + 1,
          'question': question,
          'answer': answer,
          "is_deleted": 0,
          "remember": 0,
          "creation_date": DateTime.now().toIso8601String(),
          "answered_correctly": 0,
          "answered_incorrectly": 0,
          "is_updated": 1,
          "created_locally": 1,
          "stack_stack_id": stackId
        });

        // Speichere aktualisierte Daten
        final encodedJson = jsonEncode(existingData);
        await file.writeAsString(encodedJson);
        print('Karte wurde erfolgreich zur JSON-Datei hinzugefügt: $filePath');
      }


    } catch (e) {
      print('Fehler beim Hinzufügen zum JSON-File: $e');
    }
  }
}