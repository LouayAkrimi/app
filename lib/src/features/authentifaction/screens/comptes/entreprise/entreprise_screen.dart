import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart'; // Assurez-vous du bon chemin d'importation
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/widgets/e_Statistiques.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/widgets/e_accueil.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/widgets/e_camions.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/widgets/e_chauffeurs.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/widgets/e_support.dart';

class EntrepriseScreen extends StatefulWidget {
  @override
  _EntrepriseScreenState createState() => _EntrepriseScreenState();
}

class _EntrepriseScreenState extends State<EntrepriseScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    EAccueil(),
    ECamions(),
    EChauffeurs(),
    EStatistiques(),
    ESupport(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: tPrimaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping), label: 'Camions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions_car), label: 'Chauffeurs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart), label: 'Statistiques'),
          BottomNavigationBarItem(icon: Icon(Icons.support), label: 'Support'),
        ],
      ),
    );
  }
}
