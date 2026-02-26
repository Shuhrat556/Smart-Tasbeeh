import 'package:flutter/material.dart';

enum ThemePreference { system, light, dark }

extension ThemePreferenceX on ThemePreference {
  ThemeMode toThemeMode() {
    switch (this) {
      case ThemePreference.system:
        return ThemeMode.system;
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
    }
  }

  static ThemePreference fromIndex(int index) {
    if (index < 0 || index >= ThemePreference.values.length) {
      return ThemePreference.system;
    }
    return ThemePreference.values[index];
  }
}
