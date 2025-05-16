import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart'; // Assurez-vous du bon chemin d'importation
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/backend/page3/chauffeurlistpage.dart';

class EChauffeurs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestion des Chauffeurs"),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bouton "Voir les chauffeurs"
            _buildActionCard(
              context,
              "Voir les chauffeurs",
              "Consulter la liste des chauffeurs disponibles",
              Icons.people,
              Colors.blue,
              () {
                // Naviguer vers la page des chauffeurs
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChauffeurListPage()),
                );
              },
            ),
            SizedBox(height: 16),

            // Bouton "Attribuer un trajet"
            _buildActionCard(
              context,
              "Attribuer un trajet",
              "Assigner un trajet à un chauffeur",
              Icons.assignment,
              Colors.orange,
              () {
                // Action pour attribuer un trajet
              },
            ),
            SizedBox(height: 16),

            // Bouton "Suivi des chauffeurs"
            _buildActionCard(
              context,
              "Suivi des chauffeurs",
              "Suivre les activités des chauffeurs",
              Icons.assessment,
              Colors.green,
              () {
                // Action pour le suivi des chauffeurs
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
