import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../services/widget_service.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../util/format.dart';
import 'pit_stop_sheet.dart';

/// Edit (or delete) a logged pit stop — for fixing mistypes. Every change warns
/// that it noticeably distorts the displayed stats.
Future<void> showEditPitStopSheet(
    BuildContext context, WidgetRef ref, PitStop pit) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _EditPitStopSheet(pit: pit),
  );
}

class _EditPitStopSheet extends ConsumerStatefulWidget {
  const _EditPitStopSheet({required this.pit});

  final PitStop pit;

  @override
  ConsumerState<_EditPitStopSheet> createState() => _EditPitStopSheetState();
}

class _EditPitStopSheetState extends ConsumerState<_EditPitStopSheet> {
  late int _craving = widget.pit.cravingLevel;
  late int _stress = widget.pit.stressLevel;
  late String? _situationId = widget.pit.situationId;
  late DateTime _when = widget.pit.occurredAt;
  late final _note = TextEditingController(text: widget.pit.note ?? '');
  bool _busy = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _when,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_when),
    );
    if (time == null || !mounted) return;
    setState(() => _when =
        DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<bool> _confirm(String title, String verb) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: PaceColors.panel,
        title: Text(title),
        content: const Text(
          'Das verändert deine angezeigten Werte (Gespart, Vermieden, Streak, '
          'Erfolge) deutlich. Trotzdem fortfahren?',
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
            child: Text(verb),
          ),
        ],
      ),
    );
    return ok ?? false;
  }

  Future<void> _save() async {
    if (_busy || !await _confirm('Boxenstopp ändern?', 'Speichern')) return;
    setState(() => _busy = true);
    await ref.read(databaseProvider).updatePitStop(
          id: widget.pit.id,
          occurredAt: _when,
          cravingLevel: _craving,
          stressLevel: _stress,
          situationId: _situationId,
          note: _note.text.trim().isEmpty ? null : _note.text.trim(),
        );
    await pushPaceWidget(ref);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _delete() async {
    if (_busy || !await _confirm('Boxenstopp löschen?', 'Löschen')) return;
    setState(() => _busy = true);
    await ref.read(databaseProvider).deletePitStop(widget.pit.id);
    await pushPaceWidget(ref);
    if (mounted) Navigator.of(context).pop();
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
          border:
              Border(top: BorderSide(color: PaceColors.neonMagenta, width: 2)),
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
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              Text('Boxenstopp bearbeiten',
                  style: PaceTheme.dash(size: 26, italic: true)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: PaceColors.neonOrange.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: PaceColors.neonOrange.withValues(alpha: 0.6)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: PaceColors.neonOrange, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Änderungen hier verfälschen deine angezeigten Werte stark.',
                        style: TextStyle(
                            color: PaceColors.neonOrange,
                            fontSize: 13,
                            height: 1.3,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              GestureDetector(
                onTap: _pickTime,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: PaceColors.panelLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule,
                          color: PaceColors.neonCyan, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        '${formatDayHeader(_when, DateTime.now())} · '
                        '${formatClock(_when)}',
                        style: PaceTheme.dash(size: 20, color: Colors.white),
                      ),
                      const Spacer(),
                      Text('ändern',
                          style: TextStyle(
                              color: PaceColors.neonCyan,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
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
              Text('Situation',
                  style: TextStyle(color: PaceColors.textMuted, fontSize: 13)),
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
              Row(
                children: [
                  GestureDetector(
                    onTap: _busy ? null : _delete,
                    child: Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        color: PaceColors.panelLight,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color:
                                PaceColors.neonOrange.withValues(alpha: 0.7)),
                      ),
                      child: const Icon(Icons.delete_outline,
                          color: PaceColors.neonOrange),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PaceColors.neonMagenta,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: _busy ? null : _save,
                        child: const Text('SPEICHERN',
                            style: TextStyle(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
