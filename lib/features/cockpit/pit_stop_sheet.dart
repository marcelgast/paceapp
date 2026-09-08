import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';

/// What the user logged for one pit stop. The cockpit adds the timing fields.
class PitStopDraft {
  const PitStopDraft({
    required this.cravingLevel,
    required this.stressLevel,
    this.situationId,
    this.note,
  });

  final int cravingLevel;
  final int stressLevel;
  final String? situationId;
  final String? note;
}

Future<PitStopDraft?> showPitStopSheet(BuildContext context) {
  return showModalBottomSheet<PitStopDraft>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _PitStopSheet(),
  );
}

class _PitStopSheet extends ConsumerStatefulWidget {
  const _PitStopSheet();

  @override
  ConsumerState<_PitStopSheet> createState() => _PitStopSheetState();
}

class _PitStopSheetState extends ConsumerState<_PitStopSheet> {
  int _craving = 3;
  int _stress = 3;
  String? _situationId;
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _addSituation() async {
    final label = await showDialog<String>(
      context: context,
      builder: (_) => const _NewSituationDialog(),
    );
    if (label == null || label.trim().isEmpty) return;
    final created = await ref.read(databaseProvider).addSituation(label.trim());
    if (mounted) setState(() => _situationId = created.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final situations = ref.watch(situationsProvider).value ?? [];
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: BoxDecoration(
          color: PaceColors.panel,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: PaceColors.neonMagenta, width: 2),
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Text(
                l10n.cockpitPitStopTitle,
                style: PaceTheme.dash(size: 30, italic: true),
              ),
              const SizedBox(height: 2),
              Text(
                l10n.cockpitPitStopSubtitle,
                style: TextStyle(color: PaceColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 22),
              _LevelSelector(
                label: l10n.cockpitCraving,
                value: _craving,
                color: PaceColors.neonMagenta,
                onChanged: (v) => setState(() => _craving = v),
              ),
              const SizedBox(height: 18),
              _LevelSelector(
                label: l10n.cockpitStress,
                value: _stress,
                color: PaceColors.neonOrange,
                onChanged: (v) => setState(() => _stress = v),
              ),
              const SizedBox(height: 22),
              Text(
                l10n.cockpitSituation,
                style: TextStyle(color: PaceColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in situations)
                    _Chip(
                      label: s.label,
                      selected: _situationId == s.id,
                      onTap: () => setState(
                        () => _situationId = _situationId == s.id ? null : s.id,
                      ),
                    ),
                  _Chip(
                    label: l10n.cockpitSituationNew,
                    selected: false,
                    accent: true,
                    onTap: _addSituation,
                  ),
                ],
              ),
              const SizedBox(height: 22),
              TextField(
                controller: _note,
                style: const TextStyle(color: PaceColors.textPrimary),
                decoration: InputDecoration(
                  hintText: l10n.cockpitNoteHint,
                  hintStyle: TextStyle(color: PaceColors.textFaint),
                  filled: true,
                  fillColor: PaceColors.panelLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PaceColors.neonMagenta,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(
                    PitStopDraft(
                      cravingLevel: _craving,
                      stressLevel: _stress,
                      situationId: _situationId,
                      note: _note.text.trim().isEmpty
                          ? null
                          : _note.text.trim(),
                    ),
                  ),
                  child: Text(
                    l10n.cockpitSubmit,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelSelector extends StatelessWidget {
  const _LevelSelector({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  final String label;
  final int value;
  final Color color;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(color: PaceColors.textMuted, fontSize: 13),
            ),
            Text(
              l10n.cockpitLevelValue(value.toString()),
              style: PaceTheme.dash(size: 18, color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 1; i <= 5; i++)
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  child: Container(
                    margin: EdgeInsets.only(right: i < 5 ? 6 : 0),
                    height: 38,
                    decoration: BoxDecoration(
                      color: i <= value ? color : PaceColors.panelLight,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: i <= value
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 10,
                              ),
                            ]
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$i',
                      style: TextStyle(
                        color: i <= value ? Colors.white : PaceColors.textFaint,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.accent = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final border = accent ? PaceColors.neonCyan : PaceColors.chrome;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? PaceColors.neonMagenta : PaceColors.panelLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? PaceColors.neonMagenta
                : border.withValues(alpha: 0.6),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: PaceColors.neonMagenta.withValues(alpha: 0.5),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Colors.white
                : accent
                ? PaceColors.neonCyan
                : PaceColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _NewSituationDialog extends StatefulWidget {
  const _NewSituationDialog();

  @override
  State<_NewSituationDialog> createState() => NewSituationDialogState();
}

class NewSituationDialogState extends State<_NewSituationDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      backgroundColor: PaceColors.panel,
      title: Text(l10n.cockpitNewSituationTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: PaceColors.textPrimary),
        decoration: InputDecoration(hintText: l10n.cockpitNewSituationHint),
        onSubmitted: (v) => Navigator.of(context).pop(v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cockpitCancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: Text(l10n.cockpitCreate),
        ),
      ],
    );
  }
}
