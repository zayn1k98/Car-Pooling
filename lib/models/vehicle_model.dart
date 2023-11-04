class Vehicle {
  String? vehicleImage;
  String? userId;
  String? model;
  String? type;
  String? color;
  String? year;
  String? licensePlate;
  String? luggageSize;
  String? seatingCapacity;
  bool? isWinterTyres;
  bool? isSnowboards;
  bool? isBikes;
  bool? isPets;

  Vehicle({
    this.vehicleImage,
    this.userId,
    this.model,
    this.type,
    this.color,
    this.year,
    this.licensePlate,
    this.luggageSize,
    this.seatingCapacity,
    this.isWinterTyres,
    this.isSnowboards,
    this.isBikes,
    this.isPets,
  });

  toJson() {
    return {
      "vehicleImage": vehicleImage,
      "userId": userId,
      "model": model,
      "type": type,
      "color": color,
      "year": year,
      "licensePlate": licensePlate,
      "luggageSize": luggageSize,
      "seatingCapacity": seatingCapacity,
      "isWinterTyres": isWinterTyres,
      "isSnownboards": isSnowboards,
      "isBikes": isBikes,
      "isPets": isPets,
    };
  }
}
