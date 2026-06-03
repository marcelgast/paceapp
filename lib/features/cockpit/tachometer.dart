import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/stint_calculator.dart';
import '../../theme/pace_colors.dart';

/// Neon RPM-style gauge. Fills [progress] (0..1) around the dial; in overtime
/// the whole ring glows lime and the needle sits in the "red zone".
class Tachometer extends StatelessWidget {
  const Tachometer({
    super.key,
    required this.progress,
    required this.phase,
    this.size = 260,
    this.child,
  });

  final double progress;
  final StintPhase phase;
  final double size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GaugePainter(progress: progress, phase: phase),
        child: Center(child: child),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({required this.progress, required this.phase});

  final double progress;
  final StintPhase phase;

  // Dial opens at the bottom: start 135°, sweep 270° clockwise.
  static const double _start = 135 * math.pi / 180;
  static const double _sweep = 270 * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 14;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final overtime = phase == StintPhase.overtime;
    final baseline = phase == StintPhase.baseline;

    // Background track.
    canvas.drawArc(
      rect,
      _start,
      _sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..color = PaceColors.panelLight,
    );

    // Tick marks.
    _ticks(canvas, center, radius);

    // Value arc.
    final value = progress.clamp(0.0, 1.0);
    if (value > 0 || overtime) {
      final arcColor = overtime ? PaceColors.neonLime : null;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round;
      if (arcColor != null) {
        paint.color = arcColor;
      } else {
        paint.shader = SweepGradient(
          startAngle: _start,
          endAngle: _start + _sweep,
          colors: PaceColors.rpmBand,
          transform: GradientRotation(_start),
        ).createShader(rect);
      }
      canvas.drawArc(rect, _start, _sweep * (overtime ? 1 : value), false,
          paint..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.5));

      // Outer glow.
      canvas.drawArc(
        rect,
        _start,
        _sweep * (overtime ? 1 : value),
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 16
          ..strokeCap = StrokeCap.round
          ..color = (overtime ? PaceColors.neonLime : PaceColors.neonMagenta)
              .withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
      );
    }

    if (!baseline) {
      _needle(canvas, center, radius, overtime ? 1.0 : value, overtime);
    }
  }

  void _ticks(Canvas canvas, Offset center, double radius) {
    const count = 27;
    for (var i = 0; i <= count; i++) {
      final t = i / count;
      final angle = _start + _sweep * t;
      final isMajor = i % 3 == 0;
      final inner = radius - (isMajor ? 22 : 16);
      final p1 = center + Offset(math.cos(angle), math.sin(angle)) * inner;
      final p2 = center + Offset(math.cos(angle), math.sin(angle)) * (radius - 6);
      // Last third of the dial tinted toward the red zone.
      final hot = t > 0.78;
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..strokeWidth = isMajor ? 2.5 : 1.2
          ..color = hot
              ? PaceColors.neonMagenta.withValues(alpha: 0.8)
              : PaceColors.textFaint.withValues(alpha: 0.7),
      );
    }
  }

  void _needle(
      Canvas canvas, Offset center, double radius, double value, bool overtime) {
    final angle = _start + _sweep * value;
    final dir = Offset(math.cos(angle), math.sin(angle));
    final tip = center + dir * (radius - 10);
    final tail = center - dir * 22;
    final color = overtime ? PaceColors.neonLime : PaceColors.neonCyan;

    canvas.drawLine(
      tail,
      tip,
      Paint()
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawCircle(center, 10, Paint()..color = PaceColors.chrome);
    canvas.drawCircle(center, 5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.progress != progress || old.phase != phase;
}
