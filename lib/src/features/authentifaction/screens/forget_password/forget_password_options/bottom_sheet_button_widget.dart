import 'package:flutter/material.dart';

class ForgetPasswordBtnWidget extends StatelessWidget {
  const ForgetPasswordBtnWidget({
    required this.btnIcon,
    required this.title,
    required this.subTitle,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final IconData btnIcon;
  final String title, subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // Vérifier si l'application est en mode sombre ou clair
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: isDarkMode
              ? Colors.grey[800]
              : Colors.grey.shade200, // Couleur de fond dynamique
        ),
        child: Row(
          children: [
            Icon(
              btnIcon,
              size: 60.0,
              color: isDarkMode
                  ? Colors.white
                  : Colors.black, // Couleur de l'icône dynamique
            ),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isDarkMode
                            ? Colors.white
                            : Colors.black, // Couleur du titre dynamique
                      ),
                ),
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode
                            ? Colors.white70
                            : Colors.black87, // Couleur du sous-titre dynamique
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
