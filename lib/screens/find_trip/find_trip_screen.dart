import 'dart:developer';

import 'package:car_pooling/screens/find_trip/search_results.dart';
import 'package:car_pooling/screens/home/post_options/post_ride/location_picker_screen.dart';
import 'package:car_pooling/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FindTripScreen extends StatefulWidget {
  const FindTripScreen({super.key});

  @override
  State<FindTripScreen> createState() => _FindTripScreenState();
}

class _FindTripScreenState extends State<FindTripScreen> {
  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController dateController = TextEditingController();

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
        title: const Text(
          "Find a trip",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF3D3D3D),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ListView(
          children: [
            CustomTextField(
              controller: originController,
              hint: "Origin",
              icon: const Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              onTapped: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LocationPickerScreen(
                    onExit: (location) {
                      log("LOCATION PICKED");
                      setState(() {
                        originController.text = location.address;
                      });
                    },
                  );
                }));
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.black,
                  ),
                  Icon(
                    Icons.arrow_downward_rounded,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            CustomTextField(
              controller: destinationController,
              hint: "Destination",
              icon: const Icon(
                Icons.location_on,
                color: Colors.black,
              ),
              onTapped: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LocationPickerScreen(
                    onExit: (location) {
                      log("LOCATION PICKED");
                      setState(() {
                        destinationController.text = location.address;
                      });
                    },
                  );
                }));
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 38),
              child: CustomTextField(
                controller: dateController,
                hint: "Departure date",
                icon: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.black,
                ),
                onTapped: () {
                  datePicker();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 38),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const SearchResultsScreen();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    "Search",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
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
}
