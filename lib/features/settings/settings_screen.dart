import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../services/widget_service.dart';
import '../quit/quit_date_screen.dart';
import '../race_engineer/race_engineer_screen.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../theme/skin.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';

/// Lets the user adjust the cigarette price and pack size. A change is recorded
/// as a new cost period effective now — past savings keep their old pricing.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const SettingsScreen()));
  }

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _price = TextEditingController();
  final _perPack = TextEditingController();
  final _perDay = TextEditingController();
  TimeOfDay _sleepStart = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _sleepEnd = const TimeOfDay(hour: 7, minute: 0);
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

  Future<void> _pickSleep({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _sleepStart : _sleepEnd,
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _sleepStart = picked;
      } else {
        _sleepEnd = picked;
      }
    });
  }

  Widget _sleepBox(String label, TimeOfDay time, VoidCallback onTap) {
    final value =
        '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: PaceColors.panel.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: PaceColors.neonCyan.withValues(alpha: 0.5)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: PaceColors.textMuted, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: PaceTheme.dash(
                size: 30,
                weight: FontWeight.w800,
                color: PaceColors.neonCyan,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final cents = _priceCents();
    final perPack = int.tryParse(_perPack.text.trim()) ?? 0;
    final perDay = int.tryParse(_perDay.text.trim()) ?? 0;
    if (cents == null || perPack <= 0 || perDay <= 0) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsInvalidValues)),
      );
      return;
    }
    final settings = ref.read(settingsProvider).value;
    if (settings == null) return;

    final sleepStartMin = _sleepStart.hour * 60 + _sleepStart.minute;
    final sleepEndMin = _sleepEnd.hour * 60 + _sleepEnd.minute;
    final priceChanged =
        cents != settings.packPriceCents ||
        perPack != settings.cigarettesPerPack;
    final baselineChanged = perDay != settings.baselineCigsPerDay;
    final sleepChanged =
        sleepStartMin != settings.sleepStartMinutes ||
        sleepEndMin != settings.sleepEndMinutes;
    if (!priceChanged && !baselineChanged && !sleepChanged) {
      navigator.pop();
      return;
    }

    // Changing the daily baseline shifts the whole reference — confirm it.
    if (baselineChanged) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: PaceColors.panel,
          title: Text(l10n.settingsBaselineChangeTitle),
          content: Text(l10n.settingsBaselineChangeBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.settingsCancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: PaceColors.neonMagenta,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(l10n.settingsSave),
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
    if (sleepChanged) {
      await db.updateSleepWindow(
        startMinutes: sleepStartMin,
        endMinutes: sleepEndMin,
      );
    }
    await pushPaceWidget(ref);
    if (!mounted) return;
    navigator.pop();
    messenger.showSnackBar(SnackBar(content: Text(l10n.settingsSaved)));
  }

  Future<void> _reset() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: PaceColors.panel,
        title: Text(l10n.settingsResetTitle),
        content: Text(l10n.settingsResetBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.settingsCancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PaceColors.neonOrange,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.settingsResetConfirm),
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
    final l10n = AppLocalizations.of(context);
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
      _sleepStart = TimeOfDay(
        hour: settings.sleepStartMinutes ~/ 60,
        minute: settings.sleepStartMinutes % 60,
      );
      _sleepEnd = TimeOfDay(
        hour: settings.sleepEndMinutes ~/ 60,
        minute: settings.sleepEndMinutes % 60,
      );
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
                      icon: const Icon(
                        Icons.arrow_back,
                        color: PaceColors.textMuted,
                      ),
                    ),
                    GraffitiHeadline(l10n.settingsTitle, size: 28),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                  children: [
                    Text(
                      l10n.settingsPriceIntro,
                      style: TextStyle(
                        color: PaceColors.textMuted,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 22),
                    _Field(
                      label: l10n.settingsPricePerPack,
                      controller: _price,
                      suffix: switch (currency) {
                        'USD' => '\$',
                        'GBP' => '£',
                        _ => '€',
                      },
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _Field(
                      label: l10n.settingsCigarettesPerPack,
                      controller: _perPack,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _Field(
                      label: l10n.settingsCigarettesPerDay,
                      controller: _perDay,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.settingsBaselineHint,
                      style: TextStyle(
                        color: PaceColors.textFaint,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      l10n.settingsSleepTime,
                      style: TextStyle(
                        color: PaceColors.textMuted,
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.settingsSleepHint,
                      style: TextStyle(
                        color: PaceColors.textFaint,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _sleepBox(
                            l10n.settingsFrom,
                            _sleepStart,
                            () => _pickSleep(isStart: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _sleepBox(
                            l10n.settingsTo,
                            _sleepEnd,
                            () => _pickSleep(isStart: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _SaveButton(saving: _saving, onTap: _saving ? null : _save),
                    const SizedBox(height: 26),
                    Text(
                      l10n.quitTitle.toUpperCase(),
                      style: TextStyle(
                        color: PaceColors.textMuted,
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _QuitDateRow(
                      date: settings?.quitDate,
                      onTap: () => QuitDateScreen.open(context),
                    ),
                    if (periods.length > 1) ...[
                      const SizedBox(height: 32),
                      Text(
                        l10n.settingsHistory,
                        style: TextStyle(
                          color: PaceColors.textMuted,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      for (final p in periods.reversed)
                        _HistoryRow(period: p, currency: currency),
                    ],
                    const SizedBox(height: 32),
                    Text(
                      l10n.settingsExtrasSection,
                      style: TextStyle(
                        color: PaceColors.textMuted,
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _ExtraRow(
                      icon: Icons.insights,
                      title: l10n.settingsExtrasRaceEngineer,
                      subtitle: l10n.settingsExtrasRaceEngineerSub,
                      onTap: () => RaceEngineerScreen.open(context),
                    ),
                    _ExtraToggleRow(
                      icon: Icons.bolt,
                      title: l10n.settingsExtrasLiveActivity,
                      subtitle: l10n.settingsExtrasLiveActivitySub,
                      value: settings?.liveActivityEnabled ?? false,
                      onChanged: (v) async {
                        await ref
                            .read(databaseProvider)
                            .updateLiveActivityEnabled(v);
                        await pushPaceWidget(ref, liveActivityOverride: v);
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.settingsExtrasSkin,
                      style: TextStyle(
                        color: PaceColors.textMuted,
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final s in Skin.all)
                          _SkinSwatch(
                            skin: s,
                            selected:
                                s.id ==
                                (settings?.skinId ?? Skin.underground.id),
                            onTap: () =>
                                ref.read(databaseProvider).updateSkin(s.id),
                          ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _reset,
                      child: Container(
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: PaceColors.neonOrange.withValues(alpha: 0.7),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.restart_alt,
                              color: PaceColors.neonOrange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.settingsResetEverything,
                              style: TextStyle(
                                color: PaceColors.neonOrange,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
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
        Text(
          label,
          style: TextStyle(color: PaceColors.textMuted, fontSize: 13),
        ),
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: PaceColors.chrome.withValues(alpha: 0.6),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: PaceColors.neonCyan, width: 2),
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
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 58,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: PaceColors.underglow),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: PaceColors.neonMagenta.withValues(alpha: 0.45),
              blurRadius: 22,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: saving
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                l10n.settingsSaveButton,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
      ),
    );
  }
}

class _SkinSwatch extends StatelessWidget {
  const _SkinSwatch({
    required this.skin,
    required this.selected,
    required this.onTap,
  });

  final Skin skin;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [skin.magenta, skin.purple, skin.cyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(
                color: selected ? Colors.white : PaceColors.chrome,
                width: selected ? 3 : 1.5,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: skin.magenta.withValues(alpha: 0.6),
                        blurRadius: 14,
                      ),
                    ]
                  : null,
            ),
            child: selected
                ? const Icon(Icons.check, color: Colors.white, size: 22)
                : null,
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 66,
            child: Text(
              skin.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? PaceColors.textPrimary : PaceColors.textMuted,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExtraToggleRow extends StatelessWidget {
  const _ExtraToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PaceColors.neonMagenta.withValues(alpha: 0.12),
            PaceColors.neonPurple.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: PaceColors.neonMagenta.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: PaceColors.neonMagenta, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: PaceColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(color: PaceColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: PaceColors.neonMagenta,
          ),
        ],
      ),
    );
  }
}

class _ExtraRow extends StatelessWidget {
  const _ExtraRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              PaceColors.neonMagenta.withValues(alpha: 0.12),
              PaceColors.neonPurple.withValues(alpha: 0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: PaceColors.neonMagenta.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: PaceColors.neonMagenta, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: PaceColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: PaceColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: PaceColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _QuitDateRow extends StatelessWidget {
  const _QuitDateRow({required this.date, required this.onTap});

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isSet = date != null;
    final accent = isSet ? PaceColors.neonLime : PaceColors.neonCyan;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: PaceColors.panel,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: accent.withValues(alpha: isSet ? 0.5 : 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.event_available, color: accent, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isSet ? l10n.quitYourDate : l10n.settingsQuitRowTitle,
                    style: const TextStyle(
                      color: PaceColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isSet ? formatDate(date!) : l10n.settingsQuitRowSub,
                    style: TextStyle(color: PaceColors.textMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: PaceColors.textMuted),
          ],
        ),
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
    final l10n = AppLocalizations.of(context);
    final d = period.effectiveFrom;
    final date =
        '${d.day.toString().padLeft(2, '0')}.'
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
          Text(
            l10n.settingsHistorySince(date),
            style: TextStyle(color: PaceColors.textMuted, fontSize: 13),
          ),
          Text(
            l10n.settingsHistoryPriceLine(
              formatMoneyCents(period.packPriceCents, currencyCode: currency),
              period.cigarettesPerPack.toString(),
            ),
            style: const TextStyle(
              color: PaceColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
