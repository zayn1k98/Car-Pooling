import 'package:car_pooling/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';

class MapWidget extends StatefulWidget {
  final LatLng originCoordinates;
  final LatLng destinationCoordinates;
  const MapWidget({
    required this.originCoordinates,
    required this.destinationCoordinates,
    super.key,
  });

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapPolyline googleMapPolyline =
      GoogleMapPolyline(apiKey: Constants.googleMapAPIKey);

  final List<Polyline> polyline = [];
  List<LatLng>? routes = [];

  void computePath() async {
    LatLng origin = widget.originCoordinates;
    LatLng destination = widget.destinationCoordinates;

    routes = await googleMapPolyline.getCoordinatesWithLocation(
      origin: origin,
      destination: destination,
      mode: RouteMode.driving,
    );

    print("ROUTE COORDINATES : $routes");

    setState(() {
      polyline.add(
        Polyline(
          polylineId: const PolylineId('polyline'),
          visible: true,
          color: Colors.blue,
          points: routes ?? [],
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      );
    });

    print("POLYLINES = $polyline");
  }

  @override
  void initState() {
    super.initState();

    computePath();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(
        target: widget.originCoordinates,
        zoom: 12,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('Origin'),
          position: widget.originCoordinates,
        ),
        Marker(
          markerId: const MarkerId('Destination'),
          position: widget.destinationCoordinates,
        ),
      },
      polylines: Set.from(polyline),
      zoomControlsEnabled: true,
      scrollGesturesEnabled: true,
    );
  }
}
