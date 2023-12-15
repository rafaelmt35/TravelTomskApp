import 'package:flutter/material.dart';
import 'package:travel_app/filtration/placesToVisit.dart';
import 'package:travel_app/const.dart';
import 'package:travel_app/filtration/setMaxBudget.dart';
import 'package:travel_app/widgets/custom_widgets.dart';

class CountPersonForRoom extends StatefulWidget {
  const CountPersonForRoom(
      {Key? key,
      required this.signInWithoutGoogle,
      required this.days,
      required this.hotelBudget})
      : super(key: key);
  final int days;
  final int hotelBudget;
  final bool signInWithoutGoogle;

  @override
  State<CountPersonForRoom> createState() => _CountPersonForRoomState();
}

class _CountPersonForRoomState extends State<CountPersonForRoom> {
  TextEditingController controllerInput = TextEditingController();

  @override
  void initState() {
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Сколько комнат/номер вам нужны?',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 18),
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        width: 350.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: controllerInput,
                          keyboardType: TextInputType.number,
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
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Center(
                        child: ButtonGo(
                            callback: (context) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => placesToVisit(
                                            signInWithoutGoogle:
                                                widget.signInWithoutGoogle,
                                            days: widget.days,
                                            hotelBudget: widget.hotelBudget,
                                            rooms:
                                                int.parse(controllerInput.text),
                                          ))));
                            },
                            command: 'NEXT PAGE'))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
