import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/common_widgets/form/form_header_widget.dart';
import 'package:flutter_application_m3awda/src/constants/images_strings.dart';
import 'package:flutter_application_m3awda/src/constants/sizes.dart';
import 'package:flutter_application_m3awda/src/constants/text_strings.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/forget_password/forget_password_otp/opt_screen.dart';
import 'package:get/get.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                const SizedBox(height: tDefaultSize * 4),
                FormHeaderWidget(
                  image: tForgetPasswordImage,
                  title: tForgetPassword, // Titre sans transformation
                  subTitle: tTrouverEmail,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30.0,
                  textAlign: TextAlign.center,
                  titleStyle: TextStyle(
                    fontSize: 35.0, // Taille réduite du texte
                    fontWeight: FontWeight
                        .bold, // Optionnel : ajuster le poids de la police si nécessaire
                  ),
                ),
                const SizedBox(height: tFormHeight),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            label: Text(tEmail),
                            hintText: tEmail,
                            prefixIcon: Icon(Icons.mail_outline_rounded)),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => const OTPScreen());
                              },
                              child: const Text(tNext))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
