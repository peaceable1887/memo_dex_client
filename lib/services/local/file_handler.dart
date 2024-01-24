import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../helperClasses/generator.dart';

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

  Future<void> editItemById(String fileName, String contentId, dynamic targetId, Map<String, dynamic> updatedData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.json';
      final file = File(filePath);

      if (await file.exists()) {
        // Die Datei existiert, lese ihren Inhalt
        final content = await file.readAsString();

        // Parsen Sie den Inhalt als JSON
        List<dynamic> jsonData = jsonDecode(content);

        // Finde das Element mit der spezifizierten ID
        var targetItem = jsonData.firstWhere((item) => item[contentId] == targetId, orElse: () => null);

        if (targetItem != null) {
          // Bearbeite das gefundene Element mit den aktualisierten Daten
          targetItem.addAll(updatedData);

          // Konvertiere die aktualisierten Daten zurück in JSON
          final updatedJson = jsonEncode(jsonData);

          // Schreibe den aktualisierten Inhalt zurück in die Datei
          await file.writeAsString(updatedJson);

          print('Element mit ID $targetId erfolgreich bearbeitet: $filePath');
        } else {
          print('Element mit ID $targetId wurde nicht gefunden.');
        }
      } else {
        print('Die Datei existiert nicht.');
      }
    } catch (e) {
      print('Fehler beim Bearbeiten des Elements: $e');
    }
  }

  Future<void> deleteItemById(String fileName, int targetId) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.json';
      final file = File(filePath);
      print("tesssst");
      if (await file.exists()) {
        // Die Datei existiert, lese ihren Inhalt
        final content = await file.readAsString();

        // Parsen Sie den Inhalt als JSON
        List<dynamic> jsonData = jsonDecode(content);

        // Finde das Element mit der spezifizierten ID und lösche es
        jsonData.removeWhere((item) => item['stack_stack_id'] == targetId);

        // Konvertiere die aktualisierten Daten zurück in JSON
        final updatedJson = jsonEncode(jsonData);

        // Schreibe den aktualisierten Inhalt zurück in die Datei
        await file.writeAsString(updatedJson);

        print('Element mit ID $targetId erfolgreich gelöscht: $filePath');
      } else {
        print('Die Datei existiert nicht.');
      }
    } catch (e) {
      print('Fehler beim Löschen des Elements: $e');
    }
  }

  Future<void> clearFileContent(String fileName) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName.json';
      final file = File(filePath);

      if (await file.exists()) {
        // Die Datei existiert, leere ihren Inhalt
        await file.writeAsString('');
        print('Dateiinhalt erfolgreich gelöscht: $filePath');
      } else {
        print('Die Datei existiert nicht.');
      }
    } catch (e) {
      print('Fehler beim Löschen des Dateiinhalts: $e');
    }
  }
}