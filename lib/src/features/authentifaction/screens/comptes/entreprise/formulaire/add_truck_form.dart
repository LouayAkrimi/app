import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddTruckFormPage extends StatefulWidget {
  const AddTruckFormPage({Key? key}) : super(key: key);

  @override
  State<AddTruckFormPage> createState() => _AddTruckFormPageState();
}

class _AddTruckFormPageState extends State<AddTruckFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _truckModelController = TextEditingController();
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _truckTypeController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _insuranceNumberController =
      TextEditingController();
  final TextEditingController _manufactureYearController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Utilisateur non connecté");

      // Données du camion
      Map<String, dynamic> truckData = {
        'id': _plateNumberController.text.trim(),
        'uid': user.uid,
        'model': _truckModelController.text.trim(),
        'plateNumber': _plateNumberController.text.trim(),
        'capacity': _capacityController.text.trim(),
        'truckType': _truckTypeController.text.trim(),
        'color': _colorController.text.trim(),
        'insuranceNumber': _insuranceNumberController.text.trim(),
        'manufactureYear': _manufactureYearController.text.trim(),
        'status': 'Disponible',
        'position':
            GeoPoint(36.8065, 10.1815), // GeoPoint utilisé pour Firestore
        'estimatedTime': '0h',
        'distanceTraveled': '0 km',
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Enregistrement dans Firestore sous "trucks/{plateNumber}"
      await FirebaseFirestore.instance
          .collection('trucks')
          .doc(_plateNumberController.text.trim())
          .set(truckData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camion ajouté avec succès !')),
      );

      // Convertir GeoPoint en LatLng pour le retour
      Navigator.pop(context, {
        ...truckData,
        'position': LatLng(36.8065, 10.1815), // Conversion en LatLng
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations du camion'),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildInputField('Modèle du camion', _truckModelController),
              const SizedBox(height: 16),
              buildInputField(
                  'Numéro d\'immatriculation', _plateNumberController),
              const SizedBox(height: 16),
              buildInputField('Capacité (en tonnes)', _capacityController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 16),
              buildInputField('Type de camion', _truckTypeController),
              const SizedBox(height: 16),
              buildInputField('Couleur', _colorController),
              const SizedBox(height: 16),
              buildInputField(
                  'Numéro d\'assurance', _insuranceNumberController),
              const SizedBox(height: 16),
              buildInputField(
                  'Année de fabrication', _manufactureYearController,
                  keyboardType: TextInputType.number),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tPrimaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('AJOUTER DANS LE PARC',
                          style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration:
              InputDecoration(labelText: label, border: InputBorder.none),
          validator: (value) =>
              value == null || value.isEmpty ? 'Champ requis' : null,
        ),
      ),
    );
  }
}
