import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Section headline in the white-graffiti spirit of the PACE logo: marker
/// lettering, dark outline and a soft drop shadow. Used for short titles —
/// the real logo art is reserved for the word "PACE" itself.
class GraffitiHeadline extends StatelessWidget {
  const GraffitiHeadline(
    this.text, {
    super.key,
    this.size = 30,
    this.color = Colors.white,
  });

  final String text;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final base = GoogleFonts.permanentMarker(fontSize: size, height: 1.05);
    return Transform(
      alignment: Alignment.centerLeft,
      transform: Matrix4.skewX(-0.05),
      child: Stack(
        children: [
          Text(
            text,
            style: base.copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = size * 0.07
                ..strokeJoin = StrokeJoin.round
                ..color = const Color(0xFF0B0B0E),
            ),
          ),
          Text(
            text,
            style: base.copyWith(
              color: color,
              shadows: [
                Shadow(
                    color: Colors.black.withValues(alpha: 0.55),
                    blurRadius: 6,
                    offset: const Offset(0, 2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
