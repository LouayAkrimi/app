import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/images_strings.dart';
import 'package:flutter_application_m3awda/src/constants/text_strings.dart';

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
            image: const AssetImage(tWelcomeScreenImage),
            height: size.height * 0.2),
        Text(tLoginTitle, style: Theme.of(context).textTheme.displaySmall),
        Text(tLoginSubTitle, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}
