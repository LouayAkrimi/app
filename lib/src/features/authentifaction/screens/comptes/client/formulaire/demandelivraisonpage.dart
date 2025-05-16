import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';

class DemandeLivraisonPage extends StatefulWidget {
  final String transporteurId;

  const DemandeLivraisonPage({Key? key, required this.transporteurId})
      : super(key: key);

  @override
  State<DemandeLivraisonPage> createState() => _DemandeLivraisonPageState();
}

class _DemandeLivraisonPageState extends State<DemandeLivraisonPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lieuDepart = TextEditingController();
  final TextEditingController _lieuArrivee = TextEditingController();
  final TextEditingController _colis = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  void dispose() {
    _lieuDepart.dispose();
    _lieuArrivee.dispose();
    _colis.dispose();
    _description.dispose();
    super.dispose();
  }

  void _envoyerDemande() {
    if (_formKey.currentState!.validate()) {
      // Envoi vers Firestore ou traitement ici
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Demande envoyée !')),
      );
      Navigator.pop(context); // Retour à la page précédente
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Demande de Livraison'),
        backgroundColor: tPrimaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _lieuDepart,
                decoration: const InputDecoration(
                  labelText: 'Lieu de départ',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lieuArrivee,
                decoration: const InputDecoration(
                  labelText: 'Lieu d\'arrivée',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colis,
                decoration: const InputDecoration(
                  labelText: 'Nom du colis',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _envoyerDemande,
                style: ElevatedButton.styleFrom(
                  backgroundColor: tPrimaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Envoyer Demande',
                  style: TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
