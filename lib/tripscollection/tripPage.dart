import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/const.dart';
import 'package:travel_app/widgets/custom_widgets.dart';

import '../placeDetails.dart';

class TripPage extends StatefulWidget {
  const TripPage(
      {super.key,
      required this.name,
      required this.totalCost,
      required this.places});
  final String name;
  final int totalCost;
  final List<dynamic> places;
  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  @override
  void initState() {
    print(widget.places);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: maincolor,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          physics: const ClampingScrollPhysics(),
          itemCount: widget.places.length,
          itemBuilder: (context, index) {
            DocumentReference reference = widget.places[index];
            return StreamBuilder<DocumentSnapshot>(
              stream: reference.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.exists) {
                  Map<String, dynamic>? data =
                      snapshot.data!.data()! as Map<String, dynamic>?;
                  return Citycardmenu(
                    imagename: data?['image'],
                    cityname: data?['name'],
                    callback: (context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => PlaceDetails(
                              image: data?['image'],
                              name: data?['name'],
                              numTel: data?['numTel'],
                              address: data?['address'],
                              timeOpenClose: data?['timeOpenClose'],
                              website: data?['website'],
                              price: data?['price'])),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return const Text('Error retrieving referenced document');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          },
        ),
      ),
    );
  }
}
