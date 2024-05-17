import 'package:flutter/material.dart';
import 'package:travel_app/filtration/getBudgetHotel.dart';

import 'package:travel_app/const.dart';
import 'package:travel_app/widgets/custom_widgets.dart';

class CountDays extends StatefulWidget {
  const CountDays({Key? key, required this.signInWithoutGoogle})
      : super(key: key);
  final bool signInWithoutGoogle;
  @override
  State<CountDays> createState() => _CountDaysState();
}

class _CountDaysState extends State<CountDays> {
  TextEditingController controllerInput = TextEditingController();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
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
                    'Сколько дней вы хотите путешествовать в Томске?',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  Visibility(
                    visible: isVisible,
                    child: const Text(
                      '*Поле не заполнено',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                      child: ButtonGo(
                          callback: (context) {
                            controllerInput.text.isEmpty
                                ? setState(() {
                                    isVisible = true;
                                  })
                                : setState(() {
                                    isVisible = false;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                setBudgetHotel(
                                                  signInWithoutGoogle: widget
                                                      .signInWithoutGoogle,
                                                  days: controllerInput.text ==
                                                          ''
                                                      ? 0
                                                      : int.parse(
                                                          controllerInput.text),
                                                ))));
                                  });
                          },
                          command: 'СЛЕДУЮЩИЙ'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
