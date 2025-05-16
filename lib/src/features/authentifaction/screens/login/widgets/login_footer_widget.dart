import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/images_strings.dart';
import 'package:flutter_application_m3awda/src/constants/sizes.dart';
import 'package:flutter_application_m3awda/src/constants/text_strings.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/signup/signup_screen.dart';

class LoginFooterWidget extends StatelessWidget {
  const LoginFooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("OR"),
        const SizedBox(height: tFormHeight - 20),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: const Image(image: AssetImage(tGoogleLogoImage), width: 20.0),
            onPressed: () {},
            label: const Text(tSignInWithGoogle),
          ),
        ),
        const SizedBox(height: tFormHeight - 20),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpScreen()),
            );
          },
          child: Text.rich(
            TextSpan(
              text: tDontHaveAnAccount,
              style: Theme.of(context).textTheme.bodyLarge,
              children: const [
                TextSpan(
                  text: tSignup,
                  style: TextStyle(color: Colors.blue),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
