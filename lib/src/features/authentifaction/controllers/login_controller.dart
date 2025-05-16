import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();

  var showPassword = false.obs;
  var isLoading = false.obs;
  var loginSuccess = false.obs;

  Future<void> login() async {
    isLoading.value = true;

    // Simule un appel réseau
    await Future.delayed(const Duration(seconds: 2));

    // Exemple de logique de login (à adapter)
    if (email.text == "test@example.com" && password.text == "123456") {
      loginSuccess.value = true;
    } else {
      Get.snackbar("Erreur", "Identifiants incorrects");
      loginSuccess.value = false;
    }

    isLoading.value = false;
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}
