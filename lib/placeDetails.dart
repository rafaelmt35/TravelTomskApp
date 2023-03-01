import 'package:flutter/material.dart';

class PlaceDetails extends StatefulWidget {
  const PlaceDetails(
      {super.key,
      required this.image,
      required this.name,
      required this.numTel,
      required this.address,
      required this.timeOpenClose,
      required this.website,
      required this.price});
  final String image;
  final String name;
  final String numTel;
  final String address;
  final String timeOpenClose;
  final String website;
  final String price;

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
