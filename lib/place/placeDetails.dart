import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travel_app/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetails extends StatefulWidget {
  const PlaceDetails({Key? key, required this.placeDetails}) : super(key: key);
  final Map<String, dynamic> placeDetails;

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    String priceLevelText = '';
    bool visiblePriceLevel = false;

    final List<String> weekdayText =
        (widget.placeDetails['opening_hours'] != null &&
                widget.placeDetails['opening_hours']['weekday_text'] != null)
            ? List<String>.from(
                widget.placeDetails['opening_hours']['weekday_text'])
            : [];

    if (widget.placeDetails['price_level'] != null) {
      visiblePriceLevel = true;
      switch (widget.placeDetails['price_level']) {
        case 0:
          priceLevelText = 'Free';
          break;
        case 1:
          priceLevelText = '\$';
          break;
        case 2:
          priceLevelText = '\$\$';
          break;
        case 3:
          priceLevelText = '\$\$\$';
          break;
        case 4:
          priceLevelText = '\$\$\$\$';
          break;
        default:
          priceLevelText = '';
          break;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.placeDetails['photos'] != null &&
                  widget.placeDetails['photos'].isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                          width: MediaQuery.of(context).size.width - 70,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(photoUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 20.0),
              Visibility(
                visible: widget.placeDetails['name'] != null,
                child: Text(
                  widget.placeDetails['name'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              if (widget.placeDetails['rating'] != null)
                Text(
                  'Оценка: ${widget.placeDetails['rating']}',
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              const SizedBox(height: 15.0),
              Visibility(
                visible: visiblePriceLevel,
                child: Text(
                  priceLevelText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Visibility(
                visible: widget.placeDetails['formatted_address'] != null,
                child: Text(
                  widget.placeDetails['formatted_address'] ?? '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Visibility(
                visible: widget.placeDetails['formatted_phone_number'] != null,
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
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              const Text(
                'Часы работы: ',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5.0),
              if (weekdayText.isNotEmpty)
                Column(
                  children: weekdayText
                      .map(
                        (schedule) => Text(
                          schedule,
                          style: const TextStyle(fontSize: 15.0),
                        ),
                      )
                      .toList(),
                )
              else
                const Text(
                  'Нет расписания',
                  style: TextStyle(fontSize: 15.0),
                ),
              const SizedBox(height: 15.0),
              Visibility(
                visible: widget.placeDetails['website'] != null,
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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                height: 350,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      widget.placeDetails['geometry']['location']['lat'],
                      widget.placeDetails['geometry']['location']['lng'],
                    ),
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
        position: LatLng(
          widget.placeDetails['geometry']['location']['lat'],
          widget.placeDetails['geometry']['location']['lng'],
        ),
        infoWindow: InfoWindow(
          title: widget.placeDetails['name'] ?? '',
        ),
      ),
    };
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
