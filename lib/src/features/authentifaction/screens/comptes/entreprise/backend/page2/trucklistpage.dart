import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';

class TruckListPage extends StatefulWidget {
  @override
  _TruckListPageState createState() => _TruckListPageState();
}

class _TruckListPageState extends State<TruckListPage> {
  List<Map<String, dynamic>> _trucks = [];

  @override
  void initState() {
    super.initState();
    _loadTrucks(); // Charger les camions au démarrage de la page
  }

  // Fonction pour charger les camions depuis Firestore
  void _loadTrucks() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('trucks').get();
    setState(() {
      _trucks = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': data['id'],
          'position':
              data['position'], // A ajuster selon votre modèle de données
          'status': data['status'],
          'estimatedTime': data['estimatedTime'],
          'distanceTraveled': data['distanceTraveled'],
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des Camions"),
        centerTitle: true,
        backgroundColor: tPrimaryColor, // Choisir la couleur appropriée
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _trucks.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _trucks.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    child: ListTile(
                      title: Text("Camion ${_trucks[index]['id']}"),
                      subtitle: Text("Statut: ${_trucks[index]['status']}"),
                      onTap: () {
                        // Action pour afficher les détails du camion, si nécessaire
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
