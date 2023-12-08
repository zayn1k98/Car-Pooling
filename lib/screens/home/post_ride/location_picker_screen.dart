import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng location = const LatLng(12.963400, 77.586790);

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(12.963400, 77.586790),
    zoom: 12,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: cameraPosition,
        markers: {
          Marker(
            markerId: const MarkerId('Location'),
            position: location,
          ),
        },
        zoomControlsEnabled: true,
        scrollGesturesEnabled: true,
        onCameraMove: (cameraPosition) {
          print("CAMERA MOVED");
          this.cameraPosition = cameraPosition;
        },
      ),
    );
  }
}
