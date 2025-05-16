import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/formulaire/add_truck_form.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EAccueil extends StatefulWidget {
  const EAccueil({Key? key}) : super(key: key);

  @override
  _EAccueilState createState() => _EAccueilState();
}

class _EAccueilState extends State<EAccueil> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  final LatLng _currentLocation = LatLng(36.8065, 10.1815);
  List<Map<String, dynamic>> _trucks = [];

  @override
  void initState() {
    super.initState();
    _loadTrucksFromFirestore();
  }

  void _loadTrucksFromFirestore() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('trucks').get();
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['position'] is GeoPoint) {
          final GeoPoint geo = data['position'];
          final LatLng latLng = LatLng(geo.latitude, geo.longitude);
          final truck = {
            'id': data['id'],
            'position': latLng,
            'status': data['status'],
            'estimatedTime': data['estimatedTime'],
            'distanceTraveled': data['distanceTraveled'],
          };
          if (mounted) {
            _addTruck(truck, saveToFirestore: false);
          }
        }
      }
    } catch (e) {
      print("Erreur lors du chargement des camions: $e");
    }
  }

  void _addTruck(Map<String, dynamic> truck,
      {bool saveToFirestore = true}) async {
    final dynamic pos = truck['position'];
    late LatLng latLng;

    if (pos is GeoPoint) {
      latLng = LatLng(pos.latitude, pos.longitude);
    } else if (pos is LatLng) {
      latLng = pos;
    } else {
      return;
    }

    final truckWithLatLng = {
      ...truck,
      'position': latLng,
    };

    if (mounted) {
      setState(() {
        _trucks.add(truckWithLatLng);
        _markers.add(
          Marker(
            markerId: MarkerId(truck['id']),
            position: latLng,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                _getMarkerHue(truck['status'])),
            infoWindow: InfoWindow(title: "Camion ${truck['id']}"),
          ),
        );
      });
    }

    if (saveToFirestore) {
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception("Utilisateur non connecté.");

        await FirebaseFirestore.instance.collection('trucks').add({
          'uid': user.uid,
          'id': truck['id'],
          'position': GeoPoint(latLng.latitude, latLng.longitude),
          'status': truck['status'],
          'estimatedTime': truck['estimatedTime'],
          'distanceTraveled': truck['distanceTraveled'],
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Camion ajouté avec succès")),
          );
        }
      } catch (e) {
        print("Erreur Firestore : $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur : ${e.toString()}")),
          );
        }
      }
    }
  }

  double _getMarkerHue(String status) {
    switch (status) {
      case 'Disponible':
        return BitmapDescriptor.hueGreen;
      case 'En livraison':
        return BitmapDescriptor.hueOrange;
      case 'En pause':
        return BitmapDescriptor.hueRed;
      default:
        return BitmapDescriptor.hueBlue;
    }
  }

  void _openFullScreenMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenMapScreen(
          markers: _markers,
          polylines: _polylines,
        ),
      ),
    );
  }

  void _openAddTruckForm() async {
    final newTruck = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => AddTruckFormPage()),
    );

    if (newTruck != null) {
      _addTruck(newTruck);
    }
  }

  void _refreshData() {
    if (mounted) {
      setState(() {
        _trucks.clear();
        _markers.clear();
        _loadTrucksFromFirestore();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tPrimaryColor,
        elevation: 10,
        centerTitle: true,
        title: const Text(
          "Tableau de Bord",
          style: TextStyle(
            color: tDarkColor,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMapSection(),
          SizedBox(height: 10),
          _buildActionButtons(),
          SizedBox(height: 10),
          Expanded(child: _buildTrucksSection()),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Card(
      elevation: 8,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 300,
          width: double.infinity,
          child: GoogleMap(
            initialCameraPosition:
                CameraPosition(target: _currentLocation, zoom: 12),
            markers: _markers,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton("Voir la carte", Icons.map, _openFullScreenMap),
          _buildActionButton("Ajouter Camion", Icons.add, _openAddTruckForm),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      label: Text(label, style: TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: tPrimaryColor,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildTrucksSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "Parc",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: _trucks.isEmpty
                ? Center(child: Text("Aucun camion dans le parc."))
                : ListView.builder(
                    itemCount: _trucks.length,
                    itemBuilder: (context, index) {
                      return _buildTruckCard(_trucks[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTruckCard(Map<String, dynamic> truck) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.local_shipping,
            size: 32, color: _getStatusColor(truck['status'])),
        title: Text("Camion ${truck['id']}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          "Statut: ${truck['status']}\nTemps estimé: ${truck['estimatedTime']}\nDistance: ${truck['distanceTraveled']}",
        ),
        onTap: () {},
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Disponible':
        return Colors.green;
      case 'En livraison':
        return Colors.orange;
      case 'En pause':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}

class FullScreenMapScreen extends StatelessWidget {
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  const FullScreenMapScreen({
    Key? key,
    required this.markers,
    required this.polylines,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Carte en plein écran", style: TextStyle(color: Colors.white)),
        backgroundColor: tPrimaryColor,
        elevation: 10,
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(36.8065, 10.1815),
          zoom: 12,
        ),
        markers: markers,
        polylines: polylines,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
