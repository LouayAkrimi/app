import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/backend/page5/faq_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/backend/page5/chat_support_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/backend/page5/report_problem_screen.dart';

class TSupport extends StatelessWidget {
  const TSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Support"),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bouton "FAQ"
            _buildActionCard(
              context,
              "FAQ",
              "Consulter les questions fréquemment posées",
              Icons.help,
              Colors.blue,
              () {
                // Naviguer vers FAQScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQScreen()),
                );
              },
            ),
            SizedBox(height: 16),

            // Bouton "Chat support"
            _buildActionCard(
              context,
              "Chat support",
              "Contacter notre équipe de support en direct",
              Icons.chat,
              Colors.orange,
              () {
                // Naviguer vers ChatSupportScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatSupportScreen()),
                );
              },
            ),
            SizedBox(height: 16),

            // Bouton "Signaler un problème"
            _buildActionCard(
              context,
              "Signaler un problème",
              "Signaler un problème technique ou une suggestion",
              Icons.report,
              Colors.red,
              () {
                // Naviguer vers ReportProblemScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReportProblemScreen()),
                );
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
            ],
          ),
        ),
      ),
    );
  }
}
