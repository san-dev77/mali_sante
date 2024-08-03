import 'dart:convert';
import 'package:dio/dio.dart';

class GooglePlacesService {
  final Dio _dio = Dio();
  final String _apiKey =
      'AIzaSyAOKDozMbWI1C5_NDDTIq6F7v9IPyMaANo'; // Remplacez par votre clé API

  Future<List<Map<String, dynamic>>> getNearbyPlaces(
      double latitude, double longitude, String type) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=1500&type=$type&key=$_apiKey';

    print("API URL: $url");

    final response = await _dio.get(url);

    if (response.statusCode == 200) {
      print("API Response: ${response.data}");
      return List<Map<String, dynamic>>.from(response.data['results']);
    } else {
      print("Failed to load nearby places: ${response.statusCode}");
      throw Exception('Failed to load nearby places');
    }
  }
}
