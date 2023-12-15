import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../placeDetails.dart';
import '../widgets/custom_widgets.dart';

class DatabaseServices {
  Future<List<DocumentReference>> getDocRefPlaces(
      String params, int days) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Place")
        .where('typePlace', isEqualTo: params)
        .limit(days)
        .get();

    List<DocumentReference> documentReferences =
        querySnapshot.docs.map((doc) => doc.reference).toList();

    return documentReferences;
  }

  Future<List<DocumentReference>> getDocRefHotels(
      int maxBudget, String choice, int days, int rooms) async {
    if (choice == 'Travel Place') {
      var newmaxBudget = ((maxBudget * 30 / 100) / rooms) / (days - 1);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Place")
          .where('typePlace', isEqualTo: 'Hotel')
          .where('price', isLessThanOrEqualTo: newmaxBudget)
          .get();
      List<QueryDocumentSnapshot> documentSnapshots = querySnapshot.docs;
      List<DocumentReference> documentReferences =
          documentSnapshots.map((doc) => doc.reference).toList();
      return documentReferences;
    } else {
      var newmaxBudget = ((maxBudget * 70 / 100) / rooms) / (days - 1);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("Place")
          .where('typePlace', isEqualTo: 'Hotel')
          .where('price', isLessThanOrEqualTo: newmaxBudget)
          .get();
      List<QueryDocumentSnapshot> documentSnapshots = querySnapshot.docs;
      List<DocumentReference> documentReferences =
          documentSnapshots.map((doc) => doc.reference).toList();
      return documentReferences;
    }
  }

  getQueriesResult(
    String params,
    int days,
  ) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          child: Text(
            params,
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Place")
              .where('typePlace', isEqualTo: params)
              .limit(days)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;

                    return Citycardmenu(
                      imagename: data['image'],
                      cityname: data['name'],
                      callback: (context) {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: ((context) => PlaceDetails(
                        //         image: data['image'],
                        //         name: data['name'],
                        //         numTel: data['numTel'],
                        //         address: data['address'],
                        //         timeOpenClose: data['timeOpenClose'],
                        //         website: data['website'],
                        //         price: data['price'])),
                        //   ),
                        // );
                      },
                    );
                  }).toList());
            }
          },
        )
      ],
    );
  }

  getHotels(int maxBudget, String choice, int days, int rooms) {
    print('choice : ${choice}');
    if (choice == 'Travel Place') {
      var newmaxBudget = ((maxBudget * 30 / 100) / rooms) / (days - 1);
      print('travel place = ${newmaxBudget}');
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            child: const Text(
              'Hotels',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Place")
                .where('typePlace', isEqualTo: 'Hotel')
                .where('price', isLessThanOrEqualTo: newmaxBudget)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Citycardmenu(
                        imagename: data['image'],
                        cityname: data['name'],
                        callback: (context) {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: ((context) => PlaceDetails(
                          //         image: data['image'],
                          //         name: data['name'],
                          //         numTel: data['numTel'],
                          //         address: data['address'],
                          //         timeOpenClose: data['timeOpenClose'],
                          //         website: data['website'],
                          //         price: data['price'])),
                          //   ),
                          // );
                        },
                      );
                    }).toList());
              } else {
                return const Text('');
              }
            },
          ),
        ],
      );
    } else {
      var newmaxBudget = ((maxBudget * 70 / 100) / rooms) / (days - 1);
      print('ACCOMODATION : ${newmaxBudget}');
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10.0),
            child: const Text(
              'Hotels',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Place")
                .where('typePlace', isEqualTo: 'Hotel')
                .where('price', isLessThanOrEqualTo: newmaxBudget)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Citycardmenu(
                        imagename: data['image'],
                        cityname: data['name'],
                        callback: (context) {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: ((context) => PlaceDetails(
                          //         image: data['image'],
                          //         name: data['name'],
                          //         numTel: data['numTel'],
                          //         address: data['address'],
                          //         timeOpenClose: data['timeOpenClose'],
                          //         website: data['website'],
                          //         price: data['price'])),
                          //   ),
                          // );
                        },
                      );
                    }).toList());
              } else {
                return const Text('');
              }
            },
          ),
        ],
      );
    }
  }

  Future getPlaceNameList(List<String> placeList, String collectionName) async {
    var placeCollection =
        await FirebaseFirestore.instance.collection(collectionName).get();
    for (int i = 0; i < placeCollection.docs.length; i++) {
      placeList.add(placeCollection.docs[i]['name']);
    }
    print(placeList);
  }
}
