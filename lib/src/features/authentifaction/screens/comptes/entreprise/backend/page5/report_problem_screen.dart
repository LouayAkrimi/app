import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ReportProblemScreen extends StatefulWidget {
  @override
  _ReportProblemScreenState createState() => _ReportProblemScreenState();
}

class _ReportProblemScreenState extends State<ReportProblemScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedType;
  File? _selectedImage;

  final List<String> _problemTypes = [
    'Bug technique',
    'Problème de paiement',
    'Fonction manquante',
    'Autre',
  ];

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Envoyer vers backend ou Firestore ici
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Problème signalé avec succès. Merci !'),
          backgroundColor: tPrimaryColor,
        ),
      );
      _formKey.currentState!.reset();
      setState(() {
        _selectedType = null;
        _selectedImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Signaler un problème"),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Décrivez le problème rencontré",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),

              /// Type de problème
              DropdownButtonFormField<String>(
                value: _selectedType,
                hint: Text("Type de problème"),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                ),
                items: _problemTypes
                    .map((type) => DropdownMenuItem(
                          child: Text(type),
                          value: type,
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value),
                validator: (value) =>
                    value == null ? "Veuillez sélectionner un type" : null,
              ),
              SizedBox(height: 16),

              /// Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: "Description",
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Décrivez le problème"
                    : null,
              ),
              SizedBox(height: 16),

              /// Image (optionnelle)
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: Icon(Icons.image),
                    label: Text("Ajouter une image"),
                  ),
                  SizedBox(width: 12),
                  if (_selectedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                ],
              ),
              SizedBox(height: 24),

              /// Submit
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                ),
                child: Text(
                  "Envoyer le rapport",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
