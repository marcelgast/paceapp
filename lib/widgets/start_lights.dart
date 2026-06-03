import 'package:flutter/material.dart';

import '../theme/pace_colors.dart';

/// Drag-strip "christmas tree" staging light. Two blue stage bulbs up top,
/// three ambers that cascade as [progress] grows, then green — GO.
///
/// Driven by an external 0..1 [progress] value so the parent can sync the
/// launch with saving / navigation.
class StartLights extends StatelessWidget {
  const StartLights({super.key, required this.progress});

  final double progress;

  static const double _goAt = 0.78;
  static const List<double> _amberOn = [0.30, 0.45, 0.60];

  bool get _go => progress >= _goAt;

  @override
  Widget build(BuildContext context) {
    final stageLit = progress >= 0.02;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [PaceColors.panelLight, PaceColors.panel],
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: PaceColors.chrome, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.6),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pre-stage / stage (blue).
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Bulb(color: PaceColors.neonCyan, lit: stageLit, size: 14),
                  const SizedBox(width: 10),
                  _Bulb(color: PaceColors.neonCyan, lit: stageLit, size: 14),
                ],
              ),
              const SizedBox(height: 14),
              for (var i = 0; i < _amberOn.length; i++) ...[
                _Bulb(
                  color: PaceColors.stageAmber,
                  lit: !_go && progress >= _amberOn[i],
                  size: 34,
                ),
                const SizedBox(height: 12),
              ],
              _Bulb(color: PaceColors.stageGreen, lit: _go, size: 34),
            ],
          ),
        ),
        // Only reserve space for GO! once it actually fires — otherwise the
        // invisible label adds dead padding under the tree.
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: _go
              ? Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'GO!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 3,
                      color: PaceColors.neonLimeBright,
                      shadows: [
                        const Shadow(color: PaceColors.neonLime, blurRadius: 24),
                        Shadow(
                          color: PaceColors.neonLime.withValues(alpha: 0.6),
                          blurRadius: 48,
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}

class _Bulb extends StatelessWidget {
  const _Bulb({required this.color, required this.lit, required this.size});

  final Color color;
  final bool lit;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dim = Color.lerp(color, Colors.black, 0.82)!;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 110),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: lit ? color : dim,
        gradient: lit
            ? RadialGradient(
                colors: [Colors.white.withValues(alpha: 0.7), color],
                stops: const [0.0, 0.6],
                center: const Alignment(-0.3, -0.3),
              )
            : null,
        boxShadow: lit
            ? [
                BoxShadow(color: color.withValues(alpha: 0.9), blurRadius: 18),
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 34,
                  spreadRadius: 2,
                ),
              ]
            : null,
        border: Border.all(color: Colors.black.withValues(alpha: 0.6), width: 2),
      ),
    );
  }
}
