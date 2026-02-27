import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/core/theme/app_palette.dart';

class PremiumEffects {
  const PremiumEffects._();

  static List<BoxShadow> softShadow({double opacity = 0.28}) {
    return <BoxShadow>[
      BoxShadow(
        color: Colors.black.withValues(alpha: opacity),
        blurRadius: 24,
        spreadRadius: -4,
        offset: const Offset(0, 12),
      ),
    ];
  }

  static List<BoxShadow> glow({
    Color color = AppPalette.accent,
    double opacity = 0.42,
    double blur = 24,
  }) {
    return <BoxShadow>[
      BoxShadow(
        color: color.withValues(alpha: opacity),
        blurRadius: blur,
        spreadRadius: 0,
      ),
    ];
  }

  static Border premiumBorder({double opacity = 0.18}) {
    return Border.all(color: Colors.white.withValues(alpha: opacity), width: 1);
  }
}
