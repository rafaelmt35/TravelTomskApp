// ignore_for_file: file_names, camel_case_types, prefer_typing_uninitialized_variables, avoid_print

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class apiCall {
  final query;

  apiCall({required this.query});

  static Future<List> fetchPlaces(String query) async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place';
    const String townName = 'Tomsk';
    final apiUrl = Uri.parse(
      '/textsearch/json$baseUrl?query=$query&location=$townName&key=${dotenv.env["API_KEY"]}',
    );
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final places = data['results'];
      for (var place in places) {
        final placeId = place['place_id'];
        print('Place Name: ${place['name']}');
        print('Place ID: $placeId');
      }
      return data['results'] as List;
    } else {
      throw Exception('Failed to load places');
    }
  }
}
