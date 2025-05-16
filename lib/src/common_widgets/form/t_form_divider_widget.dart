import 'package:flutter/material.dart';

class TFormDividerWidget extends StatelessWidget {
  const TFormDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text("OU", style: Theme.of(context).textTheme.bodySmall),
        ),
        const Expanded(child: Divider(thickness: 1)),
      ],
    );
  }
}
