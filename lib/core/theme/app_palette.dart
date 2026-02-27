import 'package:flutter/material.dart';

class AppPalette {
  const AppPalette._();

  static const Color primary = Color(0xFF0E3B2E);
  static const Color accent = Color(0xFF1FAF7A);
  static const Color darkBackground = Color(0xFF0A1F18);
  static const Color cardBackground = Color(0xFF112B23);
  static const Color gold = Color(0xFFD4AF37);
  static const Color lightBackground = Color(0xFFEAF4EF);
  static const Color lightCard = Color(0xFFF5FBF8);

  static const LinearGradient appGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[Color(0xFF0E3B2E), Color(0xFF071A14)],
  );
}
