import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 15), // Petit espace en haut (juste de l'air)

            // Section des actions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildActionCard(
                    context,
                    "Modifier le profil",
                    "Mettre à jour vos informations personnelles",
                    Icons.edit,
                    Colors.blue,
                    () {},
                  ),
                  SizedBox(height: 16),
                  _buildActionCard(
                    context,
                    "Ajouter un paiement",
                    "Ajouter ou modifier vos méthodes de paiement",
                    Icons.credit_card,
                    Colors.orange,
                    () {},
                  ),
                  SizedBox(height: 16),
                  _buildActionCard(
                    context,
                    "Historique",
                    "Consulter l'historique de vos commandes",
                    Icons.history,
                    Colors.green,
                    () {},
                  ),
                  SizedBox(height: 40),

                  // Bouton Logout PREMIUM
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      gradient: LinearGradient(
                        colors: [
                          Colors.redAccent.shade100,
                          Colors.redAccent.shade700,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.3),
                          offset: Offset(0, 5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Logique de déconnexion
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      icon: Icon(Icons.exit_to_app,
                          color: Colors.white, size: 28),
                      label: Text(
                        "LOGOUT",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour créer les cartes d'action
  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: tDarkColor,
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
              Icon(Icons.chevron_right, size: 32, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
