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
  List<DocumentReference>? listDocRef;
  int priceMuseumTemp = 0;
  int priceparkTemp = 0;
  int priceMallTemp = 0;

  @override
  void initState() {
    print(widget.choices);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                
                Text(widget.choices),
                databaseservice.getHotels(widget.maxBudget, widget.choices,
                    widget.days, widget.rooms),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                        child:
                            ButtonGo(callback: (context) {}, command: 'SAVE')),
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
