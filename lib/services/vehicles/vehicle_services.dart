import 'dart:developer';
import 'dart:io';
import 'package:car_pooling/models/vehicle_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VehicleServices {
  Future<void> addVehicle({
    required File vehicleImage,
    required Vehicle vehicle,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    QuerySnapshot existingVehicles = await firestore
        .collection('vehicles')
        .where('licensePlate', isEqualTo: vehicle.licensePlate)
        .get();

    if (existingVehicles.docs.isNotEmpty) {
      log("VEHICLE ALREADY EXISTS!!!");
    } else {
      final Reference imageReference =
          firebaseStorage.ref().child('vehicles/${DateTime.now()}.jpg');

      UploadTask uploadImage = imageReference.putFile(vehicleImage);
      TaskSnapshot taskSnapshot = await uploadImage;

      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      vehicle.vehicleImage = imageUrl;

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
