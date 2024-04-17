// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:travel_app/filtration/preferencePriceRestaurant.dart';

import '../const.dart';
import '../widgets/custom_widgets.dart';

class placesToVisit extends StatefulWidget {
  const placesToVisit(
      {super.key,
      required this.days,
      required this.signInWithoutGoogle,
      required this.hotelBudget,
      required this.rooms,
      required this.person});
  final int days;
  final int hotelBudget;
  final bool signInWithoutGoogle;
  final int rooms;
  final int person;

  @override
  State<placesToVisit> createState() => _placesToVisitState();
}

enum Choose { travelplaces, accommodation }

class _placesToVisitState extends State<placesToVisit> {
  TextEditingController controllersearch = TextEditingController();
  bool museumValue = false;
  bool malLValue = false;
  bool kafeValue = false;
  bool parkValue = false;
  List<String> selectedplaces = [];
  bool isVisible = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: maincolor,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Какие места вы хотите посетить?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: <Widget>[
                  CheckboxListTile(
                    title: const Text("Музей"),
                    value: museumValue,
                    onChanged: (newValue) {
                      setState(() {
                        museumValue = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: const Text("ТЦ"),
                    value: malLValue,
                    onChanged: (newValue) {
                      setState(() {
                        malLValue = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: const Text("Парки"),
                    value: parkValue,
                    onChanged: (newValue) {
                      setState(() {
                        parkValue = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  CheckboxListTile(
                    title: const Text("Кафе"),
                    value: kafeValue,
                    onChanged: (newValue) {
                      setState(() {
                        kafeValue = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  )
                ],
              ),
              Visibility(
                visible: isVisible,
                child: const Text(
                  '*Поле не заполнено',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 85,
              ),
              Center(
                  child: ButtonGo(
                      callback: (context) {
                        if (museumValue == true) {
                          selectedplaces.add('Museum');
                        }
                        if (kafeValue == true) {
                          selectedplaces.add('Cafe');
                        }
                        if (malLValue == true) {
                          selectedplaces.add('Mall');
                        }
                        if (parkValue == true) {
                          selectedplaces.add('Park');
                        }
                        selectedplaces.isEmpty
                            ? setState(() {
                                isVisible = true;
                              })
                            : setState(() {
                                isVisible = false;
                              });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) =>
                                    PreferenceRestaurantPrice(
                                      hotelBudget: widget.hotelBudget,
                                      selectedplaces: selectedplaces,
                                      signInWithoutGoogle:
                                          widget.signInWithoutGoogle,
                                      days: widget.days,
                                      rooms: widget.rooms,
                                      person: widget.person,
                                    ))));
                      },
                      command: 'СЛЕДУЮЩИЙ'))
            ],
          ),
        ),
      ),
    );
  }
}
