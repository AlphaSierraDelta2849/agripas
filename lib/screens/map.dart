import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(48.8566, 2.3522), // Paris
          zoom: 8,
        ),
        markers: {
          Marker(
            markerId: MarkerId("ndvi"),
            position: LatLng(48.8566, 2.3522),
            infoWindow: InfoWindow(
              title: "NDVI : 0.75",
              snippet: "Sol sain, irrigation non nécessaire",
            ),
          ),
        },
      ),
    );
  }
}
