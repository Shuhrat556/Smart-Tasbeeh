import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_tasbeeh/core/theme/app_palette.dart';
import 'package:smart_tasbeeh/features/tasbeeh/presentation/widgets/glow_card.dart';

class QiblaTab extends StatelessWidget {
  const QiblaTab({
    super.key,
    required this.t,
    required this.direction,
    required this.distanceKm,
  });

  final String Function(String key) t;
  final int direction;
  final int distanceKm;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
        children: <Widget>[
          GlowCard(
            glow: true,
            child: Column(
              children: <Widget>[
                _CompassWidget(direction: direction),
                const SizedBox(height: 12),
                Text(
                  '$direction°',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${t('direction_label')}: $direction°',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  '${t('distance_label')}: $distanceKm km',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlowCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  t('qibla_title'),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(t('qibla_placeholder')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassWidget extends StatefulWidget {
  const _CompassWidget({required this.direction});

  final int direction;

  @override
  State<_CompassWidget> createState() => _CompassWidgetState();
}

class _CompassWidgetState extends State<_CompassWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double size = 288;
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final double wobble = math.sin(_controller.value * math.pi * 2) * 4;
          final double rotation = (widget.direction + wobble) * math.pi / 180;

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              CustomPaint(
                size: const Size.square(size),
                painter: _CompassDialPainter(),
              ),
              Transform.rotate(
                angle: rotation,
                child: CustomPaint(
                  size: const Size.square(size * 0.8),
                  painter: _NeedlePainter(),
                ),
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0xFF2D473E), Color(0xFF111F1A)],
                  ),
                  border: Border.all(
                    color: AppPalette.gold.withValues(alpha: 0.65),
                    width: 1.3,
                  ),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.mosque_outlined,
                  color: AppPalette.gold,
                  size: 34,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CompassDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final double radius = size.shortestSide / 2;

    final Paint bg = Paint()
      ..shader = const RadialGradient(
        colors: <Color>[Color(0xFF29473D), Color(0xFF0D1814)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawCircle(center, radius, bg);

    final Paint border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = AppPalette.gold.withValues(alpha: 0.5);
    canvas.drawCircle(center, radius - 2, border);

    final Paint ticks = Paint()
      ..color = AppPalette.gold.withValues(alpha: 0.68)
      ..strokeWidth = 1.4;

    for (int i = 0; i < 60; i++) {
      final double angle = (math.pi * 2 / 60) * i;
      final double inner = i % 5 == 0 ? radius * 0.76 : radius * 0.84;
      final Offset start = Offset(
        center.dx + math.cos(angle) * inner,
        center.dy + math.sin(angle) * inner,
      );
      final Offset end = Offset(
        center.dx + math.cos(angle) * (radius * 0.92),
        center.dy + math.sin(angle) * (radius * 0.92),
      );
      canvas.drawLine(start, end, ticks);
    }

    final TextPainter tpN = TextPainter(
      text: TextSpan(
        text: 'N',
        style: const TextStyle(
          color: AppPalette.gold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tpN.paint(
      canvas,
      Offset(center.dx - tpN.width / 2, center.dy - radius * 0.95),
    );

    _paintCardinal(canvas, center, radius, 'E', 0);
    _paintCardinal(canvas, center, radius, 'S', 90);
    _paintCardinal(canvas, center, radius, 'W', 180);
  }

  void _paintCardinal(
    Canvas canvas,
    Offset center,
    double radius,
    String label,
    double angleDeg,
  ) {
    final double angle = angleDeg * math.pi / 180;
    final TextPainter tp = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(
          color: AppPalette.gold,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final Offset p = Offset(
      center.dx + math.cos(angle) * radius * 0.8 - tp.width / 2,
      center.dy + math.sin(angle) * radius * 0.8 - tp.height / 2,
    );
    tp.paint(canvas, p);
  }

  @override
  bool shouldRepaint(covariant _CompassDialPainter oldDelegate) => false;
}

class _NeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);

    final Path forward = Path()
      ..moveTo(center.dx, size.height * 0.12)
      ..lineTo(center.dx + 11, center.dy)
      ..lineTo(center.dx - 11, center.dy)
      ..close();

    final Path back = Path()
      ..moveTo(center.dx, size.height * 0.88)
      ..lineTo(center.dx + 8, center.dy)
      ..lineTo(center.dx - 8, center.dy)
      ..close();

    final Paint frontPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[Color(0xFFFFF5CF), Color(0xFFD4AF37)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final Paint backPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.24);

    canvas.drawPath(back, backPaint);
    canvas.drawPath(forward, frontPaint);
    canvas.drawCircle(center, 6, Paint()..color = AppPalette.gold);
    canvas.drawCircle(center, 2, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter oldDelegate) => false;
}
