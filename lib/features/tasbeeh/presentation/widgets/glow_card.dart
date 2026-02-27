import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/core/theme/app_palette.dart';
import 'package:smart_tasbeeh/core/theme/premium_effects.dart';

class GlowCard extends StatelessWidget {
  const GlowCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
    this.glow = false,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final Color? borderColor;
  final bool glow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = dark
        ? AppPalette.cardBackground.withValues(alpha: 0.78)
        : AppPalette.lightCard.withValues(alpha: 0.88);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 260),
              padding: padding,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(24),
                border: borderColor != null
                    ? Border.all(color: borderColor!, width: 1.2)
                    : PremiumEffects.premiumBorder(opacity: dark ? 0.14 : 0.16),
                boxShadow: <BoxShadow>[
                  ...PremiumEffects.softShadow(opacity: dark ? 0.3 : 0.16),
                  if (glow)
                    ...PremiumEffects.glow(
                      color: AppPalette.accent,
                      opacity: dark ? 0.34 : 0.24,
                      blur: 18,
                    ),
                ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
