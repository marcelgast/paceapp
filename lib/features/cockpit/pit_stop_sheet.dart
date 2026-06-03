import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      builder: (_) => const NewSituationDialog(),
    );
    if (label == null || label.trim().isEmpty) return;
    final created = await ref.read(databaseProvider).addSituation(label.trim());
    if (mounted) setState(() => _situationId = created.id);
  }

  @override
  Widget build(BuildContext context) {
    final situations = ref.watch(situationsProvider).value ?? [];
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        decoration: const BoxDecoration(
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
              Text('Boxenstopp', style: PaceTheme.dash(size: 30, italic: true)),
              const SizedBox(height: 2),
              Text(
                'Kurz festhalten — daraus lernt deine Analyse.',
                style: TextStyle(color: PaceColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 22),
              PitLevelSelector(
                label: 'Verlangen',
                value: _craving,
                color: PaceColors.neonMagenta,
                onChanged: (v) => setState(() => _craving = v),
              ),
              const SizedBox(height: 18),
              PitLevelSelector(
                label: 'Stress',
                value: _stress,
                color: PaceColors.neonOrange,
                onChanged: (v) => setState(() => _stress = v),
              ),
              const SizedBox(height: 22),
              Text('Situation', style: TextStyle(color: PaceColors.textMuted, fontSize: 13)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final s in situations)
                    PitChip(
                      label: s.label,
                      selected: _situationId == s.id,
                      onTap: () => setState(() =>
                          _situationId = _situationId == s.id ? null : s.id),
                    ),
                  PitChip(
                    label: '+ Neu',
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
                  hintText: 'Notiz (optional)',
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
                      note: _note.text.trim().isEmpty ? null : _note.text.trim(),
                    ),
                  ),
                  child: const Text(
                    'EINTRAGEN',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, letterSpacing: 1.5),
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

class PitLevelSelector extends StatelessWidget {
  const PitLevelSelector({
    super.key,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: PaceColors.textMuted, fontSize: 13)),
            Text('$value/5', style: PaceTheme.dash(size: 18, color: color)),
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
                          ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 10)]
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

class PitChip extends StatelessWidget {
  const PitChip({
    super.key,
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
            color: selected ? PaceColors.neonMagenta : border.withValues(alpha: 0.6),
          ),
          boxShadow: selected
              ? [BoxShadow(color: PaceColors.neonMagenta.withValues(alpha: 0.5), blurRadius: 12)]
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

class NewSituationDialog extends StatefulWidget {
  const NewSituationDialog({super.key});

  @override
  State<NewSituationDialog> createState() => NewSituationDialogState();
}

class NewSituationDialogState extends State<NewSituationDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: PaceColors.panel,
      title: const Text('Neue Situation'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
        style: const TextStyle(color: PaceColors.textPrimary),
        decoration: const InputDecoration(hintText: 'z. B. Pause, Telefonat …'),
        onSubmitted: (v) => Navigator.of(context).pop(v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Anlegen'),
        ),
      ],
    );
  }
}
