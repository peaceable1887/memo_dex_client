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
}