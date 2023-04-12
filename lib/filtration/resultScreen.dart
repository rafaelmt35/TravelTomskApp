import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/filtration/function.dart';
import 'package:travel_app/homepage.dart';

import '../const.dart';
import '../placeDetails.dart';
import '../widgets/custom_widgets.dart';

class ResultFiltration extends StatefulWidget {
  const ResultFiltration(
      {super.key,
      required this.days,
      required this.choices,
      required this.maxBudget});
  final int days;
  final String choices;
  final int maxBudget;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                databaseservice.getQueriesResult(
                  'Museum',
                  widget.days,
                ),
                databaseservice.getQueriesResult(
                  'Park',
                  widget.days,
                ),
                databaseservice.getQueriesResult(
                  'Mall',
                  widget.days,
                ),
                databaseservice.getHotels(
                    widget.maxBudget, widget.choices, widget.days),
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
                                      builder: ((context) =>
                                          const HomePage())));
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
