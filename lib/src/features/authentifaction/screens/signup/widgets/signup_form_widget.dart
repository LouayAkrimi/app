import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/sizes.dart';
import 'package:flutter_application_m3awda/src/constants/text_strings.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/signup/formulaire/TruckFormPage.dart';
import 'package:flutter_application_m3awda/src/repository/authentication_repository/authentication_repository.dart';
import 'package:get/get.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);

  @override
  _SignUpFormWidgetState createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  bool _obscureText = true;
  bool _isLoading = false;
  String? selectedRole;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: tFormHeight - 10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom complet
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  label: Text(tFullName),
                  prefixIcon: Icon(Icons.person_outline_rounded),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),

            // Email
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label: Text(tEmail),
                  prefixIcon: Icon(Icons.email_outlined),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: tFormHeight - 20),

            // Sélection du rôle
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Sélectionnez un type",
                prefixIcon: Icon(Icons.business),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "client", child: Text("Client")),
                DropdownMenuItem(
                    value: "transporteur", child: Text("Transporteur")),
                DropdownMenuItem(
                    value: "entreprise", child: Text("Entreprise")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedRole = value;
                });
              },
              value: selectedRole,
            ),
            const SizedBox(height: tFormHeight - 20),

            // Mot de passe
            TextFormField(
              obscureText: _obscureText,
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint),
                labelText: tPassword,
                hintText: tPassword,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: tFormHeight - 10),

            // Bouton inscription
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _registerUser,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(tSignup.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    if (selectedRole != null &&
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      if (mounted) setState(() => _isLoading = true);

      final errorMessage = await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
        selectedRole!,
      );

      if (mounted) setState(() => _isLoading = false);

      if (errorMessage != null) {
        Get.snackbar(
          'Erreur',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Succès',
          'Inscription réussie !',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        if (selectedRole == "transporteur") {
          Get.to(() => TruckFormPage(
                onFormSubmitted: () {
                  Get.offAllNamed('/transporteurInterface');
                },
              ));
        } else if (selectedRole == "client") {
          Get.offAllNamed('/clientInterface');
        } else if (selectedRole == "entreprise") {
          Get.offAllNamed('/entrepriseInterface');
        }
      }
    } else {
      Get.snackbar(
        'Erreur',
        'Veuillez remplir tous les champs',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
