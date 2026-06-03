import 'package:flutter/material.dart';

import '../../theme/pace_colors.dart';

const Color _steel = Color(0xFF5A5E6B);

/// Stylised side-profile race car drawn with a CustomPainter — no licensing,
/// consistent look. Gets sleeker + gains a spoiler for higher tiers.
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

  /// Accent colour per garage tier.
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
      size: Size(width, width * 0.52),
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
  final double aggression;
  final bool unlocked;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final roofLift = 0.10 * (1 - aggression); // higher tiers sit lower
    final wheelR = h * 0.17;
    final groundY = h * 0.80;

    // Underglow.
    if (unlocked) {
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(w * 0.5, groundY + wheelR * 0.6),
            width: w * 0.9,
            height: h * 0.18),
        Paint()
          ..color = color.withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    // Body.
    final body = Path()
      ..moveTo(w * 0.06, h * 0.70)
      ..lineTo(w * 0.20, h * 0.70)
      ..quadraticBezierTo(w * 0.26, h * 0.52, w * 0.40, (0.36 + roofLift) * h)
      ..lineTo(w * 0.58, (0.36 + roofLift) * h)
      ..quadraticBezierTo(w * 0.70, h * 0.46, w * 0.82, h * 0.56)
      ..lineTo(w * 0.95, h * 0.58)
      ..quadraticBezierTo(w * 0.97, h * 0.60, w * 0.95, h * 0.70)
      ..lineTo(w * 0.06, h * 0.70)
      ..close();

    canvas.drawPath(
      body,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(color, Colors.white, 0.25)!,
            color,
            Color.lerp(color, Colors.black, 0.45)!,
          ],
        ).createShader(Offset.zero & size),
    );

    // Window glass.
    final glass = Path()
      ..moveTo(w * 0.30, h * 0.58)
      ..quadraticBezierTo(w * 0.33, h * 0.46, w * 0.42, (0.40 + roofLift) * h)
      ..lineTo(w * 0.56, (0.40 + roofLift) * h)
      ..quadraticBezierTo(w * 0.62, h * 0.46, w * 0.64, h * 0.56)
      ..close();
    canvas.drawPath(glass, Paint()..color = const Color(0xFF0C1820).withValues(alpha: 0.9));

    // Spoiler for sportier tiers.
    if (aggression > 0.55) {
      canvas.drawRect(
        Rect.fromLTWH(w * 0.86, h * 0.46, w * 0.10, h * 0.05),
        Paint()..color = color,
      );
      canvas.drawRect(
        Rect.fromLTWH(w * 0.88, h * 0.46, w * 0.03, h * 0.14),
        Paint()..color = Color.lerp(color, Colors.black, 0.4)!,
      );
    }

    // Headlight (tucked onto the nose).
    if (unlocked) {
      canvas.drawCircle(Offset(w * 0.205, h * 0.665),
          h * 0.035, Paint()..color = Colors.white.withValues(alpha: 0.95));
    }

    // Wheels.
    void wheel(double cx) {
      canvas.drawCircle(Offset(cx, groundY), wheelR, Paint()..color = const Color(0xFF111317));
      canvas.drawCircle(Offset(cx, groundY), wheelR * 0.55,
          Paint()..color = _steel);
      canvas.drawCircle(Offset(cx, groundY), wheelR * 0.22,
          Paint()..color = color);
    }

    wheel(w * 0.26);
    wheel(w * 0.74);
  }

  @override
  bool shouldRepaint(_CarPainter old) =>
      old.color != color || old.aggression != aggression || old.unlocked != unlocked;
}
