import 'package:flutter/material.dart';
import 'package:pixup/providers/movie_provider.dart';
import 'package:pixup/screens/home.dart';
import 'package:pixup/util/theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    if (_themeMode == ThemeMode.system) {
      _themeMode = ThemeMode.light;
    } else if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  String get currentTheme {
    if (_themeMode == ThemeMode.light) return "Light Theme";
    if (_themeMode == ThemeMode.dark) return "Dark Theme";
    return "System Default";
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pixup',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SearchScreen(),
          );
        },
      ),
    );
  }
}
