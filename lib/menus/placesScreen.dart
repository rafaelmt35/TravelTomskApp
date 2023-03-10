import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/const.dart';
import 'package:travel_app/databaseservices.dart';
import 'package:travel_app/placeDetails.dart';
import 'package:travel_app/widgets/custom_widgets.dart';

class TypePlaceScreen extends StatefulWidget {
  const TypePlaceScreen({Key? key, required this.typePlace}) : super(key: key);
  final String typePlace;

  @override
  State<TypePlaceScreen> createState() => _TypePlaceScreenState();
}

class _TypePlaceScreenState extends State<TypePlaceScreen> {
  bool isLoaded = true;
  int length = 0;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference placeCollectionReference =
        firestore.collection('Place');

    @override
    void initState() {
      super.initState();
    }

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
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios_new),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            widget.typePlace,
                            style: TextStyle(
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
            child: SizedBox(
                child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Place')
                  .where('typePlace', isEqualTo: widget.typePlace)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.count(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    children: snapshot.data!.docs
                        .map((e) => Citycardmenu(
                              imagename: (e.data() as dynamic)['image'],
                              cityname: (e.data() as dynamic)['name'],
                              callback: (context) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: ((context) => PlaceDetails(
                                            image:
                                                (e.data() as dynamic)['image'],
                                            name: (e.data() as dynamic)['name'],
                                            numTel:
                                                (e.data() as dynamic)['numTel'],
                                            address: (e.data()
                                                as dynamic)['address'],
                                            timeOpenClose: (e.data()
                                                as dynamic)['timeOpenClose'],
                                            website: (e.data()
                                                as dynamic)['website'],
                                            price: (e.data()
                                                as dynamic)['price']))));
                              },
                            ))
                        .toList(),
                  );
                } else {
                  return Text('Loading');
                }
              },
            )
                //   ],
                // ),
                ),
          ),
        ),
      ),
    );
  }
}
