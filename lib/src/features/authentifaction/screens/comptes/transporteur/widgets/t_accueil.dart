import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:http/http.dart' as http;

class TAccueil extends StatefulWidget {
  final LatLng? startLocation;
  final LatLng? endLocation;

  TAccueil({this.startLocation, this.endLocation});

  @override
  _TAccueilState createState() => _TAccueilState();
}

class _TAccueilState extends State<TAccueil> {
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng _defaultLocation = const LatLng(36.8065, 10.1815);
  GoogleMapController? _mapController;
  bool _isLoading = false;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    if (widget.startLocation != null && widget.endLocation != null) {
      _drawRoute(widget.startLocation!, widget.endLocation!);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _mapController = controller;
  }

  Future<void> _drawRoute(LatLng start, LatLng end) async {
    setState(() => _isLoading = true);

    try {
      final points = await _getDirections(start, end);

      if (!mounted) return;

      setState(() {
        _markers.clear();
        _polylines.clear();

        _markers.add(Marker(
          markerId: const MarkerId('start'),
          position: start,
          infoWindow: InfoWindow(
              title:
                  'Départ: ${start.latitude.toStringAsFixed(4)}, ${start.longitude.toStringAsFixed(4)}'),
        ));

        _markers.add(Marker(
          markerId: const MarkerId('end'),
          position: end,
          infoWindow: InfoWindow(
              title:
                  'Destination: ${end.latitude.toStringAsFixed(4)}, ${end.longitude.toStringAsFixed(4)}'),
        ));

        _polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: tPrimaryColor,
          width: 5,
        ));

        // Ajuster la caméra pour montrer tout le trajet
        _mapController?.animateCamera(
          CameraUpdate.newLatLngBounds(
            _boundsFromLatLngList([start, end]),
            100.0,
          ),
        );
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
    );
  }

  Future<List<LatLng>> _getDirections(LatLng start, LatLng end) async {
    const apiKey = 'AIzaSyDQEDmFtzqTfGi0LmHTwIvQ8WmNTmcUqUI'; // À remplacer
    final url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${start.latitude},${start.longitude}'
        '&destination=${end.latitude},${end.longitude}'
        '&key=$apiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['routes'] == null || data['routes'].isEmpty) {
        throw Exception('Aucun trajet trouvé entre ces points');
      }

      // Décodage de la polyligne
      final points = data['routes'][0]['overview_polyline']['points'];
      return _decodePoly(points);
    } else {
      throw Exception('Échec du chargement: ${response.statusCode}');
    }
  }

  List<LatLng> _decodePoly(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  Future<LatLng?> _getCoordinates(String address) async {
    if (address.isEmpty) return null;

    const apiKey = 'AIzaSyDQEDmFtzqTfGi0LmHTwIvQ8WmNTmcUqUI'; // À remplacer
    final encodedAddress = Uri.encodeComponent(address);
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      print(
          'Response: ${response.body}'); // Affiche la réponse de l'API pour débogage

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Vérifie si l'API renvoie des résultats
        if (data['results'] != null && data['results'].isNotEmpty) {
          final location = data['results'][0]['geometry']['location'];
          return LatLng(location['lat'], location['lng']);
        } else {
          // Erreur : aucune adresse trouvée
          throw Exception('Aucune adresse trouvée pour cette requête');
        }
      } else {
        // Gestion d'erreur pour les codes d'état HTTP autres que 200
        throw Exception(
            'Erreur API: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Gestion des exceptions liées à la requête HTTP
      throw Exception('Impossible de géocoder l\'adresse: $e');
    }
  }

  void _openSearchBottomSheet() {
    final departureController = TextEditingController();
    final destinationController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Rechercher un trajet",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: departureController,
                decoration: InputDecoration(
                  labelText: 'Lieu de départ',
                  border: OutlineInputBorder(),
                  hintText: 'Ex: Paris, France',
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: destinationController,
                decoration: InputDecoration(
                  labelText: 'Destination',
                  border: OutlineInputBorder(),
                  hintText: 'Ex: Lyon, France',
                  prefixIcon: Icon(Icons.flag),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final startAddress = departureController.text.trim();
                    final endAddress = destinationController.text.trim();

                    if (startAddress.isEmpty || endAddress.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez entrer des adresses valides'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    try {
                      final start = await _getCoordinates(startAddress);
                      final end = await _getCoordinates(endAddress);

                      if (start == null || end == null) {
                        throw Exception('Adresse invalide');
                      }

                      await _drawRoute(start, end);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erreur: ${e.toString()}'),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Rechercher le trajet",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trajets Disponibles',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.startLocation ?? _defaultLocation,
              zoom: 12,
            ),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _openSearchBottomSheet,
              backgroundColor: tPrimaryColor,
              child: const Icon(Icons.search, size: 28),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
