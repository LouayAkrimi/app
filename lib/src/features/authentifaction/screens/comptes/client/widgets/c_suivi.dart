import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';

class SuiviScreen extends StatelessWidget {
  const SuiviScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec image ou logo
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: tPrimaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_shipping, color: tPrimaryColor, size: 40),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Suivi de la commande",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: tDarkColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Statut: En cours",
                          style: TextStyle(
                            fontSize: 16,
                            color: tDarkColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Informations sur la commande
              _buildInfoCard(
                "Adresse de destination",
                "Rue Exemple, Tunis\nTransporteur: Ahmed | Véhicule: Camion",
                Icons.location_on,
                Colors.blue,
              ),
              SizedBox(height: 16),

              // Statut de la commande
              _buildInfoCard(
                "Statut de la commande",
                "En cours",
                Icons.info,
                Colors.orange,
              ),
              SizedBox(height: 20),

              // Indicateur de progression
              LinearProgressIndicator(
                value: 0.5, // Exemple de progression à 50%
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(tPrimaryColor),
              ),
              SizedBox(height: 20),

              // Boutons pour voir la carte et confirmer la réception
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    "Voir la carte",
                    Icons.map,
                    tPrimaryColor,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RealTimeMapScreen(),
                        ),
                      );
                    },
                  ),
                  _buildActionButton(
                    "Confirmer la réception",
                    Icons.check,
                    Colors.green,
                    () {
                      // Logique pour confirmer la réception
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Réception confirmée avec succès")),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Méthode pour créer une carte d'information
  Widget _buildInfoCard(
      String title, String subtitle, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 30, color: color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  // Méthode pour créer un bouton d'action
  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class RealTimeMapScreen extends StatelessWidget {
  const RealTimeMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(36.8065, 10.1815),
          zoom: 12,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: {
          Marker(
            markerId: MarkerId('currentLocation'),
            position: LatLng(36.8065, 10.1815),
            infoWindow: InfoWindow(title: "Localisation du colis"),
          ),
        },
      ),
    );
  }
}
