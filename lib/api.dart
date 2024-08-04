import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.43.18:8000/api';

  Future<List<dynamic>> getAppointments() async {
    try {
      print('Sending request to $baseUrl/rdvs');
      final response = await http.get(Uri.parse('$baseUrl/rdvs'));

      print('Received response with status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['items'];
      } else {
        print(
            'Failed to load appointments. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load appointments');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load appointments');
    }
  }

  // Autres méthodes de l'API...
}
