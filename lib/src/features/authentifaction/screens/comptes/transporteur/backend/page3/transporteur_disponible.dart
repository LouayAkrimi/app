import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/client/formulaire/demandelivraisonpage.dart';

class TransporteursDisponiblesPage extends StatelessWidget {
  const TransporteursDisponiblesPage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>?> _getTruckInfo(String uid) async {
    final truckSnap = await FirebaseFirestore.instance
        .collection('trucks')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();

    if (truckSnap.docs.isNotEmpty) {
      return truckSnap.docs.first.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final transporteursRef =
        FirebaseFirestore.instance.collection('transporteurs');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transporteurs Disponibles'),
        backgroundColor: tPrimaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: transporteursRef
            .where('disponibilite', isEqualTo: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Erreur de chargement.'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(
              child: Text('Aucun transporteur disponible pour le moment.'),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final uid = docs[index].id;
              final transporteur = docs[index].data() as Map<String, dynamic>;

              return FutureBuilder<Map<String, dynamic>?>(
                future: _getTruckInfo(uid),
                builder: (context, truckSnapshot) {
                  if (truckSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Chargement...'),
                      subtitle: Text('Chargement des infos camion...'),
                    );
                  }

                  final truck = truckSnapshot.data ?? {};

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.green),
                              const SizedBox(width: 8),
                              Text(
                                transporteur['nom'] ?? 'Transporteur',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.local_shipping,
                                  color: Colors.black87),
                              const SizedBox(width: 8),
                              Text(
                                  'Modèle: ${truck['model'] ?? 'Non renseigné'}'),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.category, color: Colors.black87),
                              const SizedBox(width: 8),
                              Text('Type: ${truck['type'] ?? 'Non renseigné'}'),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.scale, color: Colors.black87),
                              const SizedBox(width: 8),
                              Text(
                                  'Capacité: ${truck['capacity'] ?? 'Non renseignée'}'),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              const Icon(Icons.confirmation_number,
                                  color: Colors.black87),
                              const SizedBox(width: 8),
                              Text(
                                  'Matricule: ${truck['plate_number'] ?? 'Non renseignée'}'),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DemandeLivraisonPage(
                                    transporteurId: uid,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.send),
                            label: const Text('Contacter'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: tPrimaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
