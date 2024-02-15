// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/const.dart';
import 'dart:convert';

import 'package:travel_app/placeDetails.dart';
import 'package:travel_app/placeDetailsHotels.dart';

class PlaceSearchPage extends StatefulWidget {
  const PlaceSearchPage({Key? key, required this.query}) : super(key: key);
  final String query;
  @override
  // ignore: library_private_types_in_public_api
  _PlaceSearchPageState createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage> {
  final apiKey =
      'AIzaSyCuWazdpZriMm2R4MP3wDP7kyylL40nrcg'; // Replace with your Google Places API key

  List<String> places = [];
  List<String> listPlaceId = [];
  List restaurantList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlaces();
  }

  Future<void> fetchPlaces() async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place';
    const String townName = 'Tomsk';
    final apiUrl = Uri.parse(
        '$baseUrl/textsearch/json?query=${widget.query}&location=$townName&key=$apiKey');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      setState(() {
        places = results.map((place) => place['name'] as String).toList();
        listPlaceId =
            results.map((place) => place['place_id'] as String).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> fetchPlaceDetails(String placeId) async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place';
    final apiUrl =
        Uri.parse('$baseUrl/details/json?place_id=$placeId&key=$apiKey');
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final placeDetails = data['result'];

      print('Place Name: ${placeDetails['name']}');
      print('Place Address: ${placeDetails['formatted_address']}');
      if (placeDetails['photos'] != null) {
        for (var photo in placeDetails['photos']) {
          final photoReference = photo['photo_reference'];
          final photoUrl =
              'https://maps.googleapis.com/maps/api/placephoto?maxwidth=400&photoreference=$photoReference&key=$apiKey';
          print('Photo URL: $photoUrl');
        }
      }
      print('Rating: ${placeDetails['rating']}');
      print(
          'formatted_phone_number: ${placeDetails['formatted_phone_number']}');
      print('website: ${placeDetails['website']}');
      print('price_level: ${placeDetails['price_level']}');

      // Navigate to details page with placeDetails
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget.query == 'hotel'
              ? PlaceDetailsHotel(placeDetails: placeDetails)
              : PlaceDetails(placeDetails: placeDetails),
        ),
      );
    } else {
      throw Exception('Failed to load place details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: Text(widget.query),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(places[index]),
                  onTap: () {
                    // Handle tile tap
                    print('Tile tapped: ${places[index]}');
                    // Fetch details for the selected place
                    fetchPlaceDetails(listPlaceId[index]);
                  },
                );
              },
            ),
    );
  }
}
