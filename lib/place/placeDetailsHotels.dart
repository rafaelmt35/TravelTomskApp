// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  late List<Map<String, dynamic>> hotels;
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
                  child: Scrollbar(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.placeDetails['photos'].length,
                      itemBuilder: (context, index) {
                        final photo = widget.placeDetails['photos'][index];
                        final photoReference = photo['photo_reference'];
                        final photoUrl =
                            'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=${dotenv.env["API_KEY"]}';

                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(8.0),
                          width: MediaQuery.of(context).size.width -
                              70, // Adjust the width as needed

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
                Text('Оценка: ${widget.placeDetails['rating']}',
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
                  onTap: () async {
                    final phoneNumber =
                        'tel:${widget.placeDetails['formatted_phone_number']}';
                    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
                      await launchUrl(Uri.parse(phoneNumber));
                    } else {
                      throw 'Could not launch $phoneNumber';
                    }
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
                'Часы работы: ',
                style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5.0,
              ),
              widget.placeDetails['opening_hours'] != null
                  ? Text(
                      '${widget.placeDetails['opening_hours']['weekday_text'].join('\n')}',
                      style: const TextStyle(fontSize: 15.0))
                  : const Text('Нет расписания',
                      style: TextStyle(fontSize: 15.0)),
              const SizedBox(
                height: 15.0,
              ),

              const SizedBox(height: 20),
              const Text('Комнат / номеров:',
                  style:
                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
              // Display rooms for the target hotel
              ...(targetHotel['rooms'] as List<dynamic>?)?.map(
                    (room) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text('Тип: ${room['type'] ?? 'N/A'}'),
                        const SizedBox(height: 5),
                        Text('Bместимость: ${room['capacity'] ?? 'N/A'}'),
                        const SizedBox(height: 5),
                        Text('Цена: ${room['price'] ?? 'N/A'} ₽ /ночь'),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ) ??
                  [
                    const Text('Данные о номерах не найдены'),
                  ],
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: widget.placeDetails['website'] != null ? true : false,
                child: InkWell(
                  onTap: () async {
                    if (await canLaunchUrl(
                        Uri.parse(widget.placeDetails['website']))) {
                      await launchUrl(
                          Uri.parse(widget.placeDetails['website']));
                    } else {
                      throw 'Could not launch ${widget.placeDetails['website']}';
                    }
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
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                height: 350,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                        widget.placeDetails['geometry']['location']['lat'],
                        widget.placeDetails['geometry']['location']['lng']),
                    zoom: 15.0,
                  ),
                  markers: _createMarkers(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: const MarkerId('place'),
        position: LatLng(widget.placeDetails['geometry']['location']['lat'],
            widget.placeDetails['geometry']['location']['lng']),
        infoWindow: InfoWindow(
          title: widget.placeDetails['name'] ?? '',
        ),
      ),
    };
  }
}
