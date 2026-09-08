import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/quit_plan.dart';
import '../../domain/stint_calculator.dart';
import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';
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
  late final ConfettiController _win = ConfettiController(
    duration: const Duration(milliseconds: 1500),
  );

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
    // Reward every new smoke-free day (and the quit-day start itself).
    ref.listen(quitPlanProvider.select((p) => p.dayNumber), (prev, next) {
      if ((prev ?? 0) < next && next >= 1) {
        _win.play();
        HapticFeedback.heavyImpact();
      }
    });

    final l10n = AppLocalizations.of(context);
    final settings = ref.watch(settingsProvider).value;
    final stint = ref.watch(liveStintProvider);
    final stats = ref.watch(statsProvider);
    final currency = settings?.currencyCode ?? 'EUR';
    final now = ref.watch(clockProvider).value ?? DateTime.now();
    final quitPlan = ref.watch(quitPlanProvider);

    // Days left in the measuring round (shown under the baseline gauge).
    var baselineSub = l10n.cockpitBaselineMeasuring;
    if (settings != null) {
      final end = settings.startedAt.add(StintCalculator.baselineDuration);
      final daysLeft = DateTime(
        end.year,
        end.month,
        end.day,
      ).difference(DateTime(now.year, now.month, now.day)).inDays;
      baselineSub = daysLeft <= 0
          ? l10n.cockpitBaselineEndsToday
          : daysLeft == 1
          ? l10n.cockpitBaselineEndsTomorrow
          : l10n.cockpitBaselineDaysLeft(daysLeft.toString());
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
                          onTap: () => SettingsScreen.open(context),
                        ),
                        const SizedBox(width: 8),
                        _StreakChip(days: ref.watch(streakProvider).current),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _StatsRow(stats: stats, currency: currency),
                if (quitPlan.isCountdown) ...[
                  const SizedBox(height: 12),
                  _QuitCountdownBanner(daysUntil: quitPlan.daysUntil),
                ],
                const Spacer(),
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    if (quitPlan.isSmokeFree)
                      _SmokeFreeHero(plan: quitPlan)
                    else
                      _Gauge(
                        stint: stint,
                        target: ref.watch(targetIntervalProvider),
                        baselineSub: baselineSub,
                      ),
                    ConfettiWidget(
                      confettiController: _win,
                      blastDirectionality: BlastDirectionality.explosive,
                      numberOfParticles: 22,
                      maxBlastForce: 20,
                      minBlastForce: 6,
                      gravity: 0.3,
                      emissionFrequency: 0.05,
                      colors: [
                        PaceColors.neonLime,
                        PaceColors.neonCyan,
                        PaceColors.neonMagenta,
                        PaceColors.neonOrange,
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                if (quitPlan.isSmokeFree) ...[
                  _BreathingPrimaryButton(
                    onTap: () => BreathingScreen.open(context),
                  ),
                  const SizedBox(height: 12),
                  _RelapsePitButton(onTap: _pitStop),
                ] else ...[
                  _SosButton(onTap: () => BreathingScreen.open(context)),
                  const SizedBox(height: 12),
                  _PitButton(onTap: _pitStop),
                ],
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
    final l10n = AppLocalizations.of(context);
    final saved = stats == null
        ? '—'
        : formatMoneyCents(stats.savedMoneyCents, currencyCode: currency);
    final avoided = stats == null
        ? '—'
        : stats.savedCigarettes.floor().toString();
    final clean = stats == null ? '—' : formatHumanDuration(stats.sinceStart);

    return Row(
      children: [
        _Kpi(
          label: l10n.cockpitStatSaved,
          value: saved,
          color: PaceColors.neonLime,
        ),
        const SizedBox(width: 12),
        _Kpi(
          label: l10n.cockpitStatAvoided,
          value: avoided,
          color: PaceColors.neonCyan,
        ),
        const SizedBox(width: 12),
        _Kpi(
          label: l10n.cockpitStatInRace,
          value: clean,
          color: PaceColors.neonOrange,
        ),
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
            Text(
              label,
              style: TextStyle(color: PaceColors.textMuted, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _Gauge extends StatelessWidget {
  const _Gauge({
    required this.stint,
    required this.target,
    required this.baselineSub,
  });

  final StintState? stint;
  final Duration? target;
  final String baselineSub;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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

    final (
      String label,
      String time,
      String sub,
      Color color,
    ) = switch (phase) {
      StintPhase.baseline => (
        l10n.cockpitGaugeMeasuringLap,
        formatStintDuration(stint?.elapsed ?? Duration.zero),
        baselineSub,
        PaceColors.textMuted,
      ),
      StintPhase.countdown => (
        l10n.cockpitGaugeNextStint,
        formatStintDuration(stint?.remaining ?? Duration.zero),
        target == null
            ? ''
            : l10n.cockpitGaugeTarget(formatHumanDuration(target!)),
        PaceColors.neonCyan,
      ),
      StintPhase.overtime => (
        l10n.cockpitGaugeOvertime,
        formatStintDuration(stint?.overtime ?? Duration.zero),
        bonusLap >= 1
            ? l10n.cockpitGaugeBonusLap((bonusLap + 1).toString())
            : l10n.cockpitGaugeBonusTime,
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
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            time,
            style: PaceTheme.dash(
              size: 56,
              weight: FontWeight.w800,
              color: color,
            ).copyWith(shadows: PaceTheme.neonGlow(color, blur: 14)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 170,
            child: Text(
              sub,
              textAlign: TextAlign.center,
              style: TextStyle(color: PaceColors.textMuted, fontSize: 12),
            ),
          ),
        ],
      ),
    );

    if (phase == StintPhase.overtime) {
      gauge = gauge
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scaleXY(
            begin: 1.0,
            end: 1.03,
            duration: 900.ms,
            curve: Curves.easeInOut,
          );
    }
    return gauge;
  }
}

class _PitButton extends StatelessWidget {
  const _PitButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: PaceColors.underglow),
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
                const Icon(
                  Icons.local_fire_department,
                  color: Colors.white,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.cockpitPitButtonTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      l10n.cockpitPitButtonSubtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 2600.ms,
          color: Colors.white.withValues(alpha: 0.18),
        );
  }
}

class _SosButton extends StatelessWidget {
  const _SosButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.air, color: PaceColors.neonCyan, size: 22),
            const SizedBox(width: 10),
            Text(
              l10n.cockpitSosButton,
              style: TextStyle(
                color: PaceColors.neonCyan,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
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
        child: const Icon(
          Icons.settings_outlined,
          color: PaceColors.textMuted,
          size: 19,
        ),
      ),
    );
  }
}

