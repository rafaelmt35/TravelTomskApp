// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travel_app/filtration/databaseServices.dart';
import 'package:travel_app/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/const.dart';
import 'package:travel_app/placeDetails.dart';
import 'package:travel_app/placeDetailsHotels.dart';
import 'dart:convert';
import '../const.dart';

import '../widgets/custom_widgets.dart';

class ResultFiltration extends StatefulWidget {
  const ResultFiltration(
      {super.key,
      required this.signInWithoutGoogle,
      required this.days,
      required this.maxBudget,
      required this.rooms,
      required this.selectedplaces,
      required this.choiceFoodRate,
      required this.hotelBudget,
      required this.person});
  final int days;
  final int rooms;
  final int person;
  final int hotelBudget;
  final List<String> selectedplaces;
  final String choiceFoodRate;
  final int maxBudget;
  final bool signInWithoutGoogle;
  @override
  State<ResultFiltration> createState() => _ResultFiltrationState();
}

class _ResultFiltrationState extends State<ResultFiltration> {
  var databaseservice = DatabaseServices();

  int foodlevel = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final apiKey =
      'AIzaSyCuWazdpZriMm2R4MP3wDP7kyylL40nrcg'; // Replace with your Google Places API key

  List<String> places = [];
  List<String> listPlaceId = [];
  List<String> placesother = [];
  List<String> listPlaceIdother = [];
  List restaurantList = [];
  List restaurantListName = [];
  List hotelslist = [];
  List hotelsid = [];
  bool isLoading = true;

  void processJsonFile() async {
    // Read JSON data from the file
    String jsonData = await rootBundle.loadString('assets/hotelprice.json');

    // Parse the JSON
    Map<String, dynamic> data = json.decode(jsonData);

    List<Map<String, dynamic>> filteredHotels = data['hotels']
        .where((hotel) =>
            hotel['rooms'].any((room) => room['capacity'] == widget.person))
        .toList();

    // Print the filtered hotels
    print('Filtered Hotels:');
    filteredHotels.forEach((hotel) {
      print('Hotel: ${hotel['name']}');
    });
  }

  void placeFetching() {
    for (int i = 0; i < widget.selectedplaces.length; i++) {
      fetchOtherPlace(widget.selectedplaces[i]);
    }
  }

