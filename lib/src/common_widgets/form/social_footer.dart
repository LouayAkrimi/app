import 'package:flutter/material.dart';

class SocialFooter extends StatelessWidget {
  final String text1;
  final String text2;
  final VoidCallback onPressed;

  const SocialFooter({
    super.key,
    required this.text1,
    required this.text2,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onPressed,
        child: RichText(
          text: TextSpan(
            text: "$text1 ",
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                text: text2,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
