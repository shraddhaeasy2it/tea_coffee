import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: const Color.fromARGB(255, 117, 54, 21),
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 251, 246),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 170, 95, 54),
    primary: const Color.fromARGB(255, 131, 50, 0),
    secondary: const Color.fromARGB(255, 255, 237, 223),
    tertiary: const Color.fromARGB(255, 141, 72, 29),
    onPrimary: Colors.white,
    onSecondary: const Color.fromARGB(255, 253, 245, 241),
    onSurface: const Color(0xFF2B1A12),
    surface: const Color.fromARGB(255, 223, 182, 157),
    primaryContainer: const Color.fromARGB(218, 248, 248, 248),
    surfaceContainer: const Color.fromARGB(255, 211, 211, 211),
  ),
);