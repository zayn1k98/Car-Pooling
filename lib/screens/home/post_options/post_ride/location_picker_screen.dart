import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';

class LocationPickerScreen extends StatefulWidget {
  final Function(PickedData) onExit;
  const LocationPickerScreen({
    required this.onExit,
    super.key,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLocationPicker(
        initZoom: 11,
        minZoomLevel: 5,
        maxZoomLevel: 16,
        trackMyPosition: true,
        searchBarBackgroundColor: Colors.white,
        searchbarBorderRadius: BorderRadius.circular(60),
        searchbarInputBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        searchbarInputFocusBorderp: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        selectedLocationButtonTextstyle: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        mapLanguage: 'en',
        onError: (e) => log(e as String),
        selectLocationButtonText: "Select Location",
        showZoomController: false,
        locationButtonBackgroundColor: const Color(0xFFFF4E00),
        locationButtonsColor: Colors.white,
        selectLocationButtonStyle: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            const Color(0xFFFF4E00),
          ),
        ),
        markerIcon: Image.asset(
          'assets/icons/pin.png',
          height: 46,
        ),
        onPicked: (pickedData) {
          log(pickedData.latLong.latitude as String);
          log(pickedData.latLong.longitude as String);
          log(pickedData.address);
          log(pickedData.addressData as String);
          widget.onExit(pickedData);
          Navigator.pop(context);
        },
        onChanged: (pickedData) {
          log(pickedData.latLong.latitude as String);
          log(pickedData.latLong.longitude as String);
          log(pickedData.address);
          log(pickedData.addressData as String);
        },
        showContributorBadgeForOSM: true,
      ),
    );
  }
}
