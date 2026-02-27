import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/core/theme/app_palette.dart';

class RingProgress extends StatelessWidget {
  const RingProgress({
    super.key,
    required this.progress,
    this.size = 240,
    this.strokeWidth = 12,
    this.child,
    this.trackColor,
    this.valueColor,
  });

  final double progress;
  final double size;
  final double strokeWidth;
  final Widget? child;
  final Color? trackColor;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final double clampedProgress = progress.clamp(0, 1).toDouble();
    final bool dark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0, end: clampedProgress),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeOutCubic,
        builder: (_, double value, Widget? child) {
          return CustomPaint(
            painter: _RingProgressPainter(
              progress: value,
              strokeWidth: strokeWidth,
              trackColor:
                  trackColor ??
                  (dark
                      ? Colors.white.withValues(alpha: 0.12)
                      : AppPalette.primary.withValues(alpha: 0.16)),
              valueColor: valueColor ?? AppPalette.accent,
            ),
            child: this.child == null ? null : Center(child: this.child),
          );
        },
      ),
    );
  }
}

class _RingProgressPainter extends CustomPainter {
  _RingProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.valueColor,
  });

  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final Color valueColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (size.shortestSide - strokeWidth) / 2;
    final Rect rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: radius,
    );

    final Paint trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final Paint valuePaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: math.pi * 1.5,
        colors: <Color>[
          valueColor.withValues(alpha: 0.45),
          valueColor,
          AppPalette.gold.withValues(alpha: 0.9),
        ],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(rect, 0, math.pi * 2, false, trackPaint);
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.valueColor != valueColor;
  }
}
