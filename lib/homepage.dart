import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:travel_app/filtration/databaseServices.dart';
import 'package:travel_app/filtration/selecthowmanydays.dart';
import 'package:travel_app/const.dart';

import 'package:travel_app/signin_service/googlesignin.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/test.dart';
import 'package:travel_app/tripscollection/collectiontrip.dart';

import 'widgets/custom_widgets.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.signInWithoutGoogle}) : super(key: key);
  final bool signInWithoutGoogle;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> placeList = [];
  var databaseservice = DatabaseServices();
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    databaseservice.getPlaceNameList(placeList, 'Place');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Query<Map<String, dynamic>> placeCollectionReference =
        firestore.collection('Place').limit(8);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(21, 5, 15, 8),
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
                                        Provider.of<GoogleSignInProvider>(
                                            context,
                                            listen: false);
                                    provider.googleLogOut();
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
                              FloatingActionButton(
                                heroTag: null,
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
                            'Any destinations today?',
                            style: TextStyle(
                                color: Color(0xff002A69),
                                fontWeight: FontWeight.bold,
                                fontSize: 23.0,
                                fontFamily: 'Inter'),
                          )),
                    ),
                  ],
                ),
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
                                builder: (context) => const CollectionTrips()));
                      },
                      command: 'COLLECTION',
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
                      command: 'BUDGET',
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
                        menuname: 'Hotels',
                        callback: (context) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PlaceSearchPage(
                                    query: 'hotel',
                                  )));
                        },
                      ),
                      Smallmenubox(
                        iconname: Icons.food_bank_outlined,
                        menuname: 'Restaurant',
                        callback: (context) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PlaceSearchPage(
                                    query: 'restaurant',
                                  )));
                        },
                      ),
                      Smallmenubox(
                        iconname: Icons.park_outlined,
                        menuname: 'Park',
                        callback: (context) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PlaceSearchPage(
                                    query: 'park',
                                  )));
                        },
                      ),
                      Smallmenubox(
                        iconname: Icons.coffee_rounded,
                        menuname: 'Cafe',
                        callback: (context) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const PlaceSearchPage(
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
                      menuname: 'Pharmacy',
                      callback: (context) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PlaceSearchPage(
                                  query: 'pharmacy',
                                )));
                      },
                    ),
                    Smallmenubox(
                      iconname: Icons.museum,
                      menuname: 'Museum',
                      callback: (context) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PlaceSearchPage(
                                  query: 'museums',
                                )));
                      },
                    ),
                    Smallmenubox(
                      iconname: Icons.local_mall_sharp,
                      menuname: 'Malls',
                      callback: (context) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PlaceSearchPage(
                                  query: 'malls',
                                )));
                      },
                    ),
                    Smallmenubox(
                      iconname: Icons.school,
                      menuname: 'University',
                      callback: (context) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const PlaceSearchPage(
                                  query: 'university',
                                )));
                      },
                    ),
                  ],
                ),
                CommandWidget('Recommendation', () {}),
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
                                            callback: (context) {},
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
                CommandWidget('Your Next Trip', () {}),
                const Nexttripmenu(
                  desc:
                      'Located on the world-famous Santa Monica Pier, Pacific Park is the family place to play!',
                  title: 'Pacific Park',
                  imagename:
                      'https://upload.wikimedia.org/wikipedia/commons/thumb/7/79/Copenhagen_Frederiksberg_Have.jpg/800px-Copenhagen_Frederiksberg_Have.jpg',
                ),
                const Nexttripmenu(
                    desc:
                        'Located on the world-famous Santa Monica Pier, Pacific Park is the family place to play!',
                    title: 'Pacific Park',
                    imagename:
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/7/79/Copenhagen_Frederiksberg_Have.jpg/800px-Copenhagen_Frederiksberg_Have.jpg'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//NEXT TRIP MENU
