// ignore_for_file: file_names, library_private_types_in_public_api, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:travel_app/const.dart';
import 'package:travel_app/place/placeDetails.dart';
import 'package:travel_app/place/placeDetailsHotels.dart';

class PlaceSearchPage extends StatefulWidget {
  const PlaceSearchPage({Key? key, required this.query, required this.title})
      : super(key: key);
  final String query;
  final String title;

  @override
  _PlaceSearchPageState createState() => _PlaceSearchPageState();
}

class _PlaceSearchPageState extends State<PlaceSearchPage> {
  List<String> places = [];
  List<String> listPlaceId = [];
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
        '$baseUrl/textsearch/json?query=${widget.query}&location=$townName&key=${dotenv.env["API_KEY"]}');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      setState(() {
        places = results.map((place) => place['name'] as String).toList();
        listPlaceId =
            results.map((place) => place['place_id'] as String).toList();
        print(listPlaceId);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> fetchPlaceDetails(String placeId) async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place';
    final apiUrl = Uri.parse(
        '$baseUrl/details/json?place_id=$placeId&key=${dotenv.env["API_KEY"]}');
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
              'https://maps.googleapis.com/maps/api/placephoto?maxwidth=400&photoreference=$photoReference&key=${dotenv.env["API_KEY"]}';
          print('Photo URL: $photoUrl');
        }
      }
      print('Rating: ${placeDetails['rating']}');
      print(
          'formatted_phone_number: ${placeDetails['formatted_phone_number']}');
      print('website: ${placeDetails['website']}');
      print('price_level: ${placeDetails['price_level']}');
      print('LAT : ${placeDetails['geometry']['location']['lat']}');
      print('LAT : ${placeDetails['geometry']['location']['lng']}');

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

  Future<void> _refreshPlaces() async {
    // Fetch places again
    await fetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: maincolor,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final String? selectedPlace = await showSearch<String>(
                context: context,
                delegate: PlaceSearchDelegate(places: places),
              );
              if (selectedPlace != null) {
                fetchPlaceDetails(listPlaceId[places.indexOf(selectedPlace)]);
              }
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPlaces,
        child: isLoading
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
      ),
    );
  }
}

class PlaceSearchDelegate extends SearchDelegate<String> {
  final List<String> places;

  PlaceSearchDelegate({required this.places});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, '');
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final List<String> matchedPlaces = places
        .where((place) => place.toLowerCase().contains(query.toLowerCase()))
        .toList();

    if (matchedPlaces.isEmpty) {
      return const Center(
        child: Text('Подходящих мест не найдено.'),
      );
    }

    return ListView.builder(
      itemCount: matchedPlaces.length,
      itemBuilder: (context, index) {
        final String place = matchedPlaces[index];
        return ListTile(
          title: Text(place),
          onTap: () {
            close(context, place);
          },
        );
      },
    );
  }
}
