import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart'; // Assurez-vous du bon chemin d'importation

class EStatistiques extends StatelessWidget {
  const EStatistiques({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistiques"),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bouton "Voir les statistiques"
            _buildActionCard(
              context,
              "Voir les statistiques",
              "Consulter les statistiques globales",
              Icons.bar_chart,
              Colors.blue,
              () {
                // Action pour voir les statistiques
              },
            ),
            SizedBox(height: 16),

            // Bouton "Performance par camion"
            _buildActionCard(
              context,
              "Performance par camion",
              "Analyser les performances par camion",
              Icons.directions_car,
              Colors.orange,
              () {
                // Action pour la performance par camion
              },
            ),
            SizedBox(height: 16),

            // Bouton "Performance par chauffeur"
            _buildActionCard(
              context,
              "Performance par chauffeur",
              "Analyser les performances par chauffeur",
              Icons.person,
              Colors.green,
              () {
                // Action pour la performance par chauffeur
              },
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour créer une carte d'action
  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icône
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              SizedBox(width: 16),

              // Titre et sous-titre
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              // Flèche indicatrice
              Icon(Icons.chevron_right, size: 32, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
