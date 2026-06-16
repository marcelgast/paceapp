import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/behavior_analysis.dart';
import '../../domain/deep_analytics.dart';
import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../services/entitlements.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';
import '../race_engineer/race_engineer_screen.dart';

class AnalysisScreen extends ConsumerWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final a = ref.watch(behaviorAnalysisProvider);
    final l10n = AppLocalizations.of(context);

    // Race Engineer (Pro) lives right here on the analytics page when unlocked.
    final isPro = ref.watch(entitlementsProvider).can(PaceProFeature.raceEngineer);
    final pitStops = ref.watch(pitStopsProvider).value ?? const [];
    final labels = ref.watch(situationLabelsProvider);
    final deep = (isPro && a.total > 0)
        ? DeepAnalytics.from(
            pitStops
                .map((p) => PitSample(
                      occurredAt: p.occurredAt,
                      craving: p.cravingLevel,
                      stress: p.stressLevel,
                      situationId: p.situationId,
                      wasEarly: p.wasEarlyPit,
                    ))
                .toList(),
            labels: labels,
            now: DateTime.now(),
            noSituationLabel: l10n.analysisNoSituation,
          )
        : null;

    return Scaffold(
      body: RacetrackBackground(
        child: SafeArea(
          child: a.total == 0
              ? const _EmptyState()
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  children: [
                    GraffitiHeadline(l10n.analysisTitle, size: 26),
                    const SizedBox(height: 16),
                    _MedianPaceCard(
                        pace: a.medianPace, prev: a.previousMedianPace),
                    const SizedBox(height: 16),
                    _SummaryRow(a: a),
                    const SizedBox(height: 28),
                    _SectionLabel(l10n.analysisTriggers),
                    const SizedBox(height: 12),
                    _SituationBars(a: a),
                    const SizedBox(height: 28),
                    _SectionLabel(l10n.analysisLast7Days),
                    const SizedBox(height: 12),
                    _WeekBars(a: a),
                    if (deep != null) ...[
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          _SectionLabel(l10n.raceEngineerTitle),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: PaceColors.neonMagenta,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(l10n.proBadge,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RaceEngineerSection(analytics: deep),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}

class _MedianPaceCard extends StatelessWidget {
  const _MedianPaceCard({required this.pace, required this.prev});

  final Duration? pace;
  final Duration? prev;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final has = pace != null;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        color: PaceColors.panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PaceColors.neonCyan.withValues(alpha: 0.7)),
        boxShadow: [
          BoxShadow(
              color: PaceColors.neonCyan.withValues(alpha: 0.18), blurRadius: 22),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.speed, color: PaceColors.neonCyan, size: 18),
              const SizedBox(width: 6),
              Text(l10n.analysisMedianPace,
                  style: TextStyle(
                      color: PaceColors.neonCyan,
                      fontSize: 12,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  has
                      ? l10n.analysisEvery(formatHumanDuration(pace!))
                      : l10n.analysisCollecting,
                  style: PaceTheme.dash(
                      size: has ? 38 : 26,
                      weight: FontWeight.w900,
                      color: has ? Colors.white : PaceColors.textMuted),
                ),
              ),
              if (has && prev != null) ...[
                const SizedBox(width: 10),
                _TrendChip(delta: pace! - prev!),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            has ? l10n.analysisMedianHint : l10n.analysisMedianEmptyHint,
            style: TextStyle(color: PaceColors.textMuted, fontSize: 13, height: 1.3),
          ),
        ],
      ),
    );
  }
}

class _TrendChip extends StatelessWidget {
  const _TrendChip({required this.delta});

  final Duration delta;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final flat = delta.inMinutes.abs() < 1;
    final up = delta.inSeconds > 0;
    final color = flat
        ? PaceColors.textMuted
        : (up ? PaceColors.neonLime : PaceColors.neonOrange);
    final label = flat
        ? l10n.analysisSameAsLastWeek
        : '${up ? '▲' : '▼'} ${formatHumanDuration(delta.abs())}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w800)),
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

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.a});
  final BehaviorAnalysis a;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Row(
      children: [
        _StatTile(
            label: l10n.analysisAvgCraving,
            value: a.avgCraving.toStringAsFixed(1),
            color: PaceColors.neonMagenta),
        const SizedBox(width: 12),
        _StatTile(
            label: l10n.analysisAvgStress,
            value: a.avgStress.toStringAsFixed(1),
            color: PaceColors.neonOrange),
        const SizedBox(width: 12),
        _StatTile(
            label: l10n.analysisSpins,
            value: '${(a.earlyRate * 100).round()}%',
            color: PaceColors.neonCyan),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: PaceColors.panel.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PaceColors.chrome.withValues(alpha: 0.5)),
        ),
        child: Column(
          children: [
            Text(value, style: PaceTheme.dash(size: 26, color: color)),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(color: PaceColors.textMuted, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _SituationBars extends StatelessWidget {
  const _SituationBars({required this.a});
  final BehaviorAnalysis a;

  @override
  Widget build(BuildContext context) {
    final max = a.bySituation.first.count;
    return Column(
      children: [
        for (final s in a.bySituation)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SizedBox(
                  width: 96,
                  child: Text(s.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: PaceColors.textPrimary, fontSize: 13)),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Stack(
                      children: [
                        Container(height: 22, color: PaceColors.night),
                        FractionallySizedBox(
                          widthFactor: max == 0 ? 0 : s.count / max,
                          child: Container(
                            height: 22,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  PaceColors.neonMagenta,
                                  PaceColors.neonPurple
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 24,
                  child: Text('${s.count}',
                      textAlign: TextAlign.right,
                      style: PaceTheme.dash(size: 18, color: PaceColors.neonMagenta)),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _WeekBars extends StatelessWidget {
  const _WeekBars({required this.a});
  final BehaviorAnalysis a;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final letters = [
      l10n.analysisWeekdayMon,
      l10n.analysisWeekdayTue,
      l10n.analysisWeekdayWed,
      l10n.analysisWeekdayThu,
      l10n.analysisWeekdayFri,
      l10n.analysisWeekdaySat,
      l10n.analysisWeekdaySun,
    ];
    final max = a.last7Days.fold<int>(1, (m, d) => d.count > m ? d.count : m);
    return Container(
      height: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PaceColors.panel.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PaceColors.chrome.withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final d in a.last7Days)
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('${d.count}',
                      style: const TextStyle(
                          color: PaceColors.textMuted, fontSize: 11)),
                  const SizedBox(height: 4),
                  Container(
                    height: (d.count / max) * 80 + 4,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [PaceColors.neonCyan, PaceColors.neonLime],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(letters[d.day.weekday - 1],
                      style: const TextStyle(
                          color: PaceColors.textFaint, fontSize: 11)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.insights, color: PaceColors.neonCyan, size: 56),
            const SizedBox(height: 16),
            Text(l10n.analysisEmptyTitle,
                style: PaceTheme.dash(size: 24, italic: true)),
            const SizedBox(height: 8),
            Text(
              l10n.analysisEmptyBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: PaceColors.textMuted, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
