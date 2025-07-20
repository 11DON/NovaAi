import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Color.fromARGB(255, 255, 255, 255), // Card or container background
    primary: Color.fromARGB(255, 196, 0, 95), // Same hot pink
    secondary: Color.fromARGB(255, 230, 230, 230), // Light gray background
    tertiary: Color.fromARGB(255, 210, 210, 210), // For components
    inversePrimary: Color.fromARGB(255, 30, 30, 30),
  ),
);
