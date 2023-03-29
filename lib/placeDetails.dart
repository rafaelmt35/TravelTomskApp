import 'package:flutter/material.dart';
import 'package:travel_app/const.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final int price;

  @override
  State<PlaceDetails> createState() => _PlaceDetailsState();
}

class _PlaceDetailsState extends State<PlaceDetails> {
  @override
  Widget build(BuildContext context) {
    var numTeluri = Uri.parse("tel: ${widget.numTel}");
    var web = Uri.parse("https://${widget.website}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor: maincolor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 220.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                        image: NetworkImage(widget.image), fit: BoxFit.cover)),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Text(
                widget.address,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: widget.numTel == '' ? false : true,
                child: InkWell(
                  onTap: () {
                    launchUrl(numTeluri);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.call,
                        color: Colors.green,
                      ),
                      Text(
                        widget.numTel,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: widget.timeOpenClose == '' ? false : true,
                child: Text(
                  'Время: ${widget.timeOpenClose}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: widget.price == 0 ? false : true,
                child: Text(
                  'Цена: ${widget.price} ₽',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 15.0, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Visibility(
                visible: widget.website == ' ' ? false : true,
                child: InkWell(
                  onTap: () async {
                    launchUrl(web);
                  },
                  child: Text(
                    widget.website,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
