import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travel_app/const.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart' show rootBundle;

class PlaceDetailsHotel extends StatefulWidget {
  const PlaceDetailsHotel({super.key, required this.placeDetails});
  final Map<String, dynamic> placeDetails;

  @override
  State<PlaceDetailsHotel> createState() => _PlaceDetailsHotelState();
}

class _PlaceDetailsHotelState extends State<PlaceDetailsHotel> {
  final apiKey = 'AIzaSyC7Fxs-HxVQ7I0cp_T3XsywyfeJFgQ_gTw';
  late List<Map<String, dynamic>> hotels;

  @override
  void initState() {
    super.initState();
    loadHotelData();
  }

  Future<void> loadHotelData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/hotelprice.json');
      final dynamic jsonData = json.decode(jsonString);

      if (jsonData is Map<String, dynamic> && jsonData.containsKey('hotels')) {
        setState(() {
          hotels = (jsonData['hotels'] as List<dynamic>)
              .cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Invalid data format');
      }
    } catch (e) {
      print('Error loading hotel data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetHotel = hotels.firstWhere(
      (hotel) => hotel['name'] == widget.placeDetails['name'],
      orElse: () => {'name': 'Not Found'},
    );

    String pricelevel = '';
    bool visiblePriceLevel = false;

    if (widget.placeDetails['price_level'] != null) {
      setState(() {
        visiblePriceLevel = true;
      });
      if (widget.placeDetails['price_level']! == 0) {
        setState(() {
          pricelevel = 'Free';
        });
      } else if (widget.placeDetails['price_level']! == 1) {
        setState(() {
          pricelevel = '\$';
        });
      } else if (widget.placeDetails['price_level']! == 2) {
        setState(() {
          pricelevel = '\$\$';
        });
      } else if (widget.placeDetails['price_level']! == 3) {
        setState(() {
          pricelevel = '\$\$\$';
        });
      } else if (widget.placeDetails['price_level']! == 4) {
        setState(() {
          pricelevel = '\$\$\$\$';
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.placeDetails['photos'] != null &&
                  widget.placeDetails['photos'].isNotEmpty)
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  height: 250.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.placeDetails['photos'].length,
                    itemBuilder: (context, index) {
                      final photo = widget.placeDetails['photos'][index];
                      final photoReference = photo['photo_reference'];
                      final photoUrl =
                          'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$apiKey';

                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(8.0),
                        width: MediaQuery.of(context).size.width -
                            40, // Adjust the width as needed

                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                  photoUrl,
                                ),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.circular(10)),
                      );
                    },
                  ),
                ),
              const SizedBox(
                height: 20.0,
              ),
              Visibility(
                visible: widget.placeDetails['name'] != null ? true : false,
                child: Text(
                  widget.placeDetails['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              if (widget.placeDetails['rating'] != null)
                Text('Rating: ${widget.placeDetails['rating']}',
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.w500)),
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                  visible: visiblePriceLevel,
                  child: Text(
                    pricelevel,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.w500),
                  )),
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                  visible: widget.placeDetails['formatted_address'] != null
                      ? true
                      : false,
                  child: Text(
                    widget.placeDetails['formatted_address'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.w500),
                  )),
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: widget.placeDetails['formatted_phone_number'] != null
                    ? true
                    : false,
                child: InkWell(
                  onTap: () {
                    launchUrl(widget.placeDetails['formatted_phone_number']);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.call,
                        color: Colors.green,
                      ),
                      Text(
                        '${widget.placeDetails['formatted_phone_number'] ?? 'N/A'}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              const Text(
                'Opening Hours: ',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5.0,
              ),
              widget.placeDetails['opening_hours'] != null
                  ? Text(
                      '${widget.placeDetails['opening_hours']['weekday_text'].join('\n')}',
                      style: const TextStyle(fontSize: 15.0))
                  : const Text('No Schedule', style: TextStyle(fontSize: 15.0)),
              const SizedBox(
                height: 15.0,
              ),

              const SizedBox(height: 20),
              const Text('Rooms:',
                  style:
                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
              // Display rooms for the target hotel
              ...(targetHotel['rooms'] as List<dynamic>).map(
                (room) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Text('Type: ${room['type']}'),
                    const SizedBox(height: 5),
                    Text('Capacity: ${room['capacity']}'),
                    const SizedBox(height: 5),
                    Text('Price: ${room['price']} ₽ /ночь'),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: widget.placeDetails['website'] != null ? true : false,
                child: InkWell(
                  onTap: () async {
                    launchUrl(widget.placeDetails['website']);
                  },
                  child: Text(
                    '${widget.placeDetails['website'] ?? 'N/A'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),const SizedBox(
                height: 15.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}