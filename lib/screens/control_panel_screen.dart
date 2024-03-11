import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class ControlPanelPage extends StatelessWidget {
  final List<LatLng> specificCoordinates = [
    LatLng(-3.0870, -60.0055),
    LatLng(-3.0974991343053784, -59.97653873538353),
    LatLng(-3.130959089581668, -60.013288458078044),
    LatLng(-3.0774773162121307, -59.930338426124834),
    LatLng(-3.096688825461525, -60.025621980782375),
    LatLng(-3.0383542663038434, -59.990288705534184),
    LatLng(-3.080645610265716, -60.01018371733513),
    LatLng(-3.103175861814809, -60.04659195549893),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(
                customIcon: Icons.arrow_back,
                customOnPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Painel de Análise da Mobilidade",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: MediaQuery.of(context).size.height / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: specificCoordinates.first,
                        zoom: 12.0, // Ajuste o valor do zoom aqui
                      ),
                      markers: _buildMarkers(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};

    for (int i = 0; i < specificCoordinates.length; i++) {
      LatLng coordinate = specificCoordinates[i];

      BitmapDescriptor? icon;

      switch (i % 4) {
        case 0:
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
          break;
        case 1:
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
          break;
        case 2:
          icon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
          break;
      }

      if (icon != null) {
        markers.add(
          Marker(
            markerId: MarkerId('marker_$i'),
            position: coordinate,
            icon: icon,
          ),
        );
      }
    }

    return markers;
  }
}
