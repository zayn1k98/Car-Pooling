import 'package:car_pooling/models/vehicle_model.dart';

class TripModel {
  String? userId;
  String? origin;
  String? destination;
  String? stops;
  String? departureDate;
  String? departureTime;
  Vehicle? vehicle;
  DriverDetails? driverDetails;
  String? emptySeats;
  String? price;
  String? tripType;
  String? tripDescription;
  String? status;

  TripModel({
    this.userId,
    this.origin,
    this.destination,
    this.stops,
    this.departureDate,
    this.departureTime,
    this.vehicle,
    this.driverDetails,
    this.emptySeats,
    this.price,
    this.tripType,
    this.tripDescription,
    this.status,
  });

  toJson() {
    return {
      "userId": userId,
      "origin": origin,
      "destination": destination,
      "stops": stops,
      "departureDate": departureDate,
      "departureTime": departureTime,
      "vehicle": vehicle == null ? "no vehicle chosen" : vehicle!.toJson(),
      "driverDetails": driverDetails!.toJson(),
      "emptySeats": emptySeats,
      "price": price,
      "tripType": tripType,
      "tripDescription": tripDescription,
      "status": status,
    };
  }
}

class DriverDetails {
  String? driverName;
  String? driverImage;
  bool? isVerified;
  String? pushToken;
  String? rating;

  DriverDetails({
    this.driverName,
    this.driverImage,
    this.isVerified,
    this.pushToken,
    this.rating,
  });

  toJson() {
    return {
      "driverName": driverName,
      "driverImage": driverImage,
      "isVerified": isVerified,
      "pushToken": pushToken,
      "rating": rating,
    };
  }
}
