// ignore_for_file: camel_case_types, unused_import, file_names

import 'package:flutter/material.dart';
import 'package:travel_app/filtration/placesToVisit.dart';
import 'package:travel_app/filtration/setHowManyPersonforHotel.dart';

import '../const.dart';
import '../widgets/custom_widgets.dart';

class setBudgetHotel extends StatefulWidget {
  const setBudgetHotel(
      {super.key, required this.days, required this.signInWithoutGoogle});
  final int days;
  final bool signInWithoutGoogle;
  @override
  State<setBudgetHotel> createState() => _setBudgetHotelState();
}

class _setBudgetHotelState extends State<setBudgetHotel> {
  TextEditingController controllerBudget = TextEditingController();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
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
                'Установите максимальный бюджет для отеля',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 18),
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 100.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: controllerBudget,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 5,
                                  style: BorderStyle.solid),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          contentPadding: EdgeInsets.only(left: 10, top: 5),
                          hintStyle: TextStyle(fontStyle: FontStyle.italic),
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      '₽ /ночь',
                      style: TextStyle(
                          fontSize: 30.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
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
                        controllerBudget.text.isEmpty
                            ? setState(() {
                                isVisible = true;
                              })
                            : setState(() {
                                isVisible = false;
                              });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => CountPersonForRoom(
                                      days: widget.days,
                                      signInWithoutGoogle:
                                          widget.signInWithoutGoogle,
                                      hotelBudget:
                                          int.parse(controllerBudget.text),
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
