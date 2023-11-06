import 'dart:developer';

import 'package:car_pooling/models/trip_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TripsService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List> getTripVehicles() async {
    String userID = firebaseAuth.currentUser!.uid;

    List vehicles = [];

    QuerySnapshot userVehicles = await firestore
        .collection('vehicles')
        .where('userId', isEqualTo: userID)
        .get();

    if (userVehicles.docs.isNotEmpty) {
      vehicles = userVehicles.docs;
    } else {
      Fluttertoast.showToast(msg: "Please add vehicles to proceed");
    }

    return vehicles;
  }

  Future<void> postTrip({required TripModel trip}) async {
    await firestore
        .collection('trips')
        .doc(trip.userId)
        .collection('posted_trips')
        .add(trip.toJson())
        .then((value) {
      log("TRIP POSTED SUCCESSFULLY!!!");
    });
  }
}
