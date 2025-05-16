import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/transporteur/backend/page3/transporteur_disponible.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart'; // Ton fichier de couleurs

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? _pointA;
  LatLng? _pointB;
  double? _distance;

  LatLng _currentLocation = const LatLng(36.8065, 10.1815); // Tunis centre

  void _onMapCreated(GoogleMapController controller) {}

  double _calculateDistance(LatLng p1, LatLng p2) {
    const double R = 6371; // km
    double dLat = _degToRad(p2.latitude - p1.latitude);
    double dLon = _degToRad(p2.longitude - p1.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(p1.latitude)) *
            cos(_degToRad(p2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);

  void _onTap(LatLng tappedPoint) {
    setState(() {
      if (_pointA == null) {
        _pointA = tappedPoint;
        _markers.add(
          Marker(
            markerId: const MarkerId('Point A'),
            position: _pointA!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: "Point A"),
          ),
        );
      } else if (_pointB == null) {
        _pointB = tappedPoint;
        _markers.add(
          Marker(
            markerId: const MarkerId('Point B'),
            position: _pointB!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(title: "Point B"),
          ),
        );

        _polylines.add(
          Polyline(
            polylineId: const PolylineId('Route'),
            points: [_pointA!, _pointB!],
            width: 4,
            color: Colors.blue,
          ),
        );

        _distance = _calculateDistance(_pointA!, _pointB!);
      } else {
        // Reset points et markers
        _markers.clear();
        _polylines.clear();
        _pointA = tappedPoint;
        _pointB = null;
        _distance = null;

        _markers.add(
          Marker(
            markerId: const MarkerId('Point A'),
            position: _pointA!,
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: const InfoWindow(title: "Point A"),
          ),
        );
      }
    });
  }

  void _openTransporteursDisponiblesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransporteursDisponiblesPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pas d'AppBar
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 8,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onTap: _onTap,
            onMapCreated: _onMapCreated,
          ),
          if (_distance != null)
            Positioned(
              top: 40,
              left: 20,
              right: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  "Distance : ${_distance!.toStringAsFixed(2)} km",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _openTransporteursDisponiblesPage,
                icon: const Icon(Icons.search),
                label: const Text('Rechercher Transporteurs'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: tPrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
