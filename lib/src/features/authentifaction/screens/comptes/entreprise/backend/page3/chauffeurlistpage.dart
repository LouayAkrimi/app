import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_chauffeur_page.dart';
import 'chauffeur.dart'; // Import de la classe Chauffeur
import 'package:flutter_application_m3awda/src/constants/colors.dart';

class ChauffeurListPage extends StatefulWidget {
  @override
  _ChauffeurListPageState createState() => _ChauffeurListPageState();
}

class _ChauffeurListPageState extends State<ChauffeurListPage> {
  List<Chauffeur> _chauffeurs = [];

  @override
  void initState() {
    super.initState();
    _loadChauffeurs();
  }

  // Fonction pour charger les chauffeurs depuis Firestore
  void _loadChauffeurs() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('chauffeurs')
          .get();

      setState(() {
        _chauffeurs = snapshot.docs.map((doc) {
          return Chauffeur(
            nom: doc['nom'],
            prenom: doc['prenom'],
            camion: doc['camion'],
            numeroPermis: doc['numeroPermis'],
            telephone: doc['telephone'],
            email: doc['email'],
            experience: doc['experience'],
            uid: doc.id, // Ajout de l'UID du chauffeur pour un usage ultérieur
          );
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des Chauffeurs"),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _chauffeurs.isEmpty
                  ? Center(
                      child: Text(
                        "Aucun chauffeur disponible",
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _chauffeurs.length,
                      itemBuilder: (context, index) {
                        final chauffeur = _chauffeurs[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              "${chauffeur.nom} ${chauffeur.prenom}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle:
                                Text("Camion assigné: ${chauffeur.camion}"),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                // Ajouter une fonctionnalité d'édition
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final newChauffeur = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddChauffeurPage()),
                  );
                  if (newChauffeur != null) {
                    setState(() {
                      _chauffeurs.add(
                          newChauffeur); // Ajouter le nouveau chauffeur à la liste
                    });
                  }
                },
                icon: Icon(Icons.person_add_alt_1, color: Colors.white),
                label: Text(
                  "Ajouter un chauffeur",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
