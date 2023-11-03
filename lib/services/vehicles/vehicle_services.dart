import 'dart:developer';
import 'package:car_pooling/models/vehicle_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleServices {
  Future<void> addVehicle({
    required Vehicle vehicle,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    QuerySnapshot existingVehicles = await firestore
        .collection('vehicles')
        .where('licensePlate', isEqualTo: vehicle.licensePlate)
        .get();

    if (existingVehicles.docs.isNotEmpty) {
      log("VEHICLE ALREADY EXISTS!!!");
    } else {
      firestore
          .collection('vehicles')
          .doc(vehicle.licensePlate)
          .set(
            vehicle.toJson(),
          )
          .then((value) {
        log("${vehicle.licensePlate} ADDED SUCCESSFULLY!!!");
      });
    }
  }
}
