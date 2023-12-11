import 'dart:io';
import 'package:http/http.dart' as http;

class CheckInternetConnection
{
  Future<bool> isRestEndpointReachable(String restEndpoint) async {
    try {
      final response = await http.head(Uri.parse(restEndpoint));

      if (response.statusCode == 200) {
        // Der REST-Endpunkt ist erreichbar und gibt den erwarteten Statuscode 200 zurück
        return true;
      } else {
        // Der REST-Endpunkt ist erreichbar, gibt jedoch einen anderen Statuscode zurück
        return false;
      }
    } on SocketException catch (_) {
      // Der Server ist nicht erreichbar
      return false;
    } catch (e) {
      // Irgendein anderer Fehler trat auf
      return false;
    }
  }
}

