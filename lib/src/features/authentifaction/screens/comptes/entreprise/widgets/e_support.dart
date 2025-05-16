import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/backend/page5/chat_support_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/backend/page5/faq_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/backend/page5/report_problem_screen.dart';

class ESupport extends StatefulWidget {
  @override
  _ESupportState createState() => _ESupportState();
}

class _ESupportState extends State<ESupport>
    with SingleTickerProviderStateMixin {
  bool _isDrawerOpen = false;
  late AnimationController _animationController;
  late Animation<Offset> _drawerAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _drawerAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.10, 0.0),
    ).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      if (_isDrawerOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _closeDrawer() {
    setState(() {
      _isDrawerOpen = false;
      _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Support"),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: _toggleDrawer,
        ),
      ),
      body: Stack(
        children: [
          // Contenu principal
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildActionCard(
                  context,
                  "FAQ",
                  "Consulter les questions fréquemment posées",
                  Icons.help,
                  Colors.blue,
                  () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => FAQScreen()));
                  },
                ),
                SizedBox(height: 16),
                _buildActionCard(
                  context,
                  "Chat support",
                  "Contacter notre équipe de support en direct",
                  Icons.chat,
                  Colors.orange,
                  () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ChatSupportScreen()));
                  },
                ),
                SizedBox(height: 16),
                _buildActionCard(
                  context,
                  "Signaler un problème",
                  "Signaler un problème technique ou une suggestion",
                  Icons.report,
                  Colors.red,
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ReportProblemScreen()));
                  },
                ),
              ],
            ),
          ),

          // Zone semi-floutée
          if (_isDrawerOpen)
            GestureDetector(
              onTap: _closeDrawer,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

          // Drawer animé
          SlideTransition(
            position: _drawerAnimation,
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: screenWidth * 0.90,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(-5, 0),
                    ),
                  ],
                ),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop(); // Action de logout
                    },
                    icon: Icon(Icons.logout, size: 24),
                    label: Text("LOGOUT", style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRed,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Carte d'action
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
              Icon(Icons.chevron_right, size: 32, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
