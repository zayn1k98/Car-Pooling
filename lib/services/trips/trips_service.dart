import 'dart:developer';
import 'package:car_pooling/models/trip_model.dart';
import 'package:car_pooling/models/vehicle_model.dart';
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

  Future<Vehicle> getVehicleDetails({
    required String licensePlate,
  }) async {
    Vehicle vehicle = Vehicle();

    QuerySnapshot vehicleDetails = await firestore
        .collection('vehicles')
        .where('licensePlate', isEqualTo: licensePlate)
        .get();

    if (vehicleDetails.docs.isNotEmpty) {
      Map<String, dynamic> data =
          vehicleDetails.docs.first.data() as Map<String, dynamic>;
      vehicle = Vehicle(
        vehicleImage: data['vehicleImage'],
        userId: data['userId'],
        model: data['model'],
        type: data['type'],
        color: data['color'],
        year: data['year'],
        licensePlate: data['licensePlate'],
        luggageSize: data['luggageSize'],
        seatingCapacity: data['seatingCapacity'],
        isWinterTyres: data['isWinterTyres'],
        isSnowboards: data['isSnowboards'],
        isBikes: data['isBikes'],
        isPets: data['isPets'],
      );
    } else {
      Fluttertoast.showToast(
        msg: "Error fetching vehicle details. Please try again later.",
      );
    }

    return vehicle;
  }

  Future<void> postTrip({required TripModel trip}) async {
    await firestore.collection('trips').add(trip.toJson()).then((value) {
      log("TRIP POSTED SUCCESSFULLY!!!");
    });
  }

  Future<List> getTrips() async {
    QuerySnapshot tripQuery = await firestore
        .collection('trips')
        .where('status', isEqualTo: 'active')
        .get();

    List trips = tripQuery.docs;

    log("ALL TRIPS : $trips");

    return trips;
  }
}
