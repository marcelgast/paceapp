import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';

/// Savings goals: name a reward, set its price, and watch your saved money fill
/// it up. Progress is the cumulative money not spent on cigarettes.
class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  Future<void> _addGoal(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddGoalSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final goals = ref.watch(savingsGoalsProvider).value ?? const [];
    final stats = ref.watch(statsProvider);
    final savedCents = stats?.savedMoneyCents ?? 0;
    final currency =
        ref.watch(settingsProvider).value?.currencyCode ?? 'EUR';

    return Scaffold(
      body: RacetrackBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Row(
                  children: [
                    Expanded(child: GraffitiHeadline(l10n.goalsTitle, size: 26)),
                    _AddButton(onTap: () => _addGoal(context, ref)),
                  ],
                ),
              ),
              if (goals.isEmpty)
                Expanded(child: _EmptyState(onAdd: () => _addGoal(context, ref)))
              else
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    children: [
                      Text(l10n.goalsSavedPool(
                          formatMoneyCents(savedCents, currencyCode: currency)),
                          style: TextStyle(
                              color: PaceColors.textMuted, fontSize: 13)),
                      const SizedBox(height: 14),
                      for (final g in goals)
                        _GoalCard(
                          goal: g,
                          savedCents: savedCents,
                          currency: currency,
                          onDelete: () => ref
                              .read(databaseProvider)
                              .deleteSavingsGoal(g.id),
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

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    required this.savedCents,
    required this.currency,
    required this.onDelete,
  });

  final SavingsGoal goal;
  final int savedCents;
  final String currency;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final reached = savedCents >= goal.priceCents;
    final progress =
        goal.priceCents <= 0 ? 1.0 : (savedCents / goal.priceCents).clamp(0.0, 1.0);
    final pct = (progress * 100).round();
    final accent = reached ? PaceColors.neonLime : PaceColors.neonCyan;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PaceColors.panel.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: reached ? 0.6 : 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(goal.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: PaceColors.textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
              ),
              if (reached)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: PaceColors.neonLime,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(l10n.goalsReachedBadge,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 11,
                          fontWeight: FontWeight.w900)),
                ),
              GestureDetector(
                onTap: onDelete,
                behavior: HitTestBehavior.opaque,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.close,
                      color: PaceColors.textFaint, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(height: 12, color: PaceColors.night),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        PaceColors.neonCyan,
                        accent,
                      ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${formatMoneyCents(savedCents.clamp(0, goal.priceCents), currencyCode: currency)} / ${formatMoneyCents(goal.priceCents, currencyCode: currency)}',
                style: TextStyle(color: PaceColors.textMuted, fontSize: 13),
              ),
              Text('$pct %',
                  style: PaceTheme.dash(size: 15, color: accent)),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddGoalSheet extends ConsumerStatefulWidget {
  const _AddGoalSheet();

  @override
  ConsumerState<_AddGoalSheet> createState() => _AddGoalSheetState();
}

class _AddGoalSheetState extends ConsumerState<_AddGoalSheet> {
  final _name = TextEditingController();
  final _price = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    super.dispose();
  }

  int? _priceCents() {
    final raw = _price.text.trim().replaceAll('.', '').replaceAll(',', '.');
    final value = double.tryParse(raw);
    if (value == null || value <= 0) return null;
    return (value * 100).round();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final cents = _priceCents();
    if (name.isEmpty || cents == null) return;
    await ref.read(databaseProvider).addSavingsGoal(name: name, priceCents: cents);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      decoration: const BoxDecoration(
        color: PaceColors.night,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: PaceColors.chrome,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(l10n.goalsAdd,
              style: const TextStyle(
                  color: PaceColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          _Field(
            controller: _name,
            label: l10n.goalsNameLabel,
            hint: l10n.goalsNameHint,
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 12),
          _Field(
            controller: _price,
            label: l10n.goalsPriceLabel,
            hint: '79,00',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _save,
            child: Container(
              height: 54,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: PaceColors.underglow),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(l10n.goalsSave,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: PaceColors.textMuted,
                fontSize: 12,
                letterSpacing: 1,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: keyboardType == TextInputType.text
              ? null
              : [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
          style: const TextStyle(
              color: PaceColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: PaceColors.textFaint),
            filled: true,
            fillColor: PaceColors.panel,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: PaceColors.chrome),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  BorderSide(color: PaceColors.chrome.withValues(alpha: 0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: PaceColors.neonCyan),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: PaceColors.underglow),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.savings_outlined, color: PaceColors.neonLime, size: 56),
            const SizedBox(height: 16),
            Text(l10n.goalsEmptyTitle,
                textAlign: TextAlign.center,
                style: PaceTheme.dash(size: 22, italic: true)),
            const SizedBox(height: 8),
            Text(l10n.goalsEmptyBody,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: PaceColors.textMuted, fontSize: 14, height: 1.4)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: PaceColors.underglow),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(l10n.goalsAdd,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
