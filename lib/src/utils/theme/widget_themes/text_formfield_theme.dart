// Use this inside the main Theme to call Light or Dark Modes
import 'package:flutter/material.dart';
import 'package:flutter_application_m3awda/src/constants/colors.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static const InputDecorationTheme lightInputDecorationTheme =
      InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: tSecondaryColor,
    floatingLabelStyle: TextStyle(color: tSecondaryColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: tSecondaryColor),
    ),
  );

  static const InputDecorationTheme darkInputDecorationTheme =
      InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: tPrimaryColor,
    floatingLabelStyle: TextStyle(color: tPrimaryColor),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: tPrimaryColor),
    ),
  );
}
