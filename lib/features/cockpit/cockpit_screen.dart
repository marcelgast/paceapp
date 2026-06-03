import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/stint_calculator.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../util/format.dart';
import '../../widgets/pace_wordmark.dart';
import '../settings/settings_screen.dart';
import '../sos/breathing_screen.dart';
import 'pit_stop_action.dart';
import 'tachometer.dart';

class CockpitScreen extends ConsumerStatefulWidget {
  const CockpitScreen({super.key});

  @override
  ConsumerState<CockpitScreen> createState() => _CockpitScreenState();
}

class _CockpitScreenState extends ConsumerState<CockpitScreen> {
  late final ConfettiController _win =
      ConfettiController(duration: const Duration(milliseconds: 1500));

  @override
  void dispose() {
    _win.dispose();
    super.dispose();
  }

  Future<void> _pitStop() => recordPitStop(context, ref);

  @override
  Widget build(BuildContext context) {
    ref.listen<StintState?>(liveStintProvider, (prev, next) {
      if (prev?.phase != StintPhase.overtime &&
          next?.phase == StintPhase.overtime) {
        _win.play();
        HapticFeedback.heavyImpact();
      }
    });

    final settings = ref.watch(settingsProvider).value;
    final stint = ref.watch(liveStintProvider);
    final stats = ref.watch(statsProvider);
    final currency = settings?.currencyCode ?? 'EUR';
    final now = ref.watch(clockProvider).value ?? DateTime.now();

    // Days left in the measuring round (shown under the baseline gauge).
    var baselineSub = 'Wir messen dein Tempo';
    if (settings != null) {
      final end = settings.startedAt.add(StintCalculator.baselineDuration);
      final daysLeft = DateTime(end.year, end.month, end.day)
          .difference(DateTime(now.year, now.month, now.day))
          .inDays;
      baselineSub = daysLeft <= 0
          ? 'endet heute'
          : daysLeft == 1
              ? 'endet morgen'
              : 'noch $daysLeft Tage';
    }

    return Scaffold(
      body: RacetrackBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const PaceWordmark(size: 30),
                    Row(
                      children: [
                        _SettingsButton(
                            onTap: () => SettingsScreen.open(context)),
                        const SizedBox(width: 8),
                        _StreakChip(days: ref.watch(streakProvider).current),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _StatsRow(stats: stats, currency: currency),
                const Spacer(),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    _Gauge(
                        stint: stint,
                        target: ref.watch(targetIntervalProvider),
                        baselineSub: baselineSub),
                    ConfettiWidget(
                      confettiController: _win,
                      blastDirectionality: BlastDirectionality.explosive,
                      numberOfParticles: 18,
                      maxBlastForce: 18,
                      minBlastForce: 6,
                      gravity: 0.3,
                      emissionFrequency: 0.05,
                      colors: const [
                        PaceColors.neonLime,
                        PaceColors.neonCyan,
                        PaceColors.neonMagenta,
                        PaceColors.neonOrange,
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                _SosButton(onTap: () => BreathingScreen.open(context)),
                const SizedBox(height: 12),
                _PitButton(onTap: _pitStop),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats, required this.currency});

  final dynamic stats; // PaceStats?
  final String currency;

  @override
  Widget build(BuildContext context) {
    final saved = stats == null
        ? '—'
        : formatMoneyCents(stats.savedMoneyCents, currencyCode: currency);
    final avoided =
        stats == null ? '—' : stats.savedCigarettes.floor().toString();
    final clean =
        stats == null ? '—' : formatHumanDuration(stats.sinceStart);

    return Row(
      children: [
        _Kpi(label: 'Gespart', value: saved, color: PaceColors.neonLime),
        const SizedBox(width: 12),
        _Kpi(label: 'Vermieden', value: avoided, color: PaceColors.neonCyan),
        const SizedBox(width: 12),
        _Kpi(label: 'Im Rennen', value: clean, color: PaceColors.neonOrange),
      ],
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: PaceColors.panel.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PaceColors.chrome.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: PaceTheme.dash(size: 22, color: color),
            ),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(color: PaceColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _Gauge extends StatelessWidget {
  const _Gauge(
      {required this.stint, required this.target, required this.baselineSub});

  final StintState? stint;
  final Duration? target;
  final String baselineSub;

  @override
  Widget build(BuildContext context) {
    final phase = stint?.phase ?? StintPhase.baseline;
    final progress = stint?.progress ?? 0;

    // Hybrid second lap: in overtime a green bar runs again toward the target.
    var overtimeProgress = 0.0;
    var bonusLap = 0;
    if (phase == StintPhase.overtime &&
        target != null &&
        target!.inSeconds > 0) {
      final ot = (stint?.overtime ?? Duration.zero).inSeconds;
      final tgt = target!.inSeconds;
      bonusLap = ot ~/ tgt;
      overtimeProgress = (ot % tgt) / tgt;
    }

    final (String label, String time, String sub, Color color) =
        switch (phase) {
      StintPhase.baseline => (
          'MESSRUNDE',
          formatStintDuration(stint?.elapsed ?? Duration.zero),
          baselineSub,
          PaceColors.textMuted,
        ),
      StintPhase.countdown => (
          'NÄCHSTER STINT',
          formatStintDuration(stint?.remaining ?? Duration.zero),
          target == null ? '' : 'Ziel: ${formatHumanDuration(target!)}',
          PaceColors.neonCyan,
        ),
      StintPhase.overtime => (
          'OVERTIME',
          formatStintDuration(stint?.overtime ?? Duration.zero),
          bonusLap >= 1
              ? 'Bonus-Runde ${bonusLap + 1} — du fährst vorne! 🔥'
              : 'geschenkte Zeit — du fährst vorne!',
          PaceColors.neonLime,
        ),
    };

    Widget gauge = Tachometer(
      progress: progress,
      overtimeProgress: overtimeProgress,
      phase: phase,
      size: 290,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2)),
          const SizedBox(height: 8),
          Text(
            time,
            style: PaceTheme.dash(size: 56, weight: FontWeight.w800, color: color)
                .copyWith(shadows: PaceTheme.neonGlow(color, blur: 14)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 170,
            child: Text(sub,
                textAlign: TextAlign.center,
                style: TextStyle(color: PaceColors.textMuted, fontSize: 12)),
          ),
        ],
      ),
    );

    if (phase == StintPhase.overtime) {
      gauge = gauge
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scaleXY(begin: 1.0, end: 1.03, duration: 900.ms, curve: Curves.easeInOut);
    }
    return gauge;
  }
}

class _PitButton extends StatelessWidget {
  const _PitButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 72,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: PaceColors.underglow),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: PaceColors.neonMagenta.withValues(alpha: 0.5),
              blurRadius: 28,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_fire_department, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('BOXENSTOPP',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5)),
                Text('Zigarette geraucht  ·  +1',
                    style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 2600.ms, color: Colors.white.withValues(alpha: 0.18));
  }
}

class _SosButton extends StatelessWidget {
  const _SosButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: PaceColors.neonCyan.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PaceColors.neonCyan.withValues(alpha: 0.7)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.air, color: PaceColors.neonCyan, size: 22),
            SizedBox(width: 10),
            Text('VERLANGEN? DURCHATMEN',
                style: TextStyle(
                    color: PaceColors.neonCyan,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}

class _SettingsButton extends StatelessWidget {
  const _SettingsButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: PaceColors.panel.withValues(alpha: 0.7),
          shape: BoxShape.circle,
          border: Border.all(color: PaceColors.chrome.withValues(alpha: 0.6)),
        ),
        child: const Icon(Icons.settings_outlined,
            color: PaceColors.textMuted, size: 19),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final active = days > 0;
    final color = active ? PaceColors.neonOrange : PaceColors.textFaint;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: active ? 0.16 : 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: color, size: 16),
          const SizedBox(width: 4),
          Text(active ? '$days ${days == 1 ? 'Tag' : 'Tage'}' : 'Streak',
              style: PaceTheme.dash(size: 16, color: color)),
        ],
      ),
    );
  }
}
