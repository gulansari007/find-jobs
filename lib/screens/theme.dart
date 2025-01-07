import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  colorScheme: const ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.green,
    surface: Colors.white, // Background for cards and other surface elements
    onSurface: Colors.black, // Text color for background
  ),
  // Add more light theme properties here
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.deepPurple,
  colorScheme: ColorScheme.dark(
    primary: Colors.deepPurple,
    secondary: Colors.orange,
    surface: Colors.grey[900]!, // Surface color for dark mode elements
    onSurface: Colors.white, // Text color for dark background
  ),
  // Add more dark theme properties here
);
