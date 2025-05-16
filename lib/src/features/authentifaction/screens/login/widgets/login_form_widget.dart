import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/repository/authentication_repository/authentication_repository.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_application_m3awda/src/constants/sizes.dart';
import 'package:flutter_application_m3awda/src/constants/text_strings.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/controllers/login_controller.dart';

class LoginForm extends StatelessWidget {
  final VoidCallback onLoginSuccess;

  const LoginForm({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Form(
      key: controller.loginFormKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Champ Email
            TextFormField(
              controller: controller.email,
              decoration: const InputDecoration(
                prefixIcon: Icon(LineAwesomeIcons.user),
                labelText: tEmail,
                hintText: tEmail,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Veuillez entrer votre email";
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return "Veuillez entrer un email valide";
                }
                return null;
              },
            ),
            const SizedBox(height: tFormHeight - 20),

            // Champ Mot de passe
            Obx(() => TextFormField(
                  controller: controller.password,
                  obscureText: !controller.showPassword.value,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.fingerprint),
                    labelText: tPassword,
                    hintText: tPassword,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.showPassword.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        controller.showPassword.value =
                            !controller.showPassword.value;
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Veuillez entrer votre mot de passe";
                    } else if (value.length < 6) {
                      return "Le mot de passe doit contenir au moins 6 caractères";
                    }
                    return null;
                  },
                )),
            const SizedBox(height: tFormHeight - 20),

            // Lien Mot de passe oublié
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Ouvrir la page de mot de passe oublié
                },
                child: const Text(tForgetPassword),
              ),
            ),

            // Bouton de connexion
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () async {
                            if (controller.loginFormKey.currentState!
                                .validate()) {
                              String? result = await AuthenticationRepository
                                  .instance
                                  .loginWithEmailAndPassword(
                                      controller.email.text,
                                      controller.password.text);
                              if (result == null) {
                                onLoginSuccess();
                              } else {
                                // Afficher l'erreur
                                Get.snackbar(
                                  "Erreur",
                                  result,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(tLogin.toUpperCase()),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
