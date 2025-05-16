import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/common_widgets/form/form_header_widget.dart';
import 'package:flutter_application_m3awda/src/constants/images_strings.dart';
import 'package:flutter_application_m3awda/src/constants/sizes.dart';
import 'package:flutter_application_m3awda/src/constants/text_strings.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/signup/widgets/signup_footer_widget.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/signup/widgets/signup_form_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              children: [
                FormHeaderWidget(
                  image: tWelcomeScreenImage,
                  title: tSignUpTitle,
                  subTitle: tSignUpSubTitle,
                  imageHeight: 0.15,
                  titleStyle: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold), // Taille réduite
                ),
                SignUpFormWidget(),
                SignUpFooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
