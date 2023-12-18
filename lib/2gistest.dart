import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Place {
  final String name;
  final String address;
  // final int phoneNumber;
  // final String email;
  // final String openingHours;
  // final String websiteUrl;
  // final String description;

  Place({
    required this.address,
    // required this.phoneNumber,
    // required this.email,
    // required this.openingHours,
    // required this.websiteUrl,
    // required this.description,
    required this.name,
  });
}

class PlaceListPage extends StatefulWidget {
  @override
  _PlaceListPageState createState() => _PlaceListPageState();
}

class _PlaceListPageState extends State<PlaceListPage> {
  final String apiKey = '4bba40fd-71db-44e3-8d3b-9d95726bee8f';
  final String city = 'Tomsk';
  final String placeType =
      'restaurant'; // You can change this based on your query

  List<Place> places = [];

  @override
  void initState() {
    super.initState();
    fetchPlaces();
  }

  Future<void> fetchPlaces() async {
    final response = await http.get(Uri.parse(
        'https://catalog.api.2gis.com/3.0/items?q=университет&city_id=422835235324469&key=$apiKey'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      setState(() {
        places = (data['result']['items'] as List)
            .map((item) => Place(
                  name: item['name'],
                  address: item['address'] ?? '',
                  // phoneNumber: item['contacts']['phone'] ?? '',
                  // email: item['contacts']['email'] ?? '',
                  // openingHours: item['schedule']['text'] ?? '',
                  // websiteUrl: item['contacts']['website'] ?? '',
                  // description: item['description']['text'] ?? '',
                ))
            .toList();
      });
    } else {
      throw Exception('Failed to load places');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2GIS Places - $placeType in $city'),
      ),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(places[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceDetailsPage(place: places[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PlaceDetailsPage extends StatelessWidget {
  final Place place;

  PlaceDetailsPage({required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(place.name),
            Text('Place ID: ${place.address}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
