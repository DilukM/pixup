import 'package:flutter/material.dart';
import 'package:pixup/Util/Colors/colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: const TextStyle().copyWith(
      fontFamily: 'Inter Black',
      fontSize: 18,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black),

    //
    titleLarge: const TextStyle().copyWith(
        fontFamily: 'Inter Black',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryLight),
    titleMedium: const TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
    titleSmall: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
    //
    bodyLarge: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.black),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black.withOpacity(0.5)),
    //
    labelLarge: const TextStyle().copyWith(
        fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black),
    labelMedium: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.black.withOpacity(0.5)),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(
        fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: const TextStyle().copyWith(
      fontFamily: 'Inter Black',
      fontSize: 18,
      fontStyle: FontStyle.italic,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: const TextStyle().copyWith(
        fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
    //
    titleLarge: const TextStyle().copyWith(
        fontFamily: 'Inter Black',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryDark),
    titleMedium: const TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
    titleSmall: const TextStyle().copyWith(
        fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
    //
    bodyLarge: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
    bodyMedium: const TextStyle().copyWith(
        fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white),
    bodySmall: const TextStyle().copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white.withOpacity(0.5)),
    //
    labelLarge: const TextStyle().copyWith(
        fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
    labelMedium: const TextStyle().copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: Colors.white.withOpacity(0.5)),
  );
}
