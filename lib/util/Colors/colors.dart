import 'package:flutter/material.dart';
import 'package:pixup/Util/Colors/hex_to_color.dart';

@immutable
class AppColors {
  static const white = const Color(0xFFFFFFFF);
  static const black = Color.fromARGB(255, 7, 4, 32);

  static const MaterialColor primarySwatch = Colors.blue;
  static const MaterialColor primaryDarkSwatch = Colors.blue;

  static Color primaryLight = hexStringToColor('#317EF5');
  static Color primaryDark = hexStringToColor('#317EF5');

  static const Color accentLight = Color.fromARGB(255, 229, 248, 255);
  static const Color accentDark = Color.fromARGB(255, 229, 248, 255);

  static const Color backgroundLight = Color.fromARGB(255, 248, 248, 248);
  static const Color backgroundDark = Color.fromARGB(255, 36, 34, 59);

  static const Color textLight = Color(0xFF212121);
  static const Color textDark = Color(0xFFE0E0E0);

  static const Color error = Color.fromARGB(255, 253, 0, 0);

  static Color buttonLight = hexStringToColor('#317EF5');
  static Color buttonDark = hexStringToColor('#317EF5');

  static const primaryGradient = const LinearGradient(
    colors: [
      Color.fromARGB(255, 3, 205, 255),
      Color.fromARGB(255, 0, 162, 255)
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
