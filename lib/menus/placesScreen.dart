import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:travel_app/apiCall.dart';
import 'package:travel_app/const.dart';
import 'package:travel_app/placeDetails.dart';
import 'package:travel_app/placesClass.dart';
import 'package:travel_app/widgets/custom_widgets.dart';
import 'package:http/http.dart' as http;

class TypePlaceScreen extends StatefulWidget {
  const TypePlaceScreen({Key? key, required this.typePlace}) : super(key: key);
  final String typePlace;

  @override
  State<TypePlaceScreen> createState() => _TypePlaceScreenState();
}

class _TypePlaceScreenState extends State<TypePlaceScreen> {
  bool isLoaded = true;
  int length = 0;

  int lengthList = 0;
  List? placeList;

  List placeIdList = [];
  List<String> imageUrl = [];

  // void getPlacesFromAPI() async {
  //   List listPlaceId = [];
  //   var listplaces;
  //   listplaces = await apiCall.fetchPlaces(widget.typePlace);

  //   for (var place in listplaces) {
  //     for (int i = 0; i < listPlaceId.length; i++) {
  //       final apiUrl = Uri.parse(
  //         '$baseUrl/details/json?place_id=${place['place_id']}&key=AIzaSyC7Fxs-HxVQ7I0cp_T3XsywyfeJFgQ_gTw',
  //       );
  //       final response = await http.get(apiUrl);

  //       if (response.statusCode == 200) {
  //         final data = json.decode(response.body);

  //         final placeDetails = data['result'];

  //         setState(() {
  //           lengthList = placeDetails.length;
  //           placeList = placeDetails;
  //         });

  //         print('Place Name: ${placeDetails['name']}');
  //         print('Place Address: ${placeDetails['formatted_address']}');
  //         if (placeDetails['photos'] != null) {
  //           for (var photo in placeDetails['photos']) {
  //             final photoReference = photo['photo_reference'];
  //             final photoUrl =
  //                 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=AIzaSyC7Fxs-HxVQ7I0cp_T3XsywyfeJFgQ_gTw';
  //             print('Photo URL: $photoUrl');
  //             imageUrl.add(photoUrl);
  //           }
  //         }
  //       } else {
  //         // Handle the API error
  //         print('API Request Error: ${response.statusCode}');
  //       }
  //     }
  //   }
  // }

  List places = [];

  @override
  void initState() {
    super.initState();
    apiCall.fetchPlaces(widget.typePlace).then((data) {
      setState(() {
        places = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(55),
            child: AppBar(
              elevation: 8,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              toolbarHeight: 18,
              flexibleSpace: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                      color: maincolor,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            widget.typePlace,
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.w700),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 8, 0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: FloatingActionButton(
                                elevation: 0.0,
                                onPressed: () {},
                                backgroundColor: Colors.transparent,
                                splashColor: Colors.grey.withOpacity(0.4),
                                mini: true,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Container(
            padding: const EdgeInsets.all(8.0),
            child: isLoaded == true
                ? CircularProgressIndicator()
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Adjust as needed
                    ),
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      final place = places[index];
                      return GridTile(
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(place['name'] ?? 'Name not available'),
                              Text(
                                  place['vicinity'] ?? 'Address not available'),
                              // Add more details you want to display here
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}


// SizedBox(
//                 child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('Place')
//                   .where('typePlace', isEqualTo: widget.typePlace)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return GridView.count(
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10.0,
//                     mainAxisSpacing: 10.0,
//                     children: snapshot.data!.docs
//                         .map((e) => Citycardmenu(
//                               imagename:  e'],
//                               cityname: (e.data() as dynamic)['name'],
//                               callback: (context) {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: ((context) => PlaceDetails(
//                                             image:
//                                                 (e.data() as dynamic)['image'],
//                                             name: (e.data() as dynamic)['name'],
//                                             numTel:
//                                                 (e.data() as dynamic)['numTel'],
//                                             address: (e.data()
//                                                 as dynamic)['address'],
//                                             timeOpenClose: (e.data()
//                                                 as dynamic)['timeOpenClose'],
//                                             website: (e.data()
//                                                 as dynamic)['website'],
//                                             price: (e.data()
//                                                 as dynamic)['price']))));
//                               },
//                             ))
//                         .toList(),
//                   );
//                 } else {
//                   return const Text('Loading');
//                 }
//               },
//             )
//                 //   ],
//                 // ),
//                 )