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

  Future<void> deleteDocument(String documentId) async {
    try {
      // Assuming 'collectionRef' is the reference to the Firestore collection
      await collectionRef.doc(documentId).delete();
      print('Document deleted successfully');
    } catch (e) {
      print('Error deleting document: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
        title: const Text('Коллекция поездок'),
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
                  int? totalCost = data?['maxBudget'];
                  int? days = data?['days'];
                  int? person = data?['person'];
                  int? room = data?['room'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => TripPage(
                                    hotelBudget: data?['hotelBudget'],
                                    choice: List<String>.from(
                                        data?['categoryChoose']),
                                    name: data?['name'],
                                    totalCost: data?['maxBudget'],
                                    days: data?['days'],
                                    rooms: data?['room'],
                                    places: data?['Places'],
                                    HotelList: data?['HotelList'],
                                    restaurantChoice: data?['RestaurantChoice'],
                                    RestaurantList: List<String>.from(
                                        data?['RestaurantList']),
                                    person: data?['person'],
                                  ))));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(bottom: 15.0),
                      height: 70.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 1.0, color: Colors.black)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tripName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${days.toString()} дня для ${person.toString()} человек в ${room.toString()} номере',
                                    style: const TextStyle(fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Общий бюджет:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0)),
                              Text('$totalCost ₽'),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteDocument(documents[index].id);
                            },
                          ),
                        ],
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
