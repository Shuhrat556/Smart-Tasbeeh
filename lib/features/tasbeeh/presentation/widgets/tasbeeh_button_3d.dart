import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/core/theme/app_palette.dart';
import 'package:smart_tasbeeh/core/theme/premium_effects.dart';

class TasbeehButton3D extends StatefulWidget {
  const TasbeehButton3D({
    super.key,
    required this.onTap,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onLongPressCancel,
    this.size = 142,
    this.label = '+1',
  });

  final VoidCallback onTap;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressEndCallback? onLongPressEnd;
  final VoidCallback? onLongPressCancel;
  final double size;
  final String label;

  @override
  State<TasbeehButton3D> createState() => _TasbeehButton3DState();
}

class _TasbeehButton3DState extends State<TasbeehButton3D>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        final double pulse =
            1 + (0.03 * Curves.easeInOut.transform(_controller.value));

        return Transform.scale(
          scale: pulse,
          child: GestureDetector(
            onTap: widget.onTap,
            onLongPressStart: widget.onLongPressStart,
            onLongPressEnd: widget.onLongPressEnd,
            onLongPressCancel: widget.onLongPressCancel,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  center: Alignment(-0.2, -0.4),
                  radius: 0.9,
                  colors: <Color>[
                    Color(0xFF3CD8A4),
                    Color(0xFF0E3B2E),
                    Color(0xFF071A14),
                  ],
                ),
                boxShadow: <BoxShadow>[
                  ...PremiumEffects.softShadow(opacity: 0.42),
                  ...PremiumEffects.glow(
                    color: AppPalette.accent,
                    opacity: 0.45,
                    blur: 22,
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.22),
                  width: 1.2,
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Positioned.fill(child: CustomPaint(painter: _BeadPainter())),
                  Text(
                    widget.label,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      shadows: const <Shadow>[
                        Shadow(color: Colors.black54, blurRadius: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BeadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.15);

    final Offset center = size.center(Offset.zero);
    final double radius = size.shortestSide / 2.25;
    for (int i = 0; i < 16; i++) {
      final double a = (math.pi * 2 / 16) * i;
      final Offset p = Offset(
        center.dx + math.cos(a) * radius,
        center.dy + math.sin(a) * radius,
      );
      canvas.drawCircle(p, 4.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BeadPainter oldDelegate) => false;
}
