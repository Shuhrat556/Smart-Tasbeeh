import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

const int _size = 1024;

void main() {
  final img.Image icon = img.Image(width: _size, height: _size);

  final img.Color top = img.ColorRgb8(14, 59, 46);
  final img.Color bottom = img.ColorRgb8(7, 26, 20);

  for (int y = 0; y < _size; y++) {
    final double t = y / (_size - 1);
    final int r = _lerp(top.r.toInt(), bottom.r.toInt(), t);
    final int g = _lerp(top.g.toInt(), bottom.g.toInt(), t);
    final int b = _lerp(top.b.toInt(), bottom.b.toInt(), t);
    final img.Color c = img.ColorRgb8(r, g, b);
    for (int x = 0; x < _size; x++) {
      icon.setPixel(x, y, c);
    }
  }

  final int cx = _size ~/ 2;
  final int cy = _size ~/ 2;
  final int ringRadius = 320;

  for (int i = 0; i < 24; i++) {
    final double angle = (math.pi * 2 / 24) * i;
    final int x = cx + (math.cos(angle) * ringRadius).round();
    final int y = cy + (math.sin(angle) * ringRadius).round();

    final int beadR = i.isEven ? 24 : 20;
    _fillCircle(icon, x, y, beadR + 6, img.ColorRgba8(0, 0, 0, 70));
    _fillGradientCircle(
      icon,
      x,
      y,
      beadR,
      inner: img.ColorRgb8(80, 226, 173),
      outer: img.ColorRgb8(28, 98, 72),
    );
  }

  _fillGradientCircle(
    icon,
    cx,
    cy,
    210,
    inner: img.ColorRgb8(43, 157, 113),
    outer: img.ColorRgb8(16, 49, 38),
  );
  _drawInnerRing(icon, cx, cy, 225, img.ColorRgb8(212, 175, 55));
  _drawInnerRing(icon, cx, cy, 195, img.ColorRgb8(230, 214, 158));

  _drawTasbeehGlyph(icon, cx, cy);

  final File out = File('assets/icons/app_icon_v1.png');
  out.parent.createSync(recursive: true);
  out.writeAsBytesSync(img.encodePng(icon));
  stdout.writeln('Generated ${out.path}');
}

int _lerp(int a, int b, double t) => (a + ((b - a) * t)).round();

void _fillCircle(img.Image image, int cx, int cy, int radius, img.Color color) {
  final int r2 = radius * radius;
  for (int y = cy - radius; y <= cy + radius; y++) {
    if (y < 0 || y >= image.height) {
      continue;
    }
    for (int x = cx - radius; x <= cx + radius; x++) {
      if (x < 0 || x >= image.width) {
        continue;
      }
      final int dx = x - cx;
      final int dy = y - cy;
      if (dx * dx + dy * dy <= r2) {
        image.setPixel(x, y, color);
      }
    }
  }
}

void _fillGradientCircle(
  img.Image image,
  int cx,
  int cy,
  int radius, {
  required img.Color inner,
  required img.Color outer,
}) {
  final int r2 = radius * radius;
  for (int y = cy - radius; y <= cy + radius; y++) {
    if (y < 0 || y >= image.height) {
      continue;
    }
    for (int x = cx - radius; x <= cx + radius; x++) {
      if (x < 0 || x >= image.width) {
        continue;
      }
      final int dx = x - cx;
      final int dy = y - cy;
      final int d2 = dx * dx + dy * dy;
      if (d2 <= r2) {
        final double t = math.sqrt(d2) / radius;
        final int r = _lerp(inner.r.toInt(), outer.r.toInt(), t);
        final int g = _lerp(inner.g.toInt(), outer.g.toInt(), t);
        final int b = _lerp(inner.b.toInt(), outer.b.toInt(), t);
        image.setPixel(x, y, img.ColorRgb8(r, g, b));
      }
    }
  }
}

void _drawInnerRing(
  img.Image image,
  int cx,
  int cy,
  int radius,
  img.Color color,
) {
  const int width = 6;
  for (int i = 0; i < 360; i++) {
    final double a = i * math.pi / 180;
    for (int w = -width; w <= width; w++) {
      final int x = cx + (math.cos(a) * (radius + w)).round();
      final int y = cy + (math.sin(a) * (radius + w)).round();
      if (x >= 0 && x < image.width && y >= 0 && y < image.height) {
        image.setPixel(x, y, color);
      }
    }
  }
}

void _drawTasbeehGlyph(img.Image image, int cx, int cy) {
  final img.Color white = img.ColorRgb8(238, 247, 242);

  img.drawLine(
    image,
    x1: cx - 40,
    y1: cy - 70,
    x2: cx + 20,
    y2: cy - 70,
    color: white,
    thickness: 18,
  );
  img.drawLine(
    image,
    x1: cx + 20,
    y1: cy - 70,
    x2: cx + 50,
    y2: cy - 40,
    color: white,
    thickness: 18,
  );
  img.drawLine(
    image,
    x1: cx + 50,
    y1: cy - 40,
    x2: cx + 50,
    y2: cy + 40,
    color: white,
    thickness: 18,
  );
  img.drawLine(
    image,
    x1: cx + 50,
    y1: cy + 40,
    x2: cx + 20,
    y2: cy + 70,
    color: white,
    thickness: 18,
  );
  img.drawLine(
    image,
    x1: cx + 20,
    y1: cy + 70,
    x2: cx - 40,
    y2: cy + 70,
    color: white,
    thickness: 18,
  );
  img.drawLine(
    image,
    x1: cx - 40,
    y1: cy + 70,
    x2: cx - 70,
    y2: cy + 40,
    color: white,
    thickness: 18,
  );
  img.drawLine(
    image,
    x1: cx - 70,
    y1: cy + 40,
    x2: cx - 70,
    y2: cy - 10,
    color: white,
    thickness: 18,
  );

  _fillCircle(image, cx - 10, cy + 5, 16, img.ColorRgb8(212, 175, 55));
  _fillCircle(image, cx + 22, cy + 5, 16, img.ColorRgb8(212, 175, 55));
}
