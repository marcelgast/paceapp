import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../services/notification_service.dart';
import '../../theme/pace_colors.dart';
import '../../theme/racetrack_background.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';

/// Explains what setting a quit date means — honestly — and lets the user pick
/// (or change/remove) it. The honesty: stretching is the path, not the finish;
/// at some point the real step is to stop entirely, and a date makes it concrete.
class QuitDateScreen extends ConsumerWidget {
  const QuitDateScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const QuitDateScreen()),
    );
  }

  Future<void> _pick(BuildContext context, WidgetRef ref, DateTime? current) async {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? today.add(const Duration(days: 7)),
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
      helpText: l10n.quitPickDate,
    );
    if (picked == null) return;
    await ref.read(databaseProvider).setQuitDate(picked);
    await NotificationService.requestPermission();
    await NotificationService.scheduleQuitDay(
      quitDay: picked,
      dayBeforeTitle: l10n.notifQuitBeforeTitle,
      dayBeforeBody: l10n.notifQuitBeforeBody,
      dayTitle: l10n.notifQuitDayTitle,
      dayBody: l10n.notifQuitDayBody,
    );
  }

  Future<void> _remove(WidgetRef ref) async {
    await ref.read(databaseProvider).setQuitDate(null);
    await NotificationService.cancelQuitDay();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quitDate = ref.watch(settingsProvider).value?.quitDate;
    final triggers = ref
        .watch(behaviorAnalysisProvider)
        .bySituation
        .take(3)
        .map((s) => s.label)
        .toList();

    return Scaffold(
      body: RacetrackBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back,
                          color: PaceColors.textPrimary),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
                  children: [
                    GraffitiHeadline(l10n.quitTitle, size: 30),
                    const SizedBox(height: 18),
                    _Callout(
                      icon: Icons.flag_rounded,
                      accent: PaceColors.neonOrange,
                      title: l10n.quitHonestTitle,
                      body: l10n.quitHonestBody,
                    ),
                    const SizedBox(height: 14),
                    _Callout(
                      icon: Icons.shield_moon_outlined,
                      accent: PaceColors.neonCyan,
                      title: l10n.quitTriggersTitle,
                      body: triggers.isEmpty
                          ? l10n.quitTriggersBodyGeneric
                          : l10n.quitTriggersBody(triggers.join(', ')),
                      extra: l10n.quitTriggersTip,
                    ),
                    const SizedBox(height: 14),
                    _Callout(
                      icon: Icons.self_improvement,
                      accent: PaceColors.neonLime,
                      title: l10n.quitCompanionTitle,
                      body: l10n.quitCompanionBody,
                    ),
                    const SizedBox(height: 26),
                    if (quitDate != null) ...[
                      _CurrentDateCard(date: quitDate),
                      const SizedBox(height: 14),
                      _PrimaryButton(
                        label: l10n.quitChangeDate,
                        onTap: () => _pick(context, ref, quitDate),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: () => _remove(ref),
                          child: Text(l10n.quitRemoveDate,
                              style: TextStyle(
                                  color: PaceColors.neonOrange,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ] else
                      _PrimaryButton(
                        label: l10n.quitSetButton,
                        onTap: () => _pick(context, ref, null),
                      ),
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

class _Callout extends StatelessWidget {
  const _Callout({
    required this.icon,
    required this.accent,
    required this.title,
    required this.body,
    this.extra,
  });

  final IconData icon;
  final Color accent;
  final String title;
  final String body;
  final String? extra;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PaceColors.panel.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title,
                    style: const TextStyle(
                        color: PaceColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(body,
              style: TextStyle(
                  color: PaceColors.textMuted, fontSize: 14, height: 1.45)),
          if (extra != null) ...[
            const SizedBox(height: 8),
            Text(extra!,
                style: TextStyle(
                    color: accent,
                    fontSize: 13,
                    height: 1.4,
                    fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }
}

class _CurrentDateCard extends StatelessWidget {
  const _CurrentDateCard({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          PaceColors.neonLime.withValues(alpha: 0.14),
          PaceColors.neonCyan.withValues(alpha: 0.08),
        ]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PaceColors.neonLime.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.event_available, color: PaceColors.neonLime, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.quitYourDate,
                    style: TextStyle(
                        color: PaceColors.textMuted,
                        fontSize: 12,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(formatDate(date),
                    style: const TextStyle(
                        color: PaceColors.textPrimary,
                        fontSize: 19,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: PaceColors.underglow),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 1)),
      ),
    );
  }
}
