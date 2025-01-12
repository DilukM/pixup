import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixup/Util/Colors/colors.dart';

class AppElevatedButtonTheme {
  AppElevatedButtonTheme._();

  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: AppColors.primaryLight,
    side: BorderSide(color: AppColors.primaryLight),
    padding: const EdgeInsets.symmetric(
      vertical: 12,
    ),
    textStyle: TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ));

  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
    elevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: AppColors.primaryDark,
    side: BorderSide(color: AppColors.primaryDark),
    padding: const EdgeInsets.symmetric(vertical: 12),
    textStyle: TextStyle(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ));
}
