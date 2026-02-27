import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/core/theme/app_palette.dart';

class PremiumBackground extends StatelessWidget {
  const PremiumBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: dark
            ? AppPalette.appGradient
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0xFFEAF4EF), Color(0xFFDCEDE5)],
              ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: _IslamicPatternPainter(
                color: dark
                    ? Colors.white.withValues(alpha: 0.05)
                    : AppPalette.primary.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}

class _IslamicPatternPainter extends CustomPainter {
  _IslamicPatternPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final double spacing = math.max(42, size.shortestSide / 8);
    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        final Offset c = Offset(x, y);
        final Path path = Path();
        for (int i = 0; i < 8; i++) {
          final double angle = (math.pi * 2 / 8) * i;
          final Offset p = Offset(
            c.dx + math.cos(angle) * spacing * 0.35,
            c.dy + math.sin(angle) * spacing * 0.35,
          );
          if (i == 0) {
            path.moveTo(p.dx, p.dy);
          } else {
            path.lineTo(p.dx, p.dy);
          }
        }
        path.close();
        canvas.drawPath(path, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _IslamicPatternPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