class _QuitCountdownBanner extends StatelessWidget {
  const _QuitCountdownBanner({required this.daysUntil});

  final int daysUntil;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = daysUntil <= 0
        ? l10n.quitCountdownToday
        : daysUntil == 1
        ? l10n.quitCountdownTomorrow
        : l10n.quitCountdownDays(daysUntil.toString());
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PaceColors.neonCyan.withValues(alpha: 0.14),
            PaceColors.neonLime.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PaceColors.neonCyan.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.flag_rounded, color: PaceColors.neonCyan, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.quitCountdownLabel,
                  style: TextStyle(
                    color: PaceColors.textMuted,
                    fontSize: 11,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  text,
                  style: const TextStyle(
                    color: PaceColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmokeFreeHero extends StatelessWidget {
  const _SmokeFreeHero({required this.plan});

  final QuitPlan plan;

  static String _hms(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final day = plan.dayNumber;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.sports_score, color: PaceColors.neonLime, size: 58)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scaleXY(
              begin: 1.0,
              end: 1.1,
              duration: 1100.ms,
              curve: Curves.easeInOut,
            ),
        const SizedBox(height: 12),
        Text(
          l10n.smokeFreeRaceKicker,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: PaceColors.neonLime,
            fontSize: 13,
            letterSpacing: 3,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        GraffitiHeadline(day.toString(), size: 82, color: Colors.white)
            .animate(key: ValueKey(day))
            .scaleXY(
              begin: 0.8,
              end: 1.0,
              curve: Curves.easeOutBack,
              duration: 520.ms,
            ),
        Text(
          '${l10n.smokeFreeDaysWord(day)} ${l10n.smokeFreeFreeWord}',
          style: TextStyle(
            color: PaceColors.neonLime,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: PaceColors.panel.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: PaceColors.neonCyan.withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            _hms(plan.intraDay),
            style: PaceTheme.dash(size: 24, color: PaceColors.neonCyan),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            l10n.smokeFreeEncouragement,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: PaceColors.textMuted,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ),
      ],
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _BreathingPrimaryButton extends StatelessWidget {
  const _BreathingPrimaryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [PaceColors.neonCyan, PaceColors.neonLime],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: PaceColors.neonCyan.withValues(alpha: 0.45),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.air, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.cockpitBreathePrimaryTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      l10n.cockpitBreathePrimarySub,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(duration: 2600.ms, color: Colors.white.withValues(alpha: 0.2));
  }
}

class _RelapsePitButton extends StatelessWidget {
  const _RelapsePitButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: PaceColors.panel.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: PaceColors.chrome.withValues(alpha: 0.6)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_fire_department,
              color: PaceColors.textMuted,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.cockpitRelapse,
              style: TextStyle(
                color: PaceColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakChip extends StatelessWidget {
  const _StreakChip({required this.days});

  final int days;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          Text(
            active
                ? (days == 1
                      ? l10n.cockpitStreakDay(days.toString())
                      : l10n.cockpitStreakDays(days.toString()))
                : l10n.cockpitStreakLabel,
            style: PaceTheme.dash(size: 16, color: color),
          ),
        ],
      ),
    );
  }
}
