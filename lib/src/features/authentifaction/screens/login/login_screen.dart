import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/common_widgets/form/t_form_divider_widget.dart';
import 'package:flutter_application_m3awda/src/constants/images_strings.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter_application_m3awda/src/constants/sizes.dart';
import 'package:flutter_application_m3awda/src/constants/text_strings.dart';

import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/client/client_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/entreprise/entreprise_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/comptes/transporteur/transporteur_screen.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/signup/signup_screen.dart';

import 'package:flutter_application_m3awda/src/features/authentifaction/screens/login/widgets/login_form_widget.dart';
import 'package:flutter_application_m3awda/src/common_widgets/form/form_header_widget.dart';
import 'package:flutter_application_m3awda/src/common_widgets/form/social_footer.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void _redirectUser() {
    final box = GetStorage();
    String? userRole = box.read("userRole");

    if (userRole == "client") {
      Get.off(() => const ClientScreen());
    } else if (userRole == "transporteur") {
      Get.off(() => TransporteurScreen());
    } else if (userRole == "entreprise") {
      Get.off(() => EntrepriseScreen());
    } else {
      Get.snackbar("Erreur", "Rôle utilisateur non défini");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FormHeaderWidget(
                  image: tWelcomeScreenImage,
                  title: tLoginTitle,
                  subTitle: tLoginSubTitle,
                ),
                const SizedBox(height: tDefaultSize),

                /// Formulaire avec redirection après succès
                LoginForm(onLoginSuccess: _redirectUser),

                const TFormDividerWidget(),
                SocialFooter(
                  text1: tDontHaveAnAccount,
                  text2: tSignup,
                  onPressed: () => Get.off(() => const SignUpScreen()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
