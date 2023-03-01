import 'package:flutter/material.dart';

import '../const.dart';

class ResultFiltration extends StatefulWidget {
  const ResultFiltration({super.key});

  @override
  State<ResultFiltration> createState() => _ResultFiltrationState();
}

class _ResultFiltrationState extends State<ResultFiltration> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: maincolor,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10.0),
        ),
      ),
    );
  }
}
