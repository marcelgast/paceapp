import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/stint_calculator.dart';
import '../../theme/pace_colors.dart';

/// Neon RPM gauge with a hybrid second lap.
///
/// Lap 1 ([progress], 0..1) fills the dial as the countdown runs toward the
/// target. In overtime the lap-1 ring dims to a ghost and a bright green lap-2
/// bar ([overtimeProgress]) runs around again — like the electric boost on a
/// hybrid.
class Tachometer extends StatelessWidget {
  const Tachometer({
    super.key,
    required this.progress,
    required this.phase,
    this.overtimeProgress = 0,
    this.size = 290,
    this.child,
  });

  final double progress;
  final double overtimeProgress;
  final StintPhase phase;
  final double size;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GaugePainter(
          progress: progress,
          overtimeProgress: overtimeProgress,
          phase: phase,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.progress,
    required this.overtimeProgress,
    required this.phase,
  });

  final double progress;
  final double overtimeProgress;
  final StintPhase phase;

  // Dial opens at the bottom: start 135°, sweep 270° clockwise.
  static const double _start = 135 * math.pi / 180;
  static const double _sweep = 270 * math.pi / 180;
  static const double _redlineFrom = 0.82; // last ~18% = redline zone

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 18;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final overtime = phase == StintPhase.overtime;
    final baseline = phase == StintPhase.baseline;

    _bezel(canvas, center, size.width / 2 - 4);

    // Background track.
    canvas.drawArc(
      rect,
      _start,
      _sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round
        ..color = PaceColors.panelLight,
    );

    _ticks(canvas, center, radius);

    final value = progress.clamp(0.0, 1.0);

    // Lap 1 — full rpm sweep. Bright while counting down, dimmed in overtime.
    if (value > 0 || overtime) {
      final sweep = _sweep * (overtime ? 1.0 : value);
      final base = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round
        ..shader = SweepGradient(
          startAngle: _start,
          endAngle: _start + _sweep,
          colors: PaceColors.rpmBand,
          transform: const GradientRotation(_start),
        ).createShader(rect);
      if (overtime) base.color = base.color.withValues(alpha: 0.35);
      canvas.drawArc(rect, _start, sweep, false, base);

      if (!overtime) {
        _glow(canvas, rect, sweep, PaceColors.neonMagenta);
      }
    }

    // Lap 2 — the green hybrid boost, drawn over the dimmed lap 1.
    if (overtime && overtimeProgress > 0) {
      final sweep = _sweep * overtimeProgress.clamp(0.0, 1.0);
      canvas.drawArc(
        rect,
        _start,
        sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 18
          ..strokeCap = StrokeCap.round
          ..color = PaceColors.neonLime,
      );
      _glow(canvas, rect, sweep, PaceColors.neonLime, blur: 14);
    }

    if (!baseline) {
      final needleAt = overtime ? overtimeProgress.clamp(0.0, 1.0) : value;
      _needle(
        canvas,
        center,
        radius,
        needleAt,
        overtime ? PaceColors.neonLime : PaceColors.neonCyan,
      );
    }
  }

  void _bezel(Canvas canvas, Offset center, double r) {
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = PaceColors.chrome.withValues(alpha: 0.7),
    );
  }

  void _glow(
    Canvas canvas,
    Rect rect,
    double sweep,
    Color color, {
    double blur = 12,
  }) {
    canvas.drawArc(
      rect,
      _start,
      sweep,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round
        ..color = color.withValues(alpha: 0.4)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur),
    );
  }

  void _ticks(Canvas canvas, Offset center, double radius) {
    const count = 36;
    for (var i = 0; i <= count; i++) {
      final t = i / count;
      final angle = _start + _sweep * t;
      final isMajor = i % 4 == 0;
      final inner = radius - (isMajor ? 24 : 16);
      final p1 = center + Offset(math.cos(angle), math.sin(angle)) * inner;
      final p2 =
          center + Offset(math.cos(angle), math.sin(angle)) * (radius - 8);
      final redline = t >= _redlineFrom;
      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..strokeWidth = isMajor ? 2.6 : 1.2
          ..color = redline
              ? const Color(0xFFFF2A2A).withValues(alpha: 0.9)
              : PaceColors.textFaint.withValues(alpha: 0.7),
      );
    }
  }

  void _needle(
    Canvas canvas,
    Offset center,
    double radius,
    double value,
    Color color,
  ) {
    final angle = _start + _sweep * value;
    final dir = Offset(math.cos(angle), math.sin(angle));
    final tip = center + dir * (radius - 12);
    final tail = center - dir * 24;

    canvas.drawLine(
      tail,
      tip,
      Paint()
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..color = color
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );
    canvas.drawCircle(center, 11, Paint()..color = PaceColors.chrome);
    canvas.drawCircle(center, 5.5, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.progress != progress ||
      old.overtimeProgress != overtimeProgress ||
      old.phase != phase;
}
