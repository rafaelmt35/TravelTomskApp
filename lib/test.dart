import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PlaceSearchPage extends StatefulWidget {
  @override
  _PlaceSearchPageState createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage> {
  final apiKey =
      'AIzaSyC7Fxs-HxVQ7I0cp_T3XsywyfeJFgQ_gTw'; // Replace with your Google Places API key
  final query = 'museums'; // Your search query

  List<String> places = [];

  @override
  void initState() {
    super.initState();
    fetchPlaces();
  }

  Future<void> fetchPlaces() async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place';
    const String townName = 'Tomsk';
    final apiUrl = Uri.parse(
      '$baseUrl/textsearch/json?query=$query&location=$townName&key=$apiKey',
    );
    final response = await http.get(apiUrl);
    var listPlaceId = [];
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      setState(() {
        places = results.map((place) => place['name'] as String).toList();
      });

      for (var place in results) {
        listPlaceId.add(place['place_id']);
        print('Place Name: ${place['name']}');
        print('Place ID: ${place['place_id']}');
      }

      final apiUrlt = Uri.parse(
        '$baseUrl/details/json?place_id=ChIJuVp4HHSTJkMRk2dXcXIVUYM&key=$apiKey',
      );
      final responset = await http.get(apiUrlt);

      if (responset.statusCode == 200) {
        final data = json.decode(responset.body);

        final placeDetails = data['result'];

        print('Place Name: ${placeDetails['name']}');
        print('Place Address: ${placeDetails['formatted_address']}');
        if (placeDetails['photos'] != null) {
          for (var photo in placeDetails['photos']) {
            final photoReference = photo['photo_reference'];
            final photoUrl =
                'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
            print('Photo URL: $photoUrl');
          }
        }
      }

      // for (int i = 0; i < listPlaceId.length; i++) {
      //   final apiUrl = Uri.parse(
      //     '$baseUrl/details/json?place_id=${listPlaceId[i]}&key=$apiKey',
      //   );
      //   final response = await http.get(apiUrl);

      //   if (response.statusCode == 200) {
      //     final data = json.decode(response.body);

      //     final placeDetails = data['result'];

      //     print('Place Name: ${placeDetails['name']}');
      //     print('Place Address: ${placeDetails['formatted_address']}');
      //     if (placeDetails['photos'] != null) {
      //       for (var photo in placeDetails['photos']) {
      //         final photoReference = photo['photo_reference'];
      //         final photoUrl =
      //             'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';
      //         print('Photo URL: $photoUrl');
      //       }
      //     }
      //   } else {
      //     // Handle the API error
      //     print('API Request Error: ${response.statusCode}');
      //   }
      // }
    } else {
      throw Exception('Failed to load places');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Search'),
      ),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(places[index]),
          );
        },
      ),
    );
  }
}
