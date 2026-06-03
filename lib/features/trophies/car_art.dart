import 'package:flutter/material.dart';

import '../../theme/pace_colors.dart';

const Color _steel = Color(0xFF5A5E6B);

/// Stylised side-profile race car drawn with a CustomPainter — no licensing.
/// Proper proportions: big wheels with wheel arches, a distinct hood / cabin /
/// tail, low stance. Gets sleeker + gains a spoiler for higher tiers.
class CarArt extends StatelessWidget {
  const CarArt({
    super.key,
    required this.tierIndex,
    required this.width,
    this.unlocked = true,
  });

  final int tierIndex;
  final double width;
  final bool unlocked;

  static const List<Color> tierColors = [
    Color(0xFF8A7A6A), // Rostlaube
    PaceColors.neonCyan, // Tuned Hatchback
    PaceColors.neonMagenta, // Street Coupé
    PaceColors.neonPurple, // Drift Machine
    PaceColors.neonOrange, // Muscle Car
    PaceColors.neonLime, // GT-Renner
    Color(0xFFE8ECF5), // Hypercar (chrome)
  ];

  static Color colorFor(int index) =>
      tierColors[index.clamp(0, tierColors.length - 1)];

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, width * 0.56),
      painter: _CarPainter(
        color: unlocked ? colorFor(tierIndex) : _steel,
        aggression: (tierIndex / 6).clamp(0.0, 1.0),
        unlocked: unlocked,
      ),
    );
  }
}

class _CarPainter extends CustomPainter {
  _CarPainter({
    required this.color,
    required this.aggression,
    required this.unlocked,
  });

  final Color color;
  final double aggression; // 0..1, higher = sleeker/sportier
  final bool unlocked;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final wheelR = h * 0.19;
    final groundY = h * 0.90;
    final wheelY = groundY - wheelR * 0.92; // wheels rest on the ground
    final frontX = w * 0.245;
    final rearX = w * 0.775;

    // Low body: the rocker sits well below the wheel centres, wheels tuck into
    // arches. Sportier tiers ride a touch lower with a lower roof.
    final sill = h * (0.80 - 0.02 * aggression);
    final roofY = h * (0.34 - 0.03 * aggression);
    final archR = wheelR * 1.12;
    final archTop = wheelY - wheelR - h * 0.015; // just clears the tyre top

    // Underglow.
    if (unlocked) {
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(w * 0.5, groundY + h * 0.02),
            width: w * 0.92,
            height: h * 0.14),
        Paint()
          ..color = color.withValues(alpha: 0.4)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    // Body outline (clockwise from the hood's front edge).
    final body = Path()
      ..moveTo(w * 0.05, h * 0.52)
      // hood
      ..lineTo(w * 0.28, h * 0.475)
      // windshield up to roof
      ..quadraticBezierTo(w * 0.33, h * 0.40, w * 0.42, roofY)
      // roof
      ..lineTo(w * 0.60, roofY)
      // rear window down to deck
      ..quadraticBezierTo(w * 0.70, roofY + h * 0.12, w * 0.74, h * 0.49)
      // rear deck + tail
      ..lineTo(w * 0.95, h * 0.53)
      ..lineTo(w * 0.96, sill)
      // bottom edge, right -> left, arching over each wheel
      ..lineTo(rearX + archR, sill)
      ..quadraticBezierTo(rearX + archR, archTop, rearX, archTop)
      ..quadraticBezierTo(rearX - archR, archTop, rearX - archR, sill)
      ..lineTo(frontX + archR, sill)
      ..quadraticBezierTo(frontX + archR, archTop, frontX, archTop)
      ..quadraticBezierTo(frontX - archR, archTop, frontX - archR, sill)
      ..lineTo(w * 0.05, sill)
      ..close();

    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(color, Colors.white, 0.28)!,
            color,
            Color.lerp(color, Colors.black, 0.5)!,
          ],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Offset.zero & size),
    );

    // Greenhouse glass.
    final glass = Path()
      ..moveTo(w * 0.345, h * 0.465)
      ..quadraticBezierTo(w * 0.37, h * 0.40, w * 0.45, roofY + h * 0.02)
      ..lineTo(w * 0.585, roofY + h * 0.02)
      ..quadraticBezierTo(w * 0.66, roofY + h * 0.10, w * 0.70, h * 0.455)
      ..close();
    canvas.drawPath(
        glass, Paint()..color = const Color(0xFF0B1A24).withValues(alpha: 0.92));
    // B-pillar hint.
    canvas.drawRect(Rect.fromLTWH(w * 0.515, roofY + h * 0.02, w * 0.012, h * 0.13),
        Paint()..color = Color.lerp(color, Colors.black, 0.55)!);

    // Spoiler for sportier tiers.
    if (aggression > 0.5) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.83, h * 0.40, w * 0.15, h * 0.045),
            Radius.circular(h * 0.02)),
        Paint()..color = color,
      );
      canvas.drawRect(Rect.fromLTWH(w * 0.855, h * 0.40, w * 0.03, h * 0.10),
          Paint()..color = Color.lerp(color, Colors.black, 0.45)!);
    }

    // Headlight + tail light.
    if (unlocked) {
      canvas.drawCircle(Offset(w * 0.075, h * 0.55), h * 0.028,
          Paint()..color = Colors.white.withValues(alpha: 0.95));
      canvas.drawCircle(Offset(w * 0.945, h * 0.525), h * 0.022,
          Paint()..color = const Color(0xFFFF3B30));
    }

    // Wheels — tyre, rim, hub, spokes.
    void wheel(double cx) {
      final c = Offset(cx, wheelY);
      canvas.drawCircle(c, wheelR, Paint()..color = const Color(0xFF0E1014));
      canvas.drawCircle(c, wheelR * 0.92, Paint()..color = const Color(0xFF1A1D22));
      canvas.drawCircle(c, wheelR * 0.52, Paint()..color = _steel);
      for (var i = 0; i < 5; i++) {
        final a = i * 1.2566; // 72°
        canvas.drawLine(
          c,
          c + Offset.fromDirection(a, wheelR * 0.5),
          Paint()
            ..color = const Color(0xFF101317)
            ..strokeWidth = wheelR * 0.10,
        );
      }
      canvas.drawCircle(c, wheelR * 0.18, Paint()..color = color);
    }

    wheel(frontX);
    wheel(rearX);
  }

  @override
  bool shouldRepaint(_CarPainter old) =>
      old.color != color || old.aggression != aggression || old.unlocked != unlocked;
}
