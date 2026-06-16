import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';

/// Guided box-ish breathing for a craving: 4 s in, 4 s hold, 4 s out, looping.
/// No timer — the user stops when the urge passes.
class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => const BreathingScreen(),
      fullscreenDialog: true,
    ));
  }

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

enum _Phase { inhale, hold, exhale }

class _BreathingScreenState extends State<BreathingScreen>
    with SingleTickerProviderStateMixin {
  static const _cycle = Duration(seconds: 12); // 4 + 4 + 4
  late final AnimationController _c =
      AnimationController(vsync: this, duration: _cycle)..repeat();

  int _phaseIndex = -1;
  int _breaths = 0;

  @override
  void initState() {
    super.initState();
    _c.addListener(_onTick);
  }

  @override
  void dispose() {
    _c.removeListener(_onTick);
    _c.dispose();
    super.dispose();
  }

  void _onTick() {
    final p = _phaseFor(_c.value).index;
    if (p != _phaseIndex) {
      if (p == 0 && _phaseIndex == 2) _breaths++; // completed a full breath
      _phaseIndex = p;
      HapticFeedback.lightImpact();
      setState(() {});
    }
  }

  _Phase _phaseFor(double v) {
    if (v < 1 / 3) return _Phase.inhale;
    if (v < 2 / 3) return _Phase.hold;
    return _Phase.exhale;
  }

  /// Orb scale 0.55..1.0 across the cycle.
  double _scaleFor(double v) {
    if (v < 1 / 3) {
      return 0.55 + 0.45 * Curves.easeInOut.transform(v * 3);
    }
    if (v < 2 / 3) return 1.0;
    return 1.0 - 0.45 * Curves.easeInOut.transform((v - 2 / 3) * 3);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: PaceColors.nightDeep,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            final v = _c.value;
            final phase = _phaseFor(v);
            final scale = _scaleFor(v);
            final secondsLeft = (4 - (v * 12) % 4).ceil().clamp(1, 4);
            final (String label, Color color, IconData icon) = switch (phase) {
              _Phase.inhale => (l10n.sosInhale, PaceColors.neonCyan, Icons.arrow_upward_rounded),
              _Phase.hold => (l10n.sosHold, PaceColors.neonPurple, Icons.pause_rounded),
              _Phase.exhale => (l10n.sosExhale, PaceColors.neonLime, Icons.arrow_downward_rounded),
            };

            return Column(
              children: [
                const SizedBox(height: 12),
                Text(l10n.sosCravingPassing,
                    style: TextStyle(
                        color: PaceColors.textMuted,
                        fontSize: 12,
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(l10n.sosBreatheAlong,
                    style: TextStyle(color: PaceColors.textFaint, fontSize: 13)),
                Expanded(
                  child: Center(
                    child: _Orb(
                        scale: scale,
                        color: color,
                        label: label,
                        icon: icon,
                        seconds: secondsLeft),
                  ),
                ),
                Text(
                  _breaths == 0
                      ? l10n.sosNoBreathYet
                      : l10n.sosBreathsDone(_breaths.toString()),
                  style: TextStyle(color: PaceColors.textMuted, fontSize: 13),
                ),
                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: _StopButton(
                      onTap: () => Navigator.of(context).maybePop()),
                ),
                const SizedBox(height: 24),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({
    required this.scale,
    required this.color,
    required this.label,
    required this.icon,
    required this.seconds,
  });

  final double scale;
  final Color color;
  final String label;
  final IconData icon;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    const baseSize = 240.0;
    return SizedBox(
      width: baseSize + 60,
      height: baseSize + 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring that breathes with the orb.
          Transform.scale(
            scale: scale,
            child: Container(
              width: baseSize,
              height: baseSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  color.withValues(alpha: 0.35),
                  color.withValues(alpha: 0.04),
                ]),
                boxShadow: [
                  BoxShadow(
                      color: color.withValues(alpha: 0.45),
                      blurRadius: 60,
                      spreadRadius: 10),
                ],
              ),
            ),
          ),
          // Core orb.
          Transform.scale(
            scale: scale,
            child: Container(
              width: baseSize * 0.62,
              height: baseSize * 0.62,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.white.withValues(alpha: 0.9), color],
                  stops: const [0.0, 0.85],
                  center: const Alignment(-0.3, -0.3),
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
            ),
          ),
          // Static label + countdown on top (doesn't scale, stays readable).
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 6),
              Text(label,
                  style: PaceTheme.dash(
                      size: 30, weight: FontWeight.w800, color: Colors.white)),
              Text('$seconds',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  const _StopButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: PaceColors.panel,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PaceColors.neonLime, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(l10n.sosStopButton,
            style: TextStyle(
                color: PaceColors.neonLime,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5)),
      ),
    );
  }
}
