import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart'; // Assurez-vous d'importer les bonnes couleurs

class MaintenancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion de Maintenance"),
        centerTitle: true,
        backgroundColor:
            tPrimaryColor, // Utiliser la même couleur que TruckListPage
        elevation: 4, // Ombre pour l'AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Carte pour ajouter un camion à la maintenance
            _buildMaintenanceCard(
              context,
              "Ajouter un camion à la maintenance",
              Colors.orange,
              () {
                // Logique pour ajouter un camion à la maintenance
              },
            ),
            SizedBox(height: 16), // Espacement entre les cartes

            // Carte pour voir les camions en maintenance
            _buildMaintenanceCard(
              context,
              "Voir les camions en maintenance",
              Colors.green,
              () {
                // Logique pour afficher les camions en maintenance
              },
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour créer une carte de maintenance avec un style professionnel
  Widget _buildMaintenanceCard(
    BuildContext context,
    String title,
    Color color,
    VoidCallback onPressed,
  ) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0), // Espacement vertical
      elevation: 8, // Plus d'ombre pour un effet plus raffiné
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Coins arrondis
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
            vertical: 12.0, horizontal: 16.0), // Amélioration du padding
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          size: 30,
          color: Colors.grey,
        ),
        onTap: onPressed,
      ),
    );
  }
}
