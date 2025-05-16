import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/transporteur/widgets/t_accueil.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/transporteur/widgets/t_disponibilite.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/transporteur/widgets/t_profil.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/transporteur/widgets/t_support.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/transporteur/widgets/t_tableaudebord.dart';

class TransporteurScreen extends StatefulWidget {
  @override
  _TransporteurScreenState createState() => _TransporteurScreenState();
}

class _TransporteurScreenState extends State<TransporteurScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    TAccueil(),
    TTableauDeBord(),
    TDisponibilite(),
    TSupport(),
    TProfil(),
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
              icon: Icon(Icons.bar_chart), label: 'Tableau de bord'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle), label: 'Disponibilité'),
          BottomNavigationBarItem(icon: Icon(Icons.support), label: 'Support'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}
