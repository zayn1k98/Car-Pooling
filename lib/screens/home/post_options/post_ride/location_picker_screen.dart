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
        selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
        mapLanguage: 'en',
        onError: (e) => print(e),
        selectLocationButtonLeadingIcon: const Icon(Icons.check),
        onPicked: (pickedData) {
          print(pickedData.latLong.latitude);
          print(pickedData.latLong.longitude);
          print(pickedData.address);
          print(pickedData.addressData);
          widget.onExit(pickedData);
          Navigator.pop(context);
        },
        onChanged: (pickedData) {
          print(pickedData.latLong.latitude);
          print(pickedData.latLong.longitude);
          print(pickedData.address);
          print(pickedData.addressData);
        },
        showContributorBadgeForOSM: true,
      ),
    );
  }
}
