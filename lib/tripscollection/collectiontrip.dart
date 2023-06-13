import 'package:flutter/material.dart';
import 'package:travel_app/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:travel_app/tripscollection/tripPage.dart';

class CollectionTrips extends StatefulWidget {
  const CollectionTrips({super.key});

  @override
  State<CollectionTrips> createState() => _CollectionTripsState();
}

class _CollectionTripsState extends State<CollectionTrips> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<String> placeList = [];
  String tripName = '';
  num totalCost = 0;
  final user = FirebaseAuth.instance.currentUser;
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('Trip');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: const Text('Trip Collection'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: collectionRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic>? data =
                      documents[index].data() as Map<String, dynamic>?;
                  String? tripName = data?['name'];
                  int? totalCost = data?['totalCost'];
                  List<dynamic>? referenceArray = data?['Places'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => TripPage(
                                  name: data?['name'],
                                  totalCost: data?['totalCost'],
                                  places: data?['Places']))));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(bottom: 15.0),
                      width: 120.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 1.0, color: Colors.black)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(tripName!), Text('$totalCost ₽')],
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Error retrieving documents');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
