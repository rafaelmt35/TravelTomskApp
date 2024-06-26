// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:travel_app/filtration/selecthowmanydays.dart';
import 'package:travel_app/const.dart';

import 'package:travel_app/signin_service/googlesignin.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/place/listPlacesfromAPI.dart';
import 'package:travel_app/tripscollection/collectiontrip.dart';

import 'place/placeDetails.dart';
import 'place/recommendationPlace.dart';
import 'widgets/custom_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.signInWithoutGoogle})
      : super(key: key);
  final bool signInWithoutGoogle;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> placeList = [];
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    print(user!.uid);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> placeCollectionReference =
        firestore.collection('Place');

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: AppBar(
            elevation: 8,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25))),
            toolbarHeight: 18,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                  color: maincolor,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(21, 28, 15, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Hello ... !',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          children: [
                            FloatingActionButton(
                              heroTag: null,
                              elevation: 0.0,
                              onPressed: () async {
                                if (widget.signInWithoutGoogle == true) {
                                  FirebaseAuth
                                      .instance.currentUser?.providerData;
                                  await FirebaseAuth.instance.signOut();
                                } else {
                                  final provider =
                                      Provider.of<GoogleSignInProvider>(context,
                                          listen: false);
                                  provider.googleLogOut();
                                  await FirebaseAuth.instance.signOut();
                                }
                              },
                              backgroundColor: Colors.transparent,
                              splashColor: Colors.grey.withOpacity(0.4),
                              mini: true,
                              child: const Icon(
                                Icons.logout,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(21, 3, 15, 7),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Куда хотите пойти сегодня?',
                          style: TextStyle(
                              color: Color(0xff002A69),
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              fontFamily: 'Inter'),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    ButtonMenuLong(
                      callback: (context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CollectionTrips(
                                      uid: user!.uid,
                                    )));
                      },
                      command: 'КОЛЛЕКЦИЯ',
                      iconname: Icons.collections,
                    ),
                    ButtonMenuLong(
                      callback: (context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CountDays(
                                      signInWithoutGoogle:
                                          widget.signInWithoutGoogle,
                                    )));
                      },
                      command: 'БЮДЖЕТ',
                      iconname: Icons.monetization_on,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Smallmenubox(
                        iconname: Icons.hotel,
                        menuname: 'Отели',
                        callback: (context) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PlaceSearchPage(
                                    title: 'Отели',
                                    query: 'hotel',
                                  )));
                        },
                      ),
                      Smallmenubox(
                        iconname: Icons.food_bank_outlined,
                        menuname: 'Ресторан',
                        callback: (context) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PlaceSearchPage(
                                    title: 'Ресторан',
                                    query: 'restaurant',
                                  )));
                        },
                      ),
                      Smallmenubox(
                        iconname: Icons.park_outlined,
                        menuname: 'Парк',
                        callback: (context) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PlaceSearchPage(
                                    title: 'Парк',
                                    query: 'park',
                                  )));
                        },
                      ),
                      Smallmenubox(
                        iconname: Icons.coffee_rounded,
                        menuname: 'Кафе',
                        callback: (context) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PlaceSearchPage(
                                    title: 'Кафе',
                                    query: 'cafe',
                                  )));
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Smallmenubox(
                      iconname: Icons.local_pharmacy,
                      menuname: 'Аптека',
                      callback: (context) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PlaceSearchPage(
                                  title: 'Аптека',
                                  query: 'pharmacy',
                                )));
                      },
                    ),
                    Smallmenubox(
                      iconname: Icons.museum,
                      menuname: 'Музей',
                      callback: (context) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PlaceSearchPage(
                                  title: 'Музей',
                                  query: 'museums',
                                )));
                      },
                    ),
                    Smallmenubox(
                      iconname: Icons.local_mall_sharp,
                      menuname: 'ТЦ',
                      callback: (context) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PlaceSearchPage(
                                  title: 'ТЦ',
                                  query: 'malls',
                                )));
                      },
                    ),
                    Smallmenubox(
                      iconname: Icons.school,
                      menuname: 'Университет',
                      callback: (context) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PlaceSearchPage(
                                  title: 'Университет',
                                  query: 'university',
                                )));
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.fromLTRB(21, 11, 10, 10),
                      child: Text(
                        'Рекомендация',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      height: 23,
                      width: 23,
                      child: FloatingActionButton(
                        heroTag: null,
                        backgroundColor: const Color(0xff588CDA),
                        elevation: 0.2,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RecommendationPage(
                                          title: 'Рекомендация')));
                        },
                        child: const Icon(
                          Icons.double_arrow_outlined,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 235.0,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: ListView(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: placeCollectionReference.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Row(
                                  children: snapshot.data!.docs
                                      .map((e) => Citycardmenu(
                                            imagename:
                                                (e.data() as dynamic)['image'],
                                            cityname:
                                                (e.data() as dynamic)['name'],
                                            callback: (context) async {
                                              const String baseUrl =
                                                  'https://maps.googleapis.com/maps/api/place';
                                              final apiKey =
                                                  dotenv.env['API_KEY'];
                                              final apiUrl = Uri.parse(
                                                  '$baseUrl/findplacefromtext/json?input=${(e.data() as dynamic)['name']}&inputtype=textquery&fields=place_id&key=$apiKey');

                                              final response =
                                                  await http.get(apiUrl);

                                              if (response.statusCode == 200) {
                                                final data =
                                                    json.decode(response.body);
                                                final candidates =
                                                    data['candidates'];

                                                if (candidates.isNotEmpty) {
                                                  final placeId =
                                                      candidates[0]['place_id'];
                                                  final detailsUrl = Uri.parse(
                                                      '$baseUrl/details/json?place_id=$placeId&key=$apiKey');

                                                  final detailsResponse =
                                                      await http
                                                          .get(detailsUrl);

                                                  if (detailsResponse
                                                          .statusCode ==
                                                      200) {
                                                    final placeDetails = json
                                                        .decode(detailsResponse
                                                            .body)['result'];

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PlaceDetails(
                                                                placeDetails:
                                                                    placeDetails),
                                                      ),
                                                    );
                                                  } else {
                                                    throw Exception(
                                                        'Failed to load place details');
                                                  }
                                                } else {
                                                  throw Exception(
                                                      'Place not found');
                                                }
                                              } else {
                                                throw Exception(
                                                    'Failed to search for place');
                                              }
                                            },
                                          ))
                                      .toList());
                            } else {
                              return const Text('Loading');
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
