import 'dart:developer';

import 'package:car_pooling/models/trip_model.dart';
import 'package:car_pooling/models/vehicle_model.dart';
import 'package:car_pooling/services/trips/trips_service.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class PostRideScreen extends StatefulWidget {
  const PostRideScreen({super.key});

  @override
  State<PostRideScreen> createState() => _PostRideScreenState();
}

class _PostRideScreenState extends State<PostRideScreen> {
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController additionalStopsController = TextEditingController();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  TextEditingController priceController = TextEditingController();

  TextEditingController tripDescriptionController = TextEditingController();

  bool isSkipVehicle = false;
  bool isAcceptedTNC = false;

  String? selectedVehicle;
  List<String> vehicles = [];

  int noOfEmptySeats = 0;

  final GlobalKey<FormState> formKey = GlobalKey();

  Vehicle? chosenVehicle;

  void postTrip() async {
    if (formKey.currentState!.validate()) {
      //* post trip
      if (!isSkipVehicle && chosenVehicle == null) {
        Fluttertoast.showToast(msg: "Please fill the vehicle details");
      } else {
        if (isAcceptedTNC) {
          String userId = FirebaseAuth.instance.currentUser!.uid;

          TripModel trip = TripModel(
            userId: userId,
            origin: originController.text,
            destination: destinationController.text,
            stops: additionalStopsController.text,
            departureDate: dateController.text,
            departureTime: timeController.text,
            vehicle: chosenVehicle,
            emptySeats: "$noOfEmptySeats",
            price: priceController.text,
            tripType: "Request to book",
            tripDescription: tripDescriptionController.text,
          );

          log("TRIP MODEL : ${trip.toJson()}");

          await TripsService().postTrip(trip: trip);
        } else {
          Fluttertoast.showToast(
            msg:
                "Please accept the terms and conditions along with the privacy policy",
          );
        }
      }
    } else {
      //* throw error
    }
  }

  void getVehicles() async {
    List temp = await TripsService().getTripVehicles();

    for (var ele in temp) {
      setState(() {
        vehicles.add(ele['model']);
      });
    }
    log("$vehicles");
  }

  @override
  void initState() {
    super.initState();

    getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 36,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Post a trip",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Text(
                "Itinerary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Your origin, destination and the stops you're willing to make along with way.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF858585),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Text(
                "Origin",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            textField(
              originController,
              "Enter an origin",
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Text(
                "Destination",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            textField(
              destinationController,
              "Enter a destination",
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Text(
                "Stops",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DottedBorder(
                strokeWidth: 1.5,
                dashPattern: const [4, 6],
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                color: Colors.black.withOpacity(0.3),
                child: textField(
                  additionalStopsController,
                  "Add a stop to get more bookings",
                  isAdditionalStop: true,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Ride Schedule",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Enter precise date and time with AM or PM.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF858585),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Text(
                "Leaving",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GestureDetector(
                onTap: () {
                  datePicker();
                },
                child: TextFormField(
                  controller: dateController,
                  enabled: false,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFECECEC),
                    prefixIcon: const Icon(
                      Icons.event_rounded,
                      color: Colors.black,
                    ),
                    hintText: "Pick departure date",
                    hintStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF858585),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill the required field';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Text(
                "at",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        timePicker();
                      },
                      child: TextFormField(
                        controller: timeController,
                        enabled: false,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFECECEC),
                          prefixIcon: const Icon(
                            Icons.access_time_rounded,
                            color: Colors.black,
                          ),
                          hintText: "Time",
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF858585),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill the required field';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Add return trip",
                      style: TextStyle(
                        color: Colors.black,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Vehicle Details",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "This helps you get more bookings and makes it easier for passengers to identify the vehicle.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF858585),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Checkbox(
                    value: isSkipVehicle,
                    onChanged: (value) {
                      setState(() {
                        isSkipVehicle = value!;
                      });
                    },
                    activeColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const Text(
                    "Skip vehicle",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF858585),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Text(
                "Select vehicle",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButtonFormField(
                value: selectedVehicle,
                items: vehicles.map<DropdownMenuItem<String>>((String ele) {
                  return DropdownMenuItem<String>(
                    value: ele,
                    child: Text(
                      ele,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFECECEC),
                  hintText: "Select a vehicle",
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF858585),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                ),
                borderRadius: BorderRadius.circular(10),
                onChanged: (value) {
                  setState(() {
                    selectedVehicle = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Add vehicle",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Empty Seats",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Kindly put maximum of two person per seats to ensure everyone's comfort.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF858585),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Text(
                "Select number of seats",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SizedBox(
                height: 40,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            noOfEmptySeats = index + 1;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: noOfEmptySeats == index + 1
                              ? Colors.black
                              : const Color(0xFFd9d9d9),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: noOfEmptySeats == index + 1
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Pricing",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Enter a fair price per seat to cover your fuel and other maintenance expenses. Note all prices are in INR",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF858585),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Price per seat",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5c5c5c),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: TextFormField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFECECEC),
                          hintText: "Price in INR",
                          hintStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Color(0xFF858585),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill the required field';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Booking Preference",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Select your preference : review each booking request manually or accept all booking instantly.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF858585),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Text(
                "Select type",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: index != 0
                            ? const Color(0xFFECECEC)
                            : Colors.transparent,
                        border: index == 0
                            ? Border.all(
                                color: Colors.black,
                                width: 1.5,
                              )
                            : null,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              index == 0
                                  ? "assets/icons/wallet.png"
                                  : "assets/icons/flash.png",
                              height: 30,
                              width: 30,
                            ),
                            Text(
                              index == 0 ? "Request to book" : "Instant book",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              index == 0
                                  ? "You approve or reject passengers manually"
                                  : "Drive at least 5 passengers to enable instant book.",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF858585),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Trip Description",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Add any details relevant to your trips.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF858585),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: TextFormField(
                controller: tripDescriptionController,
                maxLines: 6,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFECECEC),
                  hintText: "Any description about the trip",
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF858585),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please fill the required field';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Checkbox(
                    value: isAcceptedTNC,
                    onChanged: (value) {
                      setState(() {
                        isAcceptedTNC = value!;
                      });
                    },
                    activeColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "I agree to these rules, to the driver cancellation Policy, Terms of Service and the privacy policy, and",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF858585),
                          ),
                        ),
                        Text(
                          "I understand that my account could be suspended if i break the rules.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30),
              child: ElevatedButton(
                onPressed: () {
                  postTrip();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Post Trip",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget textField(
    TextEditingController controller,
    String hint, {
    bool? isAdditionalStop = false,
  }) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: isAdditionalStop == true ? 0 : 30),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor:
              isAdditionalStop == true ? Colors.white : const Color(0xFFECECEC),
          prefixIcon: isAdditionalStop == true
              ? null
              : const Icon(
                  Icons.location_on,
                  color: Colors.black,
                ),
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Color(0xFF858585),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please fill the required field';
          }
          return null;
        },
      ),
    );
  }

  void datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((value) {
      String selectedDate = DateFormat('d MMMM yyyy').format(value!);
      setState(() {
        dateController.text = selectedDate;
      });
    });
  }

  void timePicker() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      String selectedTime = value!.format(context);

      setState(() {
        timeController.text = selectedTime;
      });
    });
  }
}
