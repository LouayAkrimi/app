import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/client/client_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/entreprise_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/transporteur/transporteur_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/welcome/welcome_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/usertype/user_model.dart';
import 'package:flutter_application_m3awda/src/repository/exceptions/signup_email_password_failure.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late final Rx<User?> firebaseUser;

  // 👉 Listes pour stocker les utilisateurs par rôle
  List<UserModel> clients = [];
  List<UserModel> transporteurs = [];
  List<UserModel> entreprises = [];

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);

    // Charger les utilisateurs au démarrage
    loadUsersByRole();
  }

  // 🔵 Redirection selon l'utilisateur connecté
  void _setInitialScreen(User? user) async {
    if (user == null) {
      Get.offAll(() => const WelcomeScreen());
    } else {
      final String? role = await _getUserRoleFromFirestore(user.uid);
      if (role != null) {
        GetStorage().write('userRole', role);
        Get.offAll(() => _getRoleScreen(role));
      } else {
        Get.offAll(() => const WelcomeScreen());
      }
    }
  }

  // 🔵 Récupérer le rôle d'un utilisateur Firestore
  Future<String?> _getUserRoleFromFirestore(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc['role'] as String?;
      }
    } catch (e) {
      print("Erreur en récupérant le rôle: $e");
    }
    return null;
  }

  // 🔵 Rediriger vers l'écran selon le rôle
  Widget _getRoleScreen(String? role) {
    switch (role) {
      case 'client':
        return const ClientScreen();
      case 'transporteur':
        return TransporteurScreen();
      case 'entreprise':
        return EntrepriseScreen();
      default:
        return const WelcomeScreen();
    }
  }

  // 🟢 Créer un compte utilisateur
  Future<String?> createUserWithEmailAndPassword(
      String email, String password, String role) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        });

        GetStorage().write('userRole', role);

        // Recharger les listes
        await loadUsersByRole();

        Get.offAll(() => _getRoleScreen(role));
      }
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      return ex.message;
    } catch (e) {
      const ex = SignUpWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }

  // 🟢 Connexion utilisateur
  Future<String?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        final String? role = await _getUserRoleFromFirestore(user.uid);
        if (role != null) {
          GetStorage().write('userRole', role);

          // Recharger les listes
          await loadUsersByRole();

          Get.offAll(() => _getRoleScreen(role));
        } else {
          return "Erreur : rôle utilisateur introuvable.";
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "Aucun utilisateur trouvé avec cet email.";
      } else if (e.code == 'wrong-password') {
        return "Le mot de passe est incorrect.";
      } else {
        return "Erreur de connexion : ${e.message}";
      }
    } catch (_) {
      return "Erreur inattendue, veuillez réessayer plus tard.";
    }
    return null;
  }

  // 🟢 Déconnexion utilisateur
  Future<void> logout() async {
    await _auth.signOut();
    await GetStorage().remove('userRole');
    Get.offAll(() => const WelcomeScreen());
  }

  // 🟢 Charger et séparer les utilisateurs par rôle
  Future<void> loadUsersByRole() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('users').get();

      // Vider les anciennes données
      clients.clear();
      transporteurs.clear();
      entreprises.clear();

      for (var doc in snapshot.docs) {
        UserModel user = UserModel.fromFirestore(doc);

        if (user.role == 'client') {
          clients.add(user);
        } else if (user.role == 'transporteur') {
          transporteurs.add(user);
        } else if (user.role == 'entreprise') {
          entreprises.add(user);
        }
      }

      print("✅ Clients: ${clients.length}");
      print("✅ Transporteurs: ${transporteurs.length}");
      print("✅ Entreprises: ${entreprises.length}");
    } catch (e) {
      print("Erreur de chargement des utilisateurs: $e");
    }
  }
}
