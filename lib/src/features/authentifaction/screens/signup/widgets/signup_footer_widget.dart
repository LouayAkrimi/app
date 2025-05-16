import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/images_strings.dart';
import 'package:flutter_application_m3awda/src/constants/text_strings.dart';
import 'package:flutter_application_m3awda/src/features/authentifaction/screens/login/login_screen.dart';

class SignUpFooterWidget extends StatelessWidget {
  const SignUpFooterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("OR"),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Image(
              image: AssetImage(tGoogleLogoImage),
              width: 20.0,
            ),
            label: Text(tSignInWithGoogle.toUpperCase()),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: tAlreadyHaveAnAccount,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                TextSpan(
                  text: tLogin.toUpperCase(),
                  style: const TextStyle(color: Colors.blue),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
