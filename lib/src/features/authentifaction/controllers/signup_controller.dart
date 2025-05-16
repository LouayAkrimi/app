import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../repository/authentication_repository/authentication_repository.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // Champs de formulaire
  final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();

  // Variable observable pour le rôle
  final role = ''.obs;

  // Liste des rôles disponibles
  final List<String> roleOptions = ['client', 'transporteur', 'entreprise'];

  // GetStorage pour sauvegarder le rôle localement
  final storage = GetStorage();

  // Fonction pour enregistrer l'utilisateur
  void registerUser() async {
    final userEmail = email.text.trim();
    final userPassword = password.text.trim();
    final userRole = role.value;

    if (userEmail.isEmpty || userPassword.isEmpty || userRole.isEmpty) {
      Get.snackbar(
        "Champs requis",
        "Veuillez remplir tous les champs.",
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final error = await AuthenticationRepository.instance
        .createUserWithEmailAndPassword(userEmail, userPassword, userRole);

    if (error != null) {
      if (error.toLowerCase().contains("email") &&
          error.toLowerCase().contains("already")) {
        Get.snackbar(
          "Email utilisé",
          "Cet email est déjà utilisé. Essayez de vous connecter.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Erreur",
          error.toString(),
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      // Stocker le rôle localement
      storage.write('userRole', userRole);
    }
  }
}
