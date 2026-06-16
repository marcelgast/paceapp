import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';

Future<void> showSituationsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _SituationsSheet(),
  );
}

class _SituationsSheet extends ConsumerStatefulWidget {
  const _SituationsSheet();

  @override
  ConsumerState<_SituationsSheet> createState() => _SituationsSheetState();
}

class _SituationsSheetState extends ConsumerState<_SituationsSheet> {
  final _new = TextEditingController();

  @override
  void dispose() {
    _new.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final label = _new.text.trim();
    if (label.isEmpty) return;
    await ref.read(databaseProvider).addSituation(label);
    _new.clear();
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
          border: Border(top: BorderSide(color: PaceColors.neonCyan, width: 2)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 28),
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
            Text(l10n.journalSituations, style: PaceTheme.dash(size: 28, italic: true)),
            const SizedBox(height: 2),
            Text(l10n.situationsIntro,
                style: TextStyle(color: PaceColors.textMuted, fontSize: 13)),
            const SizedBox(height: 18),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (final s in situations)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(Icons.place_outlined,
                                color: PaceColors.neonCyan, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(s.label,
                                  style: const TextStyle(
                                      color: PaceColors.textPrimary,
                                      fontSize: 15)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: PaceColors.textFaint),
                              onPressed: () => ref
                                  .read(databaseProvider)
                                  .archiveSituation(s.id),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _new,
                    style: const TextStyle(color: PaceColors.textPrimary),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _add(),
                    decoration: InputDecoration(
                      hintText: l10n.situationsNewHint,
                      hintStyle: TextStyle(color: PaceColors.textFaint),
                      filled: true,
                      fillColor: PaceColors.panelLight,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PaceColors.neonCyan,
                      foregroundColor: PaceColors.night,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _add,
                    child: const Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
