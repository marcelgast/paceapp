import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/recovery.dart';
import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/racetrack_background.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';

class RecoveryScreen extends ConsumerWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Wall-clock since the last cigarette — the body heals during sleep too,
    // so this is not the awake-only stint time.
    final clean = ref.watch(wallClockSinceLastPitProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: RacetrackBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              GraffitiHeadline(l10n.recoveryTitle, size: 30),
              const SizedBox(height: 6),
              Text(l10n.recoverySubtitle,
                  style: TextStyle(color: PaceColors.textMuted, fontSize: 14)),
              const SizedBox(height: 22),
              _SectionLabel(l10n.recoveryEveryStintHeals),
              const SizedBox(height: 4),
              Text(l10n.recoveryCurrentStint(formatHumanDuration(clean)),
                  style: const TextStyle(
                      color: PaceColors.neonCyan,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              for (final m in kStintRecovery)
                _StintRow(marker: m, clean: clean),
              const SizedBox(height: 26),
              _SectionLabel(l10n.recoveryLongTerm),
              const SizedBox(height: 12),
              for (final m in kLongTermRecovery) _LongTermRow(marker: m),
              const SizedBox(height: 20),
              Text(
                l10n.recoverySources,
                style: TextStyle(color: PaceColors.textFaint, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text.toUpperCase(),
        style: const TextStyle(
            color: PaceColors.textMuted,
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w700));
  }
}

class _StintRow extends StatelessWidget {
  const _StintRow({required this.marker, required this.clean});

  final RecoveryMarker marker;
  final Duration clean;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final target = marker.stintTime!;
    final reached = clean >= target;
    final progress =
        (clean.inSeconds / target.inSeconds).clamp(0.0, 1.0).toDouble();
    final color = reached ? PaceColors.neonLime : PaceColors.neonCyan;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PaceColors.panel.withValues(alpha: reached ? 0.9 : 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: reached
                ? PaceColors.neonLime.withValues(alpha: 0.5)
                : PaceColors.chrome.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 38,
            height: 38,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 3,
                  backgroundColor: PaceColors.panelLight,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
                if (reached)
                  const Icon(Icons.check, color: PaceColors.neonLime, size: 18),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(marker.localizedTitle(lang),
                        style: const TextStyle(
                            color: PaceColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(width: 8),
                    Text(marker.localizedTimeLabel(lang),
                        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(marker.localizedDetail(lang),
                    style: TextStyle(
                        color: PaceColors.textMuted, fontSize: 13, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LongTermRow extends StatelessWidget {
  const _LongTermRow({required this.marker});

  final RecoveryMarker marker;

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PaceColors.panel.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: PaceColors.chrome.withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: PaceColors.neonPurple.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(marker.localizedTimeLabel(lang),
                style: const TextStyle(
                    color: PaceColors.neonPurple,
                    fontSize: 11,
                    fontWeight: FontWeight.w800)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(marker.localizedTitle(lang),
                    style: const TextStyle(
                        color: PaceColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(marker.localizedDetail(lang),
                    style: TextStyle(
                        color: PaceColors.textMuted, fontSize: 13, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
