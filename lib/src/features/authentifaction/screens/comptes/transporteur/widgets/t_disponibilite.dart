import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TDisponibilite extends StatefulWidget {
  @override
  _TDisponibiliteState createState() => _TDisponibiliteState();
}

class _TDisponibiliteState extends State<TDisponibilite>
    with SingleTickerProviderStateMixin {
  bool isAvailable = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _loadAvailability();
  }

  Future<void> _loadAvailability() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      final doc =
          await _firestore.collection('transporteurs').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data();
        final available = data?['disponibilite'] ?? false;

        setState(() {
          isAvailable = available;
          if (isAvailable) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAvailable', available);
      } else {
        // Document n'existe pas => création initiale avec fausses valeurs par défaut
        await _firestore.collection('transporteurs').doc(user.uid).set({
          'uid': user.uid,
          'nom': user.displayName ?? 'Nom inconnu',
          'email': user.email ?? 'Email inconnu',
          'camion': 'Non spécifié',
          'type': 'Non spécifié',
          'capacite': 'Non spécifié',
          'matricule': 'Non spécifié',
          'disponibilite': false,
        });

        setState(() {
          isAvailable = false;
          _controller.reverse();
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isAvailable', false);
      }
    } catch (e) {
      print("Erreur Firestore (chargement dispo) : $e");
    }
  }

  Future<void> _toggleAvailability() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final newAvailability = !isAvailable;

    setState(() {
      isAvailable = newAvailability;
      if (isAvailable) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });

    try {
      final docRef = _firestore.collection('transporteurs').doc(user.uid);
      final docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // Si pour une raison quelconque il n'existe pas encore, on le crée avec données minimales
        await docRef.set({
          'uid': user.uid,
          'nom': user.displayName ?? 'Nom inconnu',
          'email': user.email ?? 'Email inconnu',
          'camion': 'Non spécifié',
          'type': 'Non spécifié',
          'capacite': 'Non spécifié',
          'matricule': 'Non spécifié',
          'disponibilite': newAvailability,
        });
      } else {
        // Sinon, on met uniquement à jour la disponibilité
        await docRef.update({
          'disponibilite': newAvailability,
        });
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isAvailable', newAvailability);

      print('✅ Disponibilité mise à jour : $newAvailability');
    } catch (e) {
      print("❌ Erreur Firestore (mise à jour dispo) : $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disponibilité'),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          isAvailable
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          Colors.white,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isAvailable
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                              ),
                            ),
                            ScaleTransition(
                              scale: _animation,
                              child: Icon(
                                isAvailable ? Icons.check_circle : Icons.cancel,
                                size: 60,
                                color: isAvailable ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          isAvailable
                              ? 'Disponible maintenant'
                              : 'Indisponible',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isAvailable ? Colors.green : Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Vous êtes actuellement ${isAvailable ? 'disponible' : 'indisponible'} pour prendre des trajets.',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _toggleAvailability,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isAvailable
                        ? [Colors.red, Colors.redAccent]
                        : [Colors.green, Colors.greenAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Text(
                    isAvailable
                        ? 'Marquer comme Indisponible'
                        : 'Marquer comme Disponible',
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
