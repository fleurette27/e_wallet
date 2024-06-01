import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFF5EBC66),
      primarySwatch: const MaterialColor(0xFF5EBC66, {
        50: Color(0xFFE8F5E9),
        100: Color(0xFFC8E6C9),
        200: Color(0xFFA5D6A7),
        300: Color(0xFF81C784),
        400: Color(0xFF66BB6A),
        500: Color(0xFF5EBC66),
        600: Color(0xFF57BB63),
        700: Color(0xFF4CAF50),
        800: Color(0xFF43A047),
        900: Color(0xFF388E3C),
      }),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      )),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
        selectionColor: Colors.black,
        selectionHandleColor: Colors.black,
      ),
      scaffoldBackgroundColor: const Color(0xFFF6F8F7),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      cardColor: const Color.fromARGB(255, 11, 129, 101),
      textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.black)),
      primaryColorDark: const Color.fromARGB(255, 135, 26, 60));

  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF0000FF),
      primarySwatch: const MaterialColor(0xFF0000FF, {
        50: Color(0xFFE3F2FD),
        100: Color(0xFFBBDEFB),
        200: Color(0xFF90CAF9),
        300: Color(0xFF64B5F6),
        400: Color(0xFF42A5F5),
        500: Color(
            0xFF2196F3), // Cette ligne définit la couleur bleue principale
        600: Color(0xFF1E88E5),
        700: Color(0xFF1976D2),
        800: Color(0xFF1565C0),
        900: Color(0xFF0D47A1),
      }),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      )),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionColor: Colors.white,
        selectionHandleColor: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      cardColor: const Color(0xFFffb94a),
      textTheme: const TextTheme(bodyLarge: TextStyle(color: Colors.white)));
}
