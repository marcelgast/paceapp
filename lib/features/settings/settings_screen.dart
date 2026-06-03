import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../services/widget_service.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';

/// Lets the user adjust the cigarette price and pack size. A change is recorded
/// as a new cost period effective now — past savings keep their old pricing.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
    );
  }

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _price = TextEditingController();
  final _perPack = TextEditingController();
  final _perDay = TextEditingController();
  bool _prefilled = false;
  bool _saving = false;

  @override
  void dispose() {
    _price.dispose();
    _perPack.dispose();
    _perDay.dispose();
    super.dispose();
  }

  int? _priceCents() {
    final raw = _price.text.trim().replaceAll('.', '').replaceAll(',', '.');
    final value = double.tryParse(raw);
    if (value == null || value <= 0) return null;
    return (value * 100).round();
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final cents = _priceCents();
    final perPack = int.tryParse(_perPack.text.trim()) ?? 0;
    final perDay = int.tryParse(_perDay.text.trim()) ?? 0;
    if (cents == null || perPack <= 0 || perDay <= 0) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Trag bitte gültige Werte ein.')),
      );
      return;
    }
    final settings = ref.read(settingsProvider).value;
    if (settings == null) return;

    final priceChanged = cents != settings.packPriceCents ||
        perPack != settings.cigarettesPerPack;
    final baselineChanged = perDay != settings.baselineCigsPerDay;
    if (!priceChanged && !baselineChanged) {
      navigator.pop();
      return;
    }

    // Changing the daily baseline shifts the whole reference — confirm it.
    if (baselineChanged) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: PaceColors.panel,
          title: const Text('Tageskonsum ändern?'),
          content: const Text(
            'Dein Tageskonsum ist die Vergleichsbasis. Ihn zu ändern '
            'verfälscht deine angezeigten Werte (Gespart, Vermieden) deutlich. '
            'Trotzdem speichern?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: PaceColors.neonMagenta,
                  foregroundColor: Colors.white),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Speichern'),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }

    setState(() => _saving = true);
    HapticFeedback.mediumImpact();
    final db = ref.read(databaseProvider);
    if (priceChanged) {
      await db.changeCostFrom(
        packPriceCents: cents,
        cigarettesPerPack: perPack,
        at: DateTime.now(),
      );
    }
    if (baselineChanged) {
      await db.updateBaseline(perDay);
    }
    await pushPaceWidget(ref);
    if (!mounted) return;
    navigator.pop();
    messenger.showSnackBar(
      const SnackBar(content: Text('Gespeichert.')),
    );
  }

  Future<void> _reset() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: PaceColors.panel,
        title: const Text('Alles zurücksetzen?'),
        content: const Text(
          'Alle Daten werden gelöscht: Einstellungen, Boxenstopps, Erfolge und '
          'Autos. Du startest wieder beim Welcome-Screen. Das lässt sich nicht '
          'rückgängig machen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: PaceColors.neonOrange,
                foregroundColor: Colors.black),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Zurücksetzen'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    HapticFeedback.heavyImpact();
    await ref.read(databaseProvider).resetEverything();
    // Settings stream goes null → the gate shows onboarding; drop this screen.
    if (mounted) Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider).value;
    final periods = ref.watch(costPeriodsProvider).value ?? const [];
    final currency = settings?.currencyCode ?? 'EUR';

    // Pre-fill once from the current values.
    if (!_prefilled && settings != null) {
      _price.text = (settings.packPriceCents / 100)
          .toStringAsFixed(2)
          .replaceAll('.', ',');
      _perPack.text = settings.cigarettesPerPack.toString();
      _perDay.text = settings.baselineCigsPerDay.toString();
      _prefilled = true;
    }

    return Scaffold(
      body: RacetrackBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back,
                          color: PaceColors.textMuted),
                    ),
                    const GraffitiHeadline('Einstellungen', size: 28),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  children: [
                    Text(
                      'Preis oder Packungsgröße geändert? Neue Werte gelten ab '
                      'jetzt — bisher Gespartes bleibt zum alten Preis erhalten.',
                      style: TextStyle(
                          color: PaceColors.textMuted,
                          fontSize: 14,
                          height: 1.4),
                    ),
                    const SizedBox(height: 22),
                    _Field(
                      label: 'Preis pro Schachtel',
                      controller: _price,
                      suffix: switch (currency) {
                        'USD' => '\$',
                        'GBP' => '£',
                        _ => '€',
                      },
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 16),
                    _Field(
                      label: 'Kippen pro Schachtel',
                      controller: _perPack,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _Field(
                      label: 'Kippen pro Tag (vorher)',
                      controller: _perDay,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Deine Vergleichsbasis. Ändern verfälscht Gespart & '
                      'Vermieden — nur korrigieren, wenn du dich vertippt hast.',
                      style: TextStyle(
                          color: PaceColors.textFaint,
                          fontSize: 12,
                          height: 1.35),
                    ),
                    const SizedBox(height: 24),
                    _SaveButton(saving: _saving, onTap: _saving ? null : _save),
                    if (periods.length > 1) ...[
                      const SizedBox(height: 32),
                      Text('VERLAUF',
                          style: TextStyle(
                              color: PaceColors.textMuted,
                              fontSize: 12,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      for (final p in periods.reversed)
                        _HistoryRow(period: p, currency: currency),
                    ],
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _reset,
                      child: Container(
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color:
                                  PaceColors.neonOrange.withValues(alpha: 0.7)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.restart_alt,
                                color: PaceColors.neonOrange, size: 20),
                            SizedBox(width: 8),
                            Text('ALLES ZURÜCKSETZEN',
                                style: TextStyle(
                                    color: PaceColors.neonOrange,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1)),
                          ],
                        ),
                      ),
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

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    required this.keyboardType,
    this.suffix,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(color: PaceColors.textMuted, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: PaceTheme.dash(size: 30, weight: FontWeight.w800),
          decoration: InputDecoration(
            filled: true,
            fillColor: PaceColors.panel.withValues(alpha: 0.85),
            suffixText: suffix,
            suffixStyle: PaceTheme.dash(size: 24, color: PaceColors.neonCyan),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide:
                  BorderSide(color: PaceColors.chrome.withValues(alpha: 0.6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: PaceColors.neonCyan, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.saving, required this.onTap});

  final bool saving;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: PaceColors.underglow),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: PaceColors.neonMagenta.withValues(alpha: 0.45),
                blurRadius: 22),
          ],
        ),
        alignment: Alignment.center,
        child: saving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : const Text('SPEICHERN',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2)),
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.period, required this.currency});

  final CostPeriod period;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final d = period.effectiveFrom;
    final date = '${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')}.${d.year}';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: PaceColors.panel.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PaceColors.chrome.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('seit $date',
              style: TextStyle(color: PaceColors.textMuted, fontSize: 13)),
          Text(
            '${formatMoneyCents(period.packPriceCents, currencyCode: currency)}'
            ' · ${period.cigarettesPerPack}/Schachtel',
            style: const TextStyle(
                color: PaceColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
