import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 0, 0, 0), // Card or container background
    primary: const Color.fromARGB(
      255,
      196,
      0,
      95,
    ), // Hot pink button and highlight
    secondary: Colors.grey.shade500,
    tertiary: const Color(0xFF19191F).withValues(alpha: 0.9),
    inversePrimary: const Color.fromARGB(255, 255, 255, 255),
  ),
);
