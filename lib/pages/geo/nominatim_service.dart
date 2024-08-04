import 'dart:convert';
import 'package:http/http.dart' as http;

class NominatimService {
  final String _baseUrl = 'https://nominatim.openstreetmap.org';

  Future<List<Map<String, dynamic>>> getNearbyPlaces(
      double latitude, double longitude, String type) async {
    final String url =
        '$_baseUrl/search?format=jsonv2&q=$type&limit=10&viewbox=${longitude - 0.1},${latitude - 0.1},${longitude + 0.1},${latitude + 0.1}&bounded=1';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print('API Response: ${response.body}');
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load nearby places');
    }
  }
}
