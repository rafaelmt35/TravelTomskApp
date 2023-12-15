import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/const.dart';
import 'package:travel_app/widgets/custom_widgets.dart';

class TripPage extends StatefulWidget {
  const TripPage(
      {super.key,
      required this.choice,
      required this.name,
      required this.days,
      required this.rooms,
      required this.totalCost,
      required this.places});
  final String name;
  final int totalCost;
  final List<dynamic> places;
  final int days;
  final int rooms;
  final String choice;
  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  var newBudget;
  var budgetForHotel;
  var hargahotel;
  var remainderBudget;
  @override
  void initState() {
    if (widget.choice == 'Travel Place') {
      var hotelbudget = (widget.totalCost * 30 / 100);
      var hargahotelpermalam = hotelbudget / (widget.days - 1);
      var hargahotelperkamar = hargahotelpermalam / widget.rooms;

      remainderBudget = widget.totalCost - hotelbudget;
      budgetForHotel = hotelbudget;
      hargahotel = hargahotelperkamar;
    } else {
      var hotelbudget = (widget.totalCost * 70 / 100);
      var hargahotelpermalam = hotelbudget / (widget.days - 1);
      var hargahotelperkamar = hargahotelpermalam / widget.rooms;

      remainderBudget = widget.totalCost - hotelbudget;
      budgetForHotel = hotelbudget;
      hargahotel = hargahotelperkamar;
    }
    print('budget hotel = ${budgetForHotel}');
    print('Harga hotel/ kamar  = ${hargahotel}');
    print('sisabudget = ${remainderBudget}');

    print(widget.places);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: maincolor,
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Бюджет : ${widget.totalCost} ₽',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'День : ${widget.days}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Предпочитания : ${widget.choice}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Нужны номеров/комнат : ${widget.rooms}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Расчет',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Бюджет отеля : $budgetForHotel ₽',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Цена отеля /день : $hargahotel ₽',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Остальный бюджет : $remainderBudget ₽',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.places.length,
                itemBuilder: (context, index) {
                  DocumentReference reference = widget.places[index];
                  return StreamBuilder<DocumentSnapshot>(
                    stream: reference.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.exists) {
                        Map<String, dynamic>? data =
                            snapshot.data!.data()! as Map<String, dynamic>?;
                        return Citycardmenu(
                          imagename: data?['image'],
                          cityname: data?['name'],
                          callback: (context) {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: ((context) => PlaceDetails(
                            //         image: data?['image'],
                            //         name: data?['name'],
                            //         numTel: data?['numTel'],
                            //         address: data?['address'],
                            //         timeOpenClose: data?['timeOpenClose'],
                            //         website: data?['website'],
                            //         price: data?['price'])),
                            //   ),
                            // );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return const Text(
                            'Error retrieving referenced document');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
