import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: Color.fromARGB(255, 0, 0, 0), // Card or container background
    primary: Color.fromARGB(255, 196, 0, 95), // Hot pink button and highlight
    secondary: Color.fromARGB(255, 30, 30, 30), // Bottom nav background
    tertiary:
        Color.fromARGB(255, 47, 47, 47), // Chat bubbles or other components
    inversePrimary: Color.fromARGB(255, 255, 255, 255),
  ),
);
