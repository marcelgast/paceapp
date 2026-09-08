import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Spray-can wall tag — a marker-style scrawl with a dark outline and a neon
/// fill, rotated like it was sprayed on a wall. Decorative only.
class GraffitiTag extends StatelessWidget {
  const GraffitiTag({
    super.key,
    required this.text,
    required this.color,
    this.size = 34,
    this.angle = -0.12,
    this.opacity = 1.0,
  });

  final String text;
  final Color color;
  final double size;
  final double angle;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final style = GoogleFonts.permanentMarker(fontSize: size, height: 1.0);
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Stack(
          children: [
            // Dark outline.
            Text(
              text,
              style: style.copyWith(
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = size * 0.14
                  ..strokeJoin = StrokeJoin.round
                  ..color = const Color(0xFF09080D),
              ),
            ),
            // Neon fill with a soft spray glow.
            Text(
              text,
              style: style.copyWith(
                color: color,
                shadows: [
                  Shadow(color: color.withValues(alpha: 0.7), blurRadius: 14),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
