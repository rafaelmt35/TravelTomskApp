import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/filtration/databaseServices.dart';
import 'package:travel_app/homepage.dart';

import '../const.dart';
import '../placeDetails.dart';
import '../widgets/custom_widgets.dart';

class ResultFiltration extends StatefulWidget {
  const ResultFiltration(
      {super.key,
      required this.signInWithoutGoogle,
      required this.days,
      required this.choices,
      required this.maxBudget,
      required this.rooms,
      required this.selectedplaces});
  final int days;
  final int rooms;
  final List<String> selectedplaces;
  final String choices;
  final int maxBudget;
  final bool signInWithoutGoogle;
  @override
  State<ResultFiltration> createState() => _ResultFiltrationState();
}

class _ResultFiltrationState extends State<ResultFiltration> {
  var listDocs;
  var databaseservice = DatabaseServices();
  var listDocRef;
  int priceMuseumTemp = 0;
  int priceparkTemp = 0;
  int priceMallTemp = 0;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> printDocumentReferences() async {
    for (var res1 in widget.selectedplaces) {
      List<DocumentReference<Object?>> documentReferences =
          await databaseservice.getDocRefPlaces(res1, widget.days);
      print(documentReferences);
      // listDocRef.add(await databaseservice.getDocRefPlaces(res1, widget.days));
    }

    List<DocumentReference<Object?>> docRefsHotel =
        await databaseservice.getDocRefHotels(
            widget.maxBudget, widget.choices, widget.days, widget.rooms);
    print(docRefsHotel);
    // listDocRef.add(await databaseservice.getDocRefHotels(
    //     widget.maxBudget, widget.choices, widget.days, widget.rooms));
  }

  @override
  void initState() {
    print(widget.choices);
    printDocumentReferences();
    print(listDocRef);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nametripsave = TextEditingController();
    int len = widget.selectedplaces.length;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Result'),
          backgroundColor: maincolor,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Budget : ${widget.maxBudget.toString()} ₽',
                  style: const TextStyle(
                      fontSize: 19.0, fontWeight: FontWeight.bold),
                ),
                for (var res in widget.selectedplaces)
                  databaseservice.getQueriesResult(res, widget.days),
                databaseservice.getHotels(widget.maxBudget, widget.choices,
                    widget.days, widget.rooms),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child: ButtonGo(
                            callback: (context) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Enter Name for saving trip'),
                                    content: TextFormField(
                                      controller: nametripsave,
                                      decoration: InputDecoration(
                                        hintText: 'Type something...',
                                      ),
                                    ),
                                    actions: [
                                      ButtonGo(
                                        callback: (context) {
                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                        command: 'Cancel',
                                      ),
                                      ButtonGo(
                                        callback: (context) {
                                          for (var res1
                                              in widget.selectedplaces) {
                                            listDocRef?.add(databaseservice
                                                    .getDocRefPlaces(
                                                        res1, widget.days)
                                                as DocumentReference<Object?>);
                                          }
                                          listDocRef?.add(databaseservice
                                                  .getDocRefHotels(
                                                      widget.maxBudget,
                                                      widget.choices,
                                                      widget.days,
                                                      widget.rooms)
                                              as DocumentReference<Object?>);
                                          String enteredText =
                                              nametripsave.text;
                                          Map<String, dynamic> data = {
                                            'name': enteredText,
                                            'totalCost': widget.maxBudget,
                                            'Places': listDocRef
                                          };
                                          firestore
                                              .collection('Trip')
                                              .add(data)
                                              .then((value) {
                                            print('Data added successfully!');
                                          }).catchError((error) {
                                            print('Error adding data: $error');
                                          });
                                          print('Entered text: $enteredText');

                                          Navigator.pop(
                                              context); // Close the dialog
                                        },
                                        command: 'Save',
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            command: 'SAVE')),
                    Center(
                        child: ButtonGo(
                            callback: (context) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => HomePage(
                                            signInWithoutGoogle:
                                                widget.signInWithoutGoogle,
                                          ))));
                            },
                            command: 'BACK TO HOME'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
