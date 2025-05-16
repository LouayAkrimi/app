import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chauffeur.dart'; // Import de la classe Chauffeur
import 'package:flutter_application_m3awda/src/constants/colors.dart';

class AddChauffeurPage extends StatefulWidget {
  @override
  _AddChauffeurPageState createState() => _AddChauffeurPageState();
}

class _AddChauffeurPageState extends State<AddChauffeurPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _numeroPermisController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  String? _selectedTruck;

  final List<String> _trucks = ['Camion A', 'Camion B', 'Camion C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un Chauffeur"),
        backgroundColor: tPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Champ Nom
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un nom' : null,
              ),
              SizedBox(height: 12),

              // Champ Prénom
              TextFormField(
                controller: _prenomController,
                decoration: InputDecoration(
                  labelText: 'Prénom',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Veuillez entrer un prénom' : null,
              ),
              SizedBox(height: 12),

              // Champ Numéro de permis
              TextFormField(
                controller: _numeroPermisController,
                decoration: InputDecoration(
                  labelText: 'Numéro de permis',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Veuillez entrer le numéro de permis'
                    : null,
              ),
              SizedBox(height: 12),

              // Champ Téléphone
              TextFormField(
                controller: _telephoneController,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Veuillez entrer un numéro de téléphone'
                    : null,
              ),
              SizedBox(height: 12),

              // Champ Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Veuillez entrer une adresse e-mail'
                    : null,
              ),
              SizedBox(height: 12),

              // Champ Expérience
              TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(
                  labelText: 'Expérience (années)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty
                    ? 'Veuillez entrer le nombre d\'années d\'expérience'
                    : null,
              ),
              SizedBox(height: 12),

              // Sélection du camion
              DropdownButtonFormField<String>(
                value: _selectedTruck,
                hint: Text("Sélectionner un camion"),
                items: _trucks
                    .map((truck) =>
                        DropdownMenuItem(value: truck, child: Text(truck)))
                    .toList(),
                onChanged: (value) => setState(() => _selectedTruck = value),
                validator: (value) =>
                    value == null ? 'Veuillez choisir un camion' : null,
              ),
              SizedBox(height: 24),

              // Bouton Enregistrer
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final chauffeur = Chauffeur(
                        nom: _nomController.text,
                        prenom: _prenomController.text,
                        camion: _selectedTruck!,
                        numeroPermis: _numeroPermisController.text,
                        telephone: _telephoneController.text,
                        email: _emailController.text,
                        experience: _experienceController.text,
                        uid: '',
                      );

                      // Récupérer l'utilisateur authentifié
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        // Ajouter le chauffeur dans Firestore
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid) // Récupérer l'ID utilisateur
                            .collection(
                                'chauffeurs') // Sous-collection 'chauffeurs'
                            .add({
                          'nom': chauffeur.nom,
                          'prenom': chauffeur.prenom,
                          'camion': chauffeur.camion,
                          'numeroPermis': chauffeur.numeroPermis,
                          'telephone': chauffeur.telephone,
                          'email': chauffeur.email,
                          'experience': chauffeur.experience,
                        });

                        // Retourner au précédent écran avec les données du chauffeur
                        Navigator.pop(context, chauffeur);
                      }
                    }
                  },
                  icon: Icon(Icons.save),
                  label: Text("Enregistrer le chauffeur"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
