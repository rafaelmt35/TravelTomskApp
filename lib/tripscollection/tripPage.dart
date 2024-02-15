// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/const.dart';
import 'package:travel_app/widgets/custom_widgets.dart';
import 'package:http/http.dart' as http;

import '../placeDetails.dart';
import '../placeDetailsHotels.dart';

class Room {
  num capacity;
  num price;
  String type;

  Room({required this.capacity, required this.price, required this.type});
  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      capacity: map['capacity'],
      type: map['type'],
      price: map['price'],
    );
  }
}

class HotelDetails {
  String name;
  List<Room> rooms;

  HotelDetails({required this.name, required this.rooms});

  factory HotelDetails.fromMap(Map<String, dynamic> map) {
    return HotelDetails(
      name: map['name'],
      rooms: (map['rooms'] as List<dynamic>)
          .map((roomMap) => Room.fromMap(roomMap))
          .toList(),
    );
  }
}

class TripPage extends StatefulWidget {
  const TripPage(
      {super.key,
      required this.choice,
      required this.name,
      required this.days,
      required this.rooms,
      required this.totalCost,
      required this.places,
      required this.HotelList,
      required this.restaurantChoice,
      required this.RestaurantList,
      required this.person,
      this.hotelBudget});
  final String? name;
  final num? totalCost;
  final Map<String, dynamic> places;
  final List<dynamic>? HotelList;
  final String? restaurantChoice;
  final List<String>? RestaurantList;
  final num? person;
  final num? days;
  final num? rooms;
  final num? hotelBudget;
  final List<String>? choice;
  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  List<String> RestaurantName = [];

  final apiKey = 'AIzaSyCuWazdpZriMm2R4MP3wDP7kyylL40nrcg';

  Future<String?> getPlaceName(String placeId) async {
    final apiUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey');

    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final result = data['result'];

      if (result != null && result['name'] != null) {
        return result['name'];
      }
      RestaurantName.add(result['name']);
    }

    return null;
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

  // Future<void> fetchPlacesNames() async {
  //   for (String placeId in widget.RestaurantList!) {
  //     String? placeName = await getPlaceName(placeId);

  //     if (placeName != null) {
  //       setState(() {
  //         RestaurantName.add(placeName);
  //       });
  //     }
  //   }
  // }

  Future<void> fetchRestaurantNames() async {
    for (String placeId in widget.RestaurantList!) {
      String? placeName = await getPlaceName(placeId);

      if (placeName != null) {
        setState(() {
          RestaurantName.add(placeName);
        });
      }
    }
  }

  Future<void> fetchHotelDetails(String placeId) async {
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
            builder: (context) =>
                PlaceDetailsHotel(placeDetails: placeDetails)),
      );
    } else {
      throw Exception('Failed to load place details');
    }
  }

  @override
  void initState() {
    fetchRestaurantNames();
    super.initState();
  }

  int hotelPrice = 0;
  String hotelName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name!),
        backgroundColor: maincolor,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Бюджет : ${widget.totalCost} ₽',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'День : ${widget.days}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Предпочитания : ${widget.choice!.join(', ')}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Нужны номеров/комнат : ${widget.rooms}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'Человек/комнат : ${widget.person}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text(
                'Список ресторанов',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.all(7.0),
                margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                decoration: BoxDecoration(
                    border: Border.all(width: 1.0),
                    borderRadius: BorderRadius.circular(10)),
                height: 150.0,
                child: ListView.builder(
                  itemCount: widget.RestaurantList!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(RestaurantName[index]),
                      onTap: () {
                        fetchPlaceDetails(widget.RestaurantList![index]);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                widget.choice!.join(', '),
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    itemCount: widget.places.length * 2,
                    itemBuilder: (context, index) {
                      if (index.isOdd) {
                        return const Divider();
                      }

                      final categoryIndex = index ~/ 2;
                      final category =
                          widget.places.keys.elementAt(categoryIndex);
                      final places = widget.places[category] ?? [];
                      final placesId = widget.places[category] ?? [];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(category,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...places.asMap().entries.map((entry) {
                            final placeIndex = entry.key;
                            final placeId = placesId[placeIndex];

                            return ListTile(
                              title: FutureBuilder<String?>(
                                future: getPlaceName(placeId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return const Text('Error');
                                    } else if (snapshot.hasData) {
                                      return Text(snapshot.data!);
                                    } else {
                                      return const Text('Загрузка...');
                                    }
                                  } else {
                                    return const Text('Загрузка...');
                                  }
                                },
                              ),
                              onTap: () {
                                fetchPlaceDetails(placeId);
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
                height: 20.0,
              ),
              Text(
                'Рекомендации по списку отелей <= ${widget.hotelBudget} ₽/ночь',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                  padding: const EdgeInsets.all(7.0),
                  margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0),
                      borderRadius: BorderRadius.circular(10)),
                  height: 200.0,
                  child: ListView.builder(
                    itemCount: widget.HotelList!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        trailing: getPriceForCapacity(widget.HotelList![index],
                                    widget.person!.toInt()) ==
                                -1
                            ? const Text('Нет номера в отеле')
                            : Text(
                                '${getPriceForCapacity(widget.HotelList![index], widget.person!.toInt())} ₽/ночь'),
                        title: Text(widget.HotelList![index]['name']),
                        subtitle: Text(
                            '${getPriceForCapacity(widget.HotelList![index], widget.person!.toInt()) * (widget.days!.toInt() - 1) * widget.rooms!.toInt()} ₽ для ${widget.days!.toInt() - 1} ночь и ${widget.rooms!.toInt()} комнат'),
                        onTap: () {
                          setState(() {
                            hotelPrice = getPriceForCapacity(
                                widget.HotelList![index],
                                widget.person!.toInt());
                            hotelName = widget.HotelList![index]['name'];
                          });
                        },
                      );
                    },
                  )),
              const SizedBox(
                height: 20.0,
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
                  '${hotelPrice * (widget.days!.toInt() - 1) * widget.rooms!.toInt()} ₽/ночь для ${widget.days!.toInt() - 1} ночь и ${widget.rooms!.toInt()} комнат',
                  style: const TextStyle(fontSize: 16.0)),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Оставшийся бюджет : ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                  '${widget.totalCost!.toInt()} ₽ - ${hotelPrice * (widget.days!.toInt() - 1) * widget.rooms!.toInt()} ₽ = ${widget.totalCost!.toInt() - (hotelPrice * (widget.days!.toInt() - 1) * widget.rooms!.toInt())} ₽'),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Бюджетная стоимость на день : ',
                style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
              ),
              Text(
                  ' ${widget.totalCost!.toInt() - (hotelPrice * (widget.days!.toInt() - 1) * widget.rooms!.toInt())} ₽ / ${widget.days!.toInt()} = ${(widget.totalCost!.toInt() - (hotelPrice * (widget.days!.toInt() - 1) * widget.rooms!.toInt())) / widget.days!.toInt()} ₽'),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
