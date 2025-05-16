import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:get/get.dart';

class TruckFormPage extends StatefulWidget {
  final Function onFormSubmitted;

  const TruckFormPage({Key? key, required this.onFormSubmitted})
      : super(key: key);

  @override
  _TruckFormPageState createState() => _TruckFormPageState();
}

class _TruckFormPageState extends State<TruckFormPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations du camion'),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
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
                      : const Text('CRÉER COMPTE TRANSPORTEUR',
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
              value == null || value.isEmpty ? 'Champ obligatoire' : null,
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("Utilisateur non connecté.");

      final truckData = {
        'uid': user.uid,
        'model': _truckModelController.text.trim(),
        'plate_number': _plateNumberController.text.trim(),
        'capacity': _capacityController.text.trim(),
        'type': _truckTypeController.text.trim(),
        'color': _colorController.text.trim(),
        'insurance_number': _insuranceNumberController.text.trim(),
        'manufacture_year': _manufactureYearController.text.trim(),
        'created_at': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('trucks')
          .doc(user.uid)
          .set(truckData);

      Get.snackbar('Succès', 'Informations du camion enregistrées',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      widget.onFormSubmitted(); // Redirection vers l’interface transporteur
    } catch (e) {
      Get.snackbar('Erreur', e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
