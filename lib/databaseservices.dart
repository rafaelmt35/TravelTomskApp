import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
Future getPlaceNameList(List<String> placeList, String collectionName) async {
  var placeCollection =
      await FirebaseFirestore.instance.collection(collectionName).get();
  for (int i = 0; i < placeCollection.docs.length; i++) {
    placeList.add(placeCollection.docs[i]['name']);
  }
  print(placeList);
}
