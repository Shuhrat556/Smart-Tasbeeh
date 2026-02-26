import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF1F8A70),
    brightness: Brightness.light,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: const Color(0xFF1F8A70),
    brightness: Brightness.dark,
  );
}
