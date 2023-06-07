import 'package:flutter/material.dart';
import 'package:travel_app/filtration/setHowManyPersonforHotel.dart';
import 'package:travel_app/filtration/setMaxBudget.dart';

import '../const.dart';
import '../widgets/custom_widgets.dart';

class placesToVisit extends StatefulWidget {
  const placesToVisit({
    super.key,
    required this.days,
    required this.signInWithoutGoogle,
    required this.choices,
  });
  final int days;
  final bool signInWithoutGoogle;
  final String choices;
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

  @override
  void initState() {
    print(widget.choices);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
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
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => CountPersonForRoom(
                                        selectedplaces: selectedplaces,
                                        signInWithoutGoogle:
                                            widget.signInWithoutGoogle,
                                        choices: widget.choices,
                                        days: widget.days,
                                      ))));
                        },
                        command: 'NEXT PAGE'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
