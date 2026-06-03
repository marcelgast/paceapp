import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/stint_calculator.dart';
import '../../providers.dart';
import '../../services/notification_service.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../util/format.dart';
import '../../widgets/pace_wordmark.dart';
import 'pit_stop_sheet.dart';
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

  Future<void> _pitStop() async {
    final stint = ref.read(liveStintProvider);
    final forwardTarget = ref.read(targetIntervalProvider);
    final settings = ref.read(settingsProvider).value;
    HapticFeedback.selectionClick();
    final draft = await showPitStopSheet(context);
    if (draft == null) return;

    final now = DateTime.now();
    final wasEarly = stint?.phase == StintPhase.countdown;
    final target = stint?.target;
    await ref.read(databaseProvider).addPitStop(
          occurredAt: now,
          cravingLevel: draft.cravingLevel,
          stressLevel: draft.stressLevel,
          situationId: draft.situationId,
          wasEarlyPit: wasEarly,
          targetIntervalSeconds:
              (target != null && target > Duration.zero) ? target.inSeconds : null,
          note: draft.note,
        );
    HapticFeedback.mediumImpact();

    // Schedule the "stint complete" nudge for the new stint (skip baseline).
    final inBaseline = settings != null &&
        now.difference(settings.startedAt) < StintCalculator.baselineDuration;
    if (!inBaseline && forwardTarget != null && forwardTarget > Duration.zero) {
      await NotificationService.scheduleStintComplete(now.add(forwardTarget));
    }
  }

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
                    Text(
                      'P1',
                      style: PaceTheme.dash(
                          size: 20, color: PaceColors.neonCyan, italic: true),
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
                        target: ref.watch(targetIntervalProvider)),
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
  const _Gauge({required this.stint, required this.target});

  final StintState? stint;
  final Duration? target;

  @override
  Widget build(BuildContext context) {
    final phase = stint?.phase ?? StintPhase.baseline;
    final progress = stint?.progress ?? 0;

    final (String label, String time, String sub, Color color) =
        switch (phase) {
      StintPhase.baseline => (
          'MESSRUNDE',
          formatStintDuration(stint?.elapsed ?? Duration.zero),
          'Woche 1 — wir messen nur dein Tempo',
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
          'geschenkte Zeit — du fährst vorne!',
          PaceColors.neonLime,
        ),
    };

    Widget gauge = Tachometer(
      progress: progress,
      phase: phase,
      size: 280,
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