  Future<void> fetchOtherPlace(String query) async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place';
    const String townName = 'Tomsk';
    final apiUrl = Uri.parse(
        '$baseUrl/textsearch/json?query=$query&location=$townName&key=$apiKey');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      setState(() {
        placesother = results.map((place) => place['name'] as String).toList();
        listPlaceIdother =
            results.map((place) => place['place_id'] as String).toList();
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> fetchPlacesHotel() async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place';
    const String townName = 'Tomsk';
    final apiUrl = Uri.parse(
        '$baseUrl/textsearch/json?query=hotel&location=$townName&key=$apiKey');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final datahotel = json.decode(response.body);
      final resultshotel = datahotel['results'] as List;
      setState(() {
        hotelslist =
            resultshotel.map((place) => place['name'] as String).toList();
        hotelsid =
            resultshotel.map((place) => place['place_id'] as String).toList();
        isLoading = false;
      });

      for (int i = 0; i < hotelsid.length; i++) {
        final apiUrlDetail = Uri.parse(
            '$baseUrl/details/json?place_id=${hotelsid[i]}&key=$apiKey');
        final responsedetail = await http.get(apiUrlDetail);
        if (responsedetail.statusCode == 200) {
          final datadetail = json.decode(responsedetail.body);
          final placeDetails = datadetail['result'];

          if (placeDetails['price_level'] == foodlevel) {
            setState(() {
              restaurantList.add(listPlaceId[i]);
              restaurantListName.add(placeDetails['name']);
            });
            print(placeDetails['name']);
          }
        }
      }
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> fetchRestaurant() async {
    if (widget.choiceFoodRate == 'Choose.notexpensive') {
      setState(() {
        foodlevel = 0;
      });
    } else if (widget.choiceFoodRate == 'Choose.moderate') {
      setState(() {
        foodlevel = 1;
      });
    } else if (widget.choiceFoodRate == 'Choose.expensive') {
      setState(() {
        foodlevel = 2;
      });
    } else if (widget.choiceFoodRate == 'Choose.veryexpensive') {
      setState(() {
        foodlevel = 3;
      });
    }
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place';
    const String townName = 'Tomsk';
    final apiUrl = Uri.parse(
        '$baseUrl/textsearch/json?query=restaurant&location=$townName&key=$apiKey');
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

      for (int i = 0; i < listPlaceId.length; i++) {
        final apiUrlDetail = Uri.parse(
            '$baseUrl/details/json?place_id=${listPlaceId[i]}&key=$apiKey');
        final responsedetail = await http.get(apiUrlDetail);
        if (responsedetail.statusCode == 200) {
          final datadetail = json.decode(responsedetail.body);
          final placeDetails = datadetail['result'];
          if (placeDetails['price_level'] == foodlevel) {
            setState(() {
              restaurantList.add(listPlaceId[i]);
              restaurantListName.add(placeDetails['name']);
            });
            print(placeDetails['name']);
          }
        }
      }
    } else {
      throw Exception('Failed to load places');
    }
  }

  Future<void> fetchPlaceDetails(String placeId, bool hotelorNot) async {
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

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => hotelorNot == true
              ? PlaceDetailsHotel(placeDetails: placeDetails)
              : PlaceDetails(placeDetails: placeDetails),
        ),
      );
    } else {
      throw Exception('Failed to load place details');
    }
  }

  @override
  void initState() {
    fetchRestaurant();
    placeFetching();
    fetchPlacesHotel();
    processJsonFile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String pricelevel = '';
    if (widget.choiceFoodRate == 'Choose.notexpensive') {
      setState(() {
        pricelevel = '\$';
      });
    } else if (widget.choiceFoodRate == 'Choose.moderate') {
      setState(() {
        pricelevel = '\$\$';
      });
    } else if (widget.choiceFoodRate == 'Choose.expensive') {
      setState(() {
        pricelevel = '\$\$\$';
      });
    } else if (widget.choiceFoodRate == 'Choose.veryexpensive') {
      setState(() {
        pricelevel = '\$\$\$\$';
      });
    }

    int selectedvalue = 0;
    TextEditingController nametripsave = TextEditingController();
    // int len = widget.selectedplaces.length;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
          backgroundColor: maincolor,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Budget : ${widget.maxBudget.toString()} ₽',
                  style: const TextStyle(
                      fontSize: 19.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Restaurant  $pricelevel ',
                  style: const TextStyle(
                      fontSize: 19.0, fontWeight: FontWeight.bold),
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0),
                            borderRadius: BorderRadius.circular(10)),
                        height: 180.0,
                        child: Scrollbar(
                          child: ListView.builder(
                            itemCount: restaurantList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(restaurantListName[index]),
                                onTap: () {
                                  // Handle tile tap
                                  print(
                                      'Tile tapped: ${restaurantList[index]}');
                                  // Fetch details for the selected place
                                  fetchPlaceDetails(
                                      restaurantList[index], false);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  ' ${widget.selectedplaces} ',
                  style: const TextStyle(
                      fontSize: 19.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  ' Hotel Recommendation ',
                  style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
                ),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Container(
                        margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0),
                            borderRadius: BorderRadius.circular(10)),
                        height: 180.0,
                        child: Scrollbar(
                          child: ListView.builder(
                            itemCount: hotelslist.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(hotelslist[index]),
                                onTap: () {
                                  // Handle tile tap
                                  print('Tile tapped: ${hotelslist[index]}');
                                  // Fetch details for the selected place
                                  fetchPlaceDetails(hotelsid[index], true);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: ButtonGo(
                            callback: (context) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                        'Enter Name for saving trip'),
                                    content: TextFormField(
                                      controller: nametripsave,
                                      decoration: const InputDecoration(
                                        hintText: 'Type something...',
                                      ),
                                    ),
                                    actions: [
                                      ButtonGo(
                                        callback: (context) {
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                        command: 'Cancel',
                                      ),
                                      ButtonGo(
                                        callback: (context) {
                                          // String enteredText =
                                          //     nametripsave.text;
                                          // Map<String, dynamic> data = {
                                          //   'name': enteredText,
                                          //   'totalCost': widget.maxBudget,
                                          //   'Places': listDocRef,
                                          //   'days': widget.days,
                                          //   'rooms': widget.rooms,
                                          //   // 'choice': widget.choices,
                                          // };
                                          // firestore
                                          //     .collection('Trip')
                                          //     .add(data)
                                          //     .then((value) {
                                          //   print('Data added successfully!');
                                          // }).catchError((error) {
                                          //   print('Error adding data: $error');
                                          // });
                                          // Navigator.pushReplacement(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: ((context) => HomePage(
                                          //             signInWithoutGoogle: widget
                                          //                 .signInWithoutGoogle))));
                                        },
                                        command: 'Save',
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            command: 'SAVE')),
                    Center(
                        child: ButtonGo(
                            callback: (context) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => HomePage(
                                            signInWithoutGoogle:
                                                widget.signInWithoutGoogle,
                                          ))));
                            },
                            command: 'BACK TO HOME'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
