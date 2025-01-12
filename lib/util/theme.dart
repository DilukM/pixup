import 'package:pixup/Util/Colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:pixup/Util/elevated_button_theme.dart';
import 'package:pixup/Util/text_field_theme.dart';
import 'package:pixup/Util/text_theme.dart';

final ThemeData lightTheme = ThemeData(
  fontFamily: 'Inter',
  primarySwatch: AppColors.primarySwatch,
  unselectedWidgetColor: AppColors.black,
  shadowColor: Colors.grey[400],
  colorScheme: ColorScheme.light(
    primary: AppColors.primaryLight,
    secondary: AppColors.accentLight,
    surface: AppColors.backgroundLight,
    onSurface: AppColors.textLight,
    onError: AppColors.textLight,
    error: AppColors.error,
    onPrimary: AppColors.textLight,
    onSecondary: AppColors.textLight,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
  brightness: Brightness.light,
  appBarTheme: AppBarTheme(
    color: Colors.transparent,
    iconTheme: IconThemeData(color: AppColors.black),
  ),
  textTheme: AppTextTheme.lightTextTheme,
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.buttonDark,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: AppElevatedButtonTheme.lightElevatedButtonTheme,
  inputDecorationTheme: AppTextFormFieldTheme.lightInputDecorationTheme,
);

final ThemeData darkTheme = ThemeData(
  fontFamily: 'Inter',
  primarySwatch: AppColors.primarySwatch,
  unselectedWidgetColor: AppColors.white,
  shadowColor: const Color.fromARGB(255, 24, 24, 24),
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryDark,
    secondary: AppColors.accentDark,
    surface: AppColors.backgroundDark,
    onSurface: AppColors.textDark,
    onError: AppColors.textDark,
    error: AppColors.error,
    onPrimary: AppColors.textDark,
    onSecondary: AppColors.textDark,
    brightness: Brightness.dark,
  ),
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColor: AppColors.primaryDark,
  appBarTheme: AppBarTheme(
    color: Colors.transparent,
    iconTheme: IconThemeData(color: AppColors.white),
  ),
  textTheme: AppTextTheme.darkTextTheme,
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.buttonDark,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: AppElevatedButtonTheme.darkElevatedButtonTheme,
  inputDecorationTheme: AppTextFormFieldTheme.darkInputDecorationTheme,
);
