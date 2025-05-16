import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart'; // Assurez-vous du bon chemin d'importation
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/client/widgets/c_accueil.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/client/widgets/c_paiment.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/client/widgets/c_profil.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/client/widgets/c_suivi.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/client/widgets/c_support.dart';

class ClientScreen extends StatefulWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  _ClientScreenState createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  int _selectedIndex = 0; // Index de l'élément sélectionné

  // Liste des écrans correspondants aux icônes
  final List<Widget> _screens = [
    HomeScreen(),
    const SuiviScreen(),
    const PaiementScreen(),
    const SupportScreen(),
    const ProfilScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex =
          index; // Mettre à jour l'écran affiché en fonction de l'index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Afficher l'écran sélectionné
      appBar: AppBar(
        title: const Text("Interface Client"),
        centerTitle: true,
        backgroundColor: tPrimaryColor, // Couleur primaire pour l'AppBar
        elevation: 0,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: tPrimaryColor, // Couleur de l'élément sélectionné
        unselectedItemColor:
            Colors.grey, // Couleur des éléments non sélectionnés
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping), label: 'Suivi'),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'Paiement'),
          BottomNavigationBarItem(icon: Icon(Icons.support), label: 'Support'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profil'),
        ],
      ),
    );
  }
}
