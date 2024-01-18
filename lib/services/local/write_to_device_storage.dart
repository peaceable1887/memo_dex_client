import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class WriteToDeviceStorage
{
  Future<void> addStack({
    required String stackname,
    required String color,
    required int userId,
    required String fileName,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.json';
      final file = File(filePath);

      // Lese vorhandene Daten
      List<Map<String, dynamic>> existingData = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          existingData = List<Map<String, dynamic>>.from(jsonDecode(content));
        }
      }

      // Füge neuen Eintrag hinzu
      existingData.add({
        'stackname': stackname,
        'color': color,
        'is_deleted': 0,
        'creation_date': DateTime.now().toIso8601String(),
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
    required int stackId,
    required String fileName,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.json';
      final file = File(filePath);

      // Lese vorhandene Daten
      List<Map<String, dynamic>> existingData = [];
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          existingData = List<Map<String, dynamic>>.from(jsonDecode(content));
        }
      }

      // Füge neuen Eintrag hinzu
      existingData.add({
        'question': question,
        'answer': answer,
        "is_deleted": 0,
        "remember": 0,
        "creation_date": DateTime.now().toIso8601String(),
        "stack_stack_id": stackId
      });

      // Speichere aktualisierte Daten
      final encodedJson = jsonEncode(existingData);
      await file.writeAsString(encodedJson);
      print('Karte wurde erfolgreich zur JSON-Datei hinzugefügt: $filePath');
    } catch (e) {
      print('Fehler beim Hinzufügen zum JSON-File: $e');
    }
  }
}