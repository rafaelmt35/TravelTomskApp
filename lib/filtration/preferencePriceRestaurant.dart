import 'package:flutter/material.dart';
import 'package:travel_app/filtration/placesToVisit.dart';
import 'package:travel_app/filtration/setMaxBudget.dart';

import '../const.dart';
import '../widgets/custom_widgets.dart';

class PreferenceRestaurantPrice extends StatefulWidget {
  const PreferenceRestaurantPrice(
      {super.key,
      required this.days,
      required this.person,
      required this.signInWithoutGoogle,
      required this.selectedplaces,
      required this.rooms,
      required this.hotelBudget});
  final int days;
  final bool signInWithoutGoogle;
  final int rooms;
  final int hotelBudget;
  final int person;
  final List<String> selectedplaces;

  @override
  State<PreferenceRestaurantPrice> createState() =>
      _PreferenceRestaurantPriceState();
}

enum Choose { notexpensive, moderate, expensive, veryexpensive }

class _PreferenceRestaurantPriceState extends State<PreferenceRestaurantPrice> {
  TextEditingController controllersearch = TextEditingController();

  late bool newvalue;

  Choose? _choose;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Установите диапазон цен для ресторана:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Недорогой'),
                    leading: Radio<Choose>(
                      value: Choose.notexpensive,
                      groupValue: _choose,
                      onChanged: (Choose? value) {
                        setState(() {
                          _choose = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Умеренный'),
                    leading: Radio<Choose>(
                      value: Choose.moderate,
                      groupValue: _choose,
                      onChanged: (Choose? value) {
                        setState(() {
                          _choose = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Дорогой'),
                    leading: Radio<Choose>(
                      value: Choose.expensive,
                      groupValue: _choose,
                      onChanged: (Choose? value) {
                        setState(() {
                          _choose = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Очень дорого'),
                    leading: Radio<Choose>(
                      value: Choose.veryexpensive,
                      groupValue: _choose,
                      onChanged: (Choose? value) {
                        setState(() {
                          _choose = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 85,
              ),
              Center(
                  child: ButtonGo(
                      callback: (context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => SetMaxBudget(
                                      choiceFoodRate: _choose!.toString(),
                                      signInWithoutGoogle:
                                          widget.signInWithoutGoogle,
                                      days: widget.days,
                                      rooms: widget.rooms,
                                      selectedplaces: widget.selectedplaces,
                                      person: widget.person,
                                      hotelBudget: widget.hotelBudget,
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
