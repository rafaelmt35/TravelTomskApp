// ignore_for_file: use_build_context_synchronously, unnecessary_string_interpolations, avoid_print, duplicate_import, unused_import, unused_local_variable, file_names

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:travel_app/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:travel_app/const.dart';
import 'package:travel_app/place/placeDetails.dart';
import 'package:travel_app/place/placeDetailsHotels.dart';
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
  int foodlevel = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;

  List<String> places = [];
  List<String> listPlaceId = [];
  List<String> placesother = [];
  List<String> listPlaceIdother = [];
  List restaurantList = [];
  List restaurantListName = [];
  List hotelslist = [];
  List hotelsid = [];
  bool isLoading = true;
  List<Map<String, dynamic>> hotels = [];
  List<String> placesMuseum = [];
  List<String> placesPark = [];
  Map<String, List<String>> placeSelectname = {};
  Map<String, List<String>> placeSelectid = {};

  Future<void> loadHotelData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/hotelprice.json');
      final dynamic jsonData = json.decode(jsonString);

      if (jsonData is Map<String, dynamic> && jsonData.containsKey('hotels')) {
        List<Map<String, dynamic>> allHotels =
            (jsonData['hotels'] as List<dynamic>).cast<Map<String, dynamic>>();
        hotels = allHotels.where((hotel) {
          return hotel['rooms'].any((room) {
            return room['capacity'] == widget.person &&
                room['price'] <= widget.hotelBudget;
          });
        }).toList();
      } else {
        throw Exception('Invalid data format');
      }
    } catch (e) {
      print('Error loading hotel data: $e');
    }
  }

  int getPriceForCapacity(Map<String, dynamic> hotel, int targetCapacity) {
    final List<dynamic> rooms = hotel['rooms'];

    for (final room in rooms) {
      final int capacity = room['capacity'];
      final int price = room['price'];

      if (capacity == targetCapacity) {
        return price;
      }
    }
    // Return a value indicating that the capacity was not found
    return -1;
  }

  Future<void> fetchLimitedPlaces(List<String> categories) async {
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place';
    const String apiKey = 'AIzaSyCuWazdpZriMm2R4MP3wDP7kyylL40nrcg';
    const String townName = 'Tomsk';

    // Clear previous data
    setState(() {
      placesMap.clear();
    });

    for (String category in categories) {
      final apiUrl = Uri.parse(
          '$baseUrl/textsearch/json?query=$category&location=$townName&key=$apiKey');
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        final limitedResults = results.take(widget.days).toList();

        setState(() {
          placesMap[category] =
              limitedResults.map((place) => place['name'] as String).toList();
          placesMapId[category] = limitedResults
              .map((place) => place['place_id'] as String)
              .toList();
        });
        print('Category: $category');
        for (String place in placesMap[category] ?? []) {
          print(' - $place');
        }
        for (String placeid in placesMapId[category] ?? []) {
          print(' - $placeid');
        }
      } else {
        throw Exception('Failed to load places for $category');
      }
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
        '$baseUrl/textsearch/json?query=restaurant&location=$townName&key=${dotenv.env["API_KEY"]}');
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
            '$baseUrl/details/json?place_id=${listPlaceId[i]}&key=${dotenv.env["API_KEY"]}');
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
          } else if (foodlevel == 0 && placeDetails['price_level'] == null) {
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

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlaceDetails(placeDetails: placeDetails),
        ),
      );
    } else {
      throw Exception('Failed to load place details');
    }
  }

  Map<String, List<String>> placesMap = {};
  Map<String, List<String>> placesMapId = {};

  @override
  void initState() {
    fetchRestaurant();
    loadHotelData();
    fetchLimitedPlaces(widget.selectedplaces);
    super.initState();
  }

  int hotelPrice = 0;
  String hotelName = '';
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String pricelevel = '';
    if (widget.choiceFoodRate == 'Choose.notexpensive') {
      setState(() {
        pricelevel = '';
      });
    } else if (widget.choiceFoodRate == 'Choose.moderate') {
      setState(() {
        pricelevel = '\$';
      });
    } else if (widget.choiceFoodRate == 'Choose.expensive') {
      setState(() {
        pricelevel = '\$\$';
      });
    } else if (widget.choiceFoodRate == 'Choose.veryexpensive') {
      setState(() {
        pricelevel = '\$\$\$';
      });
    }

    int selectedvalue = 0;
    TextEditingController nametripsave = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Результат',
          style: TextStyle(color: Colors.white),
        ),
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
                'Ваш бюджет : ${widget.maxBudget.toString()} ₽',
                style: const TextStyle(
                    fontSize: 19.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Ресторан  $pricelevel ',
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
                                print('Tile tapped: ${restaurantList[index]}');
                                // Fetch details for the selected place
                                fetchPlaceDetails(restaurantList[index]);
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
                '${widget.selectedplaces.join(', ')}',
                style: const TextStyle(
                    fontSize: 19.0, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(7.0),
                margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.circular(10)),
                height: 250.0,
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: placesMap.length * 2,
                    itemBuilder: (context, index) {
                      if (index.isOdd) {
                        return const Divider();
                      }

                      final categoryIndex = index ~/ 2;
                      final category = placesMap.keys.elementAt(categoryIndex);
                      final places = placesMap[category] ?? [];
                      final placesId = placesMapId[category] ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$category Section',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...places.asMap().entries.map((entry) {
                            final placeIndex = entry.key;
                            final place = entry.value;
                            final placeId = placesId[placeIndex];

                            return ListTile(
                              title: Text(place),
                              onTap: () {
                                fetchPlaceDetails(placeId);
                                print('Selected Place: $place');
                                print('Place ID: $placeId');
                              },
                            );
                          }),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Рекомендация отеля ',
                style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Список цен на отель <= ${widget.hotelBudget} ₽/ночь за ${widget.person} человек и ${widget.rooms} номер',
                style: const TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.circular(10)),
                height: 180.0,
                child: FutureBuilder(
                    future: loadHotelData(),
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (hotels.isNotEmpty) {
                          return Scrollbar(
                            child: ListView.builder(
                              itemCount: hotels.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  trailing: getPriceForCapacity(
                                              hotels[index], widget.person) ==
                                          -1
                                      ? const Text('Нет номера')
                                      : Text(
                                          '${getPriceForCapacity(hotels[index], widget.person)} ₽/ночь'),
                                  title: Text(hotels[index]['name']),
                                  subtitle: Text(
                                      '${getPriceForCapacity(hotels[index], widget.person) * (widget.days - 1) * widget.rooms} ₽ за ${widget.days - 1} ночь и ${widget.rooms} комнат'),
                                  onTap: () {
                                    setState(() {
                                      hotelPrice = getPriceForCapacity(
                                          hotels[index], widget.person);
                                      hotelName = hotels[index]['name'];
                                    });
                                    print(hotelPrice);
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text(
                                'Ни один отель не соответствует критериям.'),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Расчет бюджета',
                style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
              ),
              if (hotelName != '')
                Text(hotelName,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold)),
              if (hotelPrice != 0.0)
                Text('${hotelPrice.toString()} ₽/ночь',
                    style: const TextStyle(fontSize: 16.0)),
              Text(
                  '${hotelPrice * (widget.days - 1) * widget.rooms} ₽/ночь за ${widget.days - 1} ночь и ${widget.rooms} комнат',
                  style: const TextStyle(fontSize: 16.0)),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Оставшийся бюджет : ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                  '${widget.maxBudget} ₽ - ${hotelPrice * (widget.days - 1) * widget.rooms} ₽ = ${widget.maxBudget - (hotelPrice * (widget.days - 1) * widget.rooms)} ₽'),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Бюджетная стоимость на день : ',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              Text(
                  ' ${widget.maxBudget - (hotelPrice * (widget.days - 1) * widget.rooms)} ₽ / ${widget.days} = ${((widget.maxBudget - (hotelPrice * (widget.days - 1) * widget.rooms)) / widget.days).toStringAsFixed(2)} ₽'),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Center(
                      child: ButtonGoShort(
                          callback: (context) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text(
                                      'Введите название для сохранения поездки'),
                                  content: TextFormField(
                                    controller: _textEditingController,
                                    decoration: const InputDecoration(
                                      hintText: '...',
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: const Text('ОТМЕНИТЬ'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        String enteredText =
                                            _textEditingController.text;
                                        Map<String, dynamic> data = {
                                          'name': enteredText,
                                          'maxBudget': widget.maxBudget,
                                          'days': widget.days,
                                          'room': widget.rooms,
                                          'person': widget.person,
                                          'RestaurantChoice':
                                              widget.choiceFoodRate,
                                          'RestaurantList': restaurantList,
                                          'HotelList': hotels,
                                          'Places': placesMapId,
                                          'categoryChoose':
                                              widget.selectedplaces,
                                          'hotelBudget': widget.hotelBudget,
                                          'uid': user!.uid
                                        };
                                        firestore
                                            .collection('Trip')
                                            .add(data)
                                            .then((value) {
                                          print('Data added successfully!');
                                        }).catchError((error) {
                                          print('Error adding data: $error');
                                        });
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) => HomePage(
                                                      signInWithoutGoogle: widget
                                                          .signInWithoutGoogle,
                                                    ))));
                                        Navigator.popUntil(
                                            context, ModalRoute.withName('/'));

                                        print('Entered Text: $enteredText');
                                      },
                                      child: const Text('СОХРАНИТЬ'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          command: 'СОХРАНИТЬ')),
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
                            Navigator.popUntil(
                                context, ModalRoute.withName('/'));
                          },
                          command: 'ВЕРНУТЬСЯ НА ГЛАВНУЮ СТРАНИЦУ'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
