import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../placeDetails.dart';
import '../widgets/custom_widgets.dart';

class DatabaseServices {
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
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Place")
              .where('typePlace', isEqualTo: params)
              .limit(days)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => PlaceDetails(
                                image: data['image'],
                                name: data['name'],
                                numTel: data['numTel'],
                                address: data['address'],
                                timeOpenClose: data['timeOpenClose'],
                                website: data['website'],
                                price: data['price'])),
                          ),
                        );
                      },
                    );
                  }).toList());
            } else {
              return const Text('');
            }
          },
        )
      ],
    );
  }

  getHotels(int maxBudget, String choice, int days) {
    bool visible = false;
    if (choice == 'Travel Place') {
      var newmaxBudget = (maxBudget - (maxBudget * 70 / 100)) / days;
      print(newmaxBudget);

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

                      return Visibility(
                        visible:
                            newmaxBudget <= data["price"] ? visible : !visible,
                        child: Citycardmenu(
                          imagename: data['image'],
                          cityname: data['name'],
                          callback: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => PlaceDetails(
                                    image: data['image'],
                                    name: data['name'],
                                    numTel: data['numTel'],
                                    address: data['address'],
                                    timeOpenClose: data['timeOpenClose'],
                                    website: data['website'],
                                    price: data['price'])),
                              ),
                            );
                          },
                        ),
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
      var newmaxBudget = (maxBudget * 70 / 100) / days;
      print(newmaxBudget);
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
                      return Visibility(
                        visible:
                            newmaxBudget <= data["price"] ? visible : !visible,
                        child: Citycardmenu(
                          imagename: data['image'],
                          cityname: data['name'],
                          callback: (context) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: ((context) => PlaceDetails(
                                    image: data['image'],
                                    name: data['name'],
                                    numTel: data['numTel'],
                                    address: data['address'],
                                    timeOpenClose: data['timeOpenClose'],
                                    website: data['website'],
                                    price: data['price'])),
                              ),
                            );
                          },
                        ),
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
}
