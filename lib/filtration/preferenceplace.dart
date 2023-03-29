import 'package:flutter/material.dart';
import 'package:travel_app/filtration/setMaxBudget.dart';

import '../const.dart';
import '../widgets/custom_widgets.dart';

class PreferencePlace extends StatefulWidget {
  const PreferencePlace({super.key, required this.days});
  final int days;
  @override
  State<PreferencePlace> createState() => _PreferencePlaceState();
}

enum Choose { travelplaces, accommodation }

class _PreferencePlaceState extends State<PreferencePlace> {
  TextEditingController controllersearch = TextEditingController();
  bool valueA = false;
  bool valueB = false;
  late bool newvalue;

  Choose? _choose = Choose.travelplaces;
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
                'Что вы предпочитаете, больше мест для путешествий или хорошее жилье?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: <Widget>[
                  ListTile(
                    title: const Text('Больше мест для путешествий'),
                    leading: Radio<Choose>(
                      value: Choose.travelplaces,
                      groupValue: _choose,
                      onChanged: (Choose? value) {
                        setState(() {
                          _choose = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Хорошее жилье'),
                    leading: Radio<Choose>(
                      value: Choose.accommodation,
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
              // _choose == Choose.accommodation ? Text('test') : Text('test2'),
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
                                      choices: _choose == Choose.travelplaces
                                          ? 'Travel Place '
                                          : 'Accomodation',
                                      days: widget.days,
                                    ))));
                      },
                      command: 'NEXT PAGE'))
            ],
          ),
        ),
      ),
    );
  }
}
