import 'package:car_pooling/models/vehicle_model.dart';

class TripModel {
  String? userId;
  String? origin;
  String? destination;
  String? stops;
  String? departureDate;
  String? departureTime;
  Vehicle? vehicle;
  String? emptySeats;
  String? price;
  String? tripType;
  String? tripDescription;

  TripModel({
    this.userId,
    this.origin,
    this.destination,
    this.stops,
    this.departureDate,
    this.departureTime,
    this.vehicle,
    this.emptySeats,
    this.price,
    this.tripType,
    this.tripDescription,
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
      "emptySeats": emptySeats,
      "price": price,
      "tripType": tripType,
      "tripDescription": tripDescription,
    };
  }
}
