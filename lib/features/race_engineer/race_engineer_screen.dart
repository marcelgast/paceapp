import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/behavior_analysis.dart';
import '../../domain/deep_analytics.dart';
import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../widgets/graffiti_headline.dart';

/// "Race Engineer" — the Pro deep-analytics screen. When, where and how your
/// cravings hit, plus the long trend.
class RaceEngineerScreen extends ConsumerWidget {
  const RaceEngineerScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const RaceEngineerScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pitStops = ref.watch(pitStopsProvider).value ?? const [];
    final labels = ref.watch(situationLabelsProvider);
    final now = DateTime.now();

    final samples = pitStops
        .map((p) => PitSample(
              occurredAt: p.occurredAt,
              craving: p.cravingLevel,
              stress: p.stressLevel,
              situationId: p.situationId,
              wasEarly: p.wasEarlyPit,
            ))
        .toList();
    final a = DeepAnalytics.from(samples,
        labels: labels, now: now, noSituationLabel: l10n.analysisNoSituation);

    return Scaffold(
      body: RacetrackBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 20, 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back,
                          color: PaceColors.textMuted),
                    ),
                    GraffitiHeadline(l10n.raceEngineerTitle, size: 26),
                  ],
                ),
              ),
              Expanded(
                child: a.total == 0
                    ? _Empty(l10n: l10n)
                    : ListView(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
                        children: [
                          Text(l10n.raceEngineerSubtitle,
                              style: TextStyle(
                                  color: PaceColors.textMuted, fontSize: 14)),
                          const SizedBox(height: 20),
                          RaceEngineerSection(analytics: a),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The four deep-analytics cards as a reusable column — used both on the
/// standalone Race Engineer screen and embedded in the Analysis tab when Pro.
class RaceEngineerSection extends StatelessWidget {
  const RaceEngineerSection({super.key, required this.analytics});

  final DeepAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HourCard(analytics: analytics, l10n: l10n),
        const SizedBox(height: 16),
        _WeekdayCard(analytics: analytics, l10n: l10n),
        const SizedBox(height: 16),
        _TriggersCard(analytics: analytics, l10n: l10n),
        const SizedBox(height: 16),
        _TrendCard(analytics: analytics, l10n: l10n),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.child, this.caption});

  final String title;
  final Widget child;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PaceColors.panel.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PaceColors.chrome.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: PaceColors.textMuted,
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700)),
          if (caption != null) ...[
            const SizedBox(height: 4),
            Text(caption!,
                style: const TextStyle(
                    color: PaceColors.neonOrange,
                    fontSize: 14,
                    fontWeight: FontWeight.w700)),
          ],
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

/// A simple vertical bar with an optional highlight.
class _Bar extends StatelessWidget {
  const _Bar({required this.fraction, required this.highlight});

  final double fraction; // 0..1
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FractionallySizedBox(
              heightFactor: fraction.clamp(0.02, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: highlight
                      ? PaceColors.neonMagenta
                      : PaceColors.neonCyan.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HourCard extends StatelessWidget {
  const _HourCard({required this.analytics, required this.l10n});

  final DeepAnalytics analytics;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final maxV = analytics.byHour.reduce((a, b) => a > b ? a : b);
    return _Card(
      title: l10n.raceEngineerByHour,
      caption: analytics.peakHour >= 0
          ? l10n.raceEngineerPeakHour(analytics.peakHour)
          : null,
      child: Column(
        children: [
          SizedBox(
            height: 90,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var h = 0; h < 24; h++)
                  _Bar(
                    fraction: maxV == 0 ? 0 : analytics.byHour[h] / maxV,
                    highlight: h == analytics.peakHour,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final h in const [0, 6, 12, 18, 23])
                Text('$h',
                    style: TextStyle(
                        color: PaceColors.textFaint, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeekdayCard extends StatelessWidget {
  const _WeekdayCard({required this.analytics, required this.l10n});

  final DeepAnalytics analytics;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final maxV = analytics.byWeekday.reduce((a, b) => a > b ? a : b);
    final letters = [
      l10n.analysisWeekdayMon,
      l10n.analysisWeekdayTue,
      l10n.analysisWeekdayWed,
      l10n.analysisWeekdayThu,
      l10n.analysisWeekdayFri,
      l10n.analysisWeekdaySat,
      l10n.analysisWeekdaySun,
    ];
    return _Card(
      title: l10n.raceEngineerByWeekday,
      child: Column(
        children: [
          SizedBox(
            height: 80,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var d = 0; d < 7; d++)
                  _Bar(
                    fraction: maxV == 0 ? 0 : analytics.byWeekday[d] / maxV,
                    highlight: d == analytics.peakWeekday,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              for (var d = 0; d < 7; d++)
                Expanded(
                  child: Text(letters[d],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: d == analytics.peakWeekday
                              ? PaceColors.neonMagenta
                              : PaceColors.textFaint,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TriggersCard extends StatelessWidget {
  const _TriggersCard({required this.analytics, required this.l10n});

  final DeepAnalytics analytics;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final maxV = analytics.triggers.isEmpty
        ? 0
        : analytics.triggers.map((t) => t.count).reduce((a, b) => a > b ? a : b);
    return _Card(
      title: l10n.raceEngineerTriggers,
      child: Column(
        children: [
          for (final t in analytics.triggers)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(t.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: PaceColors.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: maxV == 0 ? 0 : t.count / maxV,
                        minHeight: 10,
                        backgroundColor: PaceColors.night,
                        valueColor: const AlwaysStoppedAnimation(
                            PaceColors.neonCyan),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('${t.count}',
                      style: PaceTheme.dash(size: 16, color: Colors.white)),
                  const SizedBox(width: 8),
                  Icon(Icons.local_fire_department,
                      color: PaceColors.neonMagenta
                          .withValues(alpha: 0.4 + t.avgCraving / 5 * 0.6),
                      size: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.analytics, required this.l10n});

  final DeepAnalytics analytics;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final trend = analytics.trend;
    final maxV = trend.isEmpty
        ? 0.0
        : trend.map((t) => t.cigarettesPerDay).reduce((a, b) => a > b ? a : b);
    final delta = trend.length >= 2
        ? trend.first.cigarettesPerDay - trend.last.cigarettesPerDay
        : 0.0;
    final caption = delta >= 0.3
        ? l10n.raceEngineerTrendDown(delta.toStringAsFixed(1))
        : l10n.raceEngineerTrendFlat;
    return _Card(
      title: l10n.raceEngineerTrend,
      caption: trend.length >= 2 ? caption : null,
      child: Column(
        children: [
          SizedBox(
            height: 70,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final t in trend)
                  _Bar(
                    fraction: maxV == 0 ? 0 : t.cigarettesPerDay / maxV,
                    highlight: t.weeksAgo == 0,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(l10n.raceEngineerTrendAxis,
              style: TextStyle(color: PaceColors.textFaint, fontSize: 10)),
        ],
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insights, color: PaceColors.neonCyan, size: 56),
            const SizedBox(height: 16),
            Text(l10n.raceEngineerEmptyTitle,
                style: PaceTheme.dash(size: 22, italic: true)),
            const SizedBox(height: 8),
            Text(l10n.raceEngineerEmptyBody,
                textAlign: TextAlign.center,
                style: TextStyle(color: PaceColors.textMuted, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
