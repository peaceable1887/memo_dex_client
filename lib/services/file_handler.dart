import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHandler {
  Future<void> saveJsonToLocalFile(dynamic jsonData, String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.json';
      final file = File(filePath);
      final encodedJson = jsonEncode(jsonData);

      await file.writeAsString(encodedJson);
      print('Daten erfolgreich lokal gespeichert: $filePath');

    } catch (e) {
      print('Fehler beim Speichern der Daten: $e');
    }
  }

  Future<String> readJsonFromLocalFile(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.json';
      final file = File(filePath);

      if (await file.exists()) {
        // Die Datei existiert, lese ihren Inhalt
        final content = await file.readAsString();
        print('Dateiinhalt: $content');
        return content;
      } else {
        print('Die Datei existiert nicht.');
        return "";
      }
    } catch (e) {
      print('Fehler beim Lesen der Datei: $e');
      return "";
    }
  }

  Future<void> addToJsonFile({
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
      print('Daten erfolgreich zur JSON-Datei hinzugefügt: $filePath');
    } catch (e) {
      print('Fehler beim Hinzufügen zum JSON-File: $e');
    }
  }
}