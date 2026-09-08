import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/weekly_proposal.dart';
import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';
import '../quit/quit_date_screen.dart';

/// Shows the weekly "stretch your target" proposal as a celebrated overlay
/// whenever one is due. Accepting sets the new target; declining keeps it.
class ProposalHost extends ConsumerWidget {
  const ProposalHost({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final proposal = ref.watch(proposalProvider);
    return Stack(
      children: [
        child,
        if (proposal?.isDue ?? false) _ProposalOverlay(state: proposal!),
      ],
    );
  }
}

class _ProposalOverlay extends ConsumerStatefulWidget {
  const _ProposalOverlay({required this.state});

  final ProposalState state;

  @override
  ConsumerState<_ProposalOverlay> createState() => _ProposalOverlayState();
}

class _ProposalOverlayState extends ConsumerState<_ProposalOverlay> {
  late double _growth = (widget.state.growthPermille / 1000).clamp(
    ProposalCalculator.minGrowth,
    ProposalCalculator.maxGrowth,
  );
  bool _accepted = false;
  int _lastHapticPct = -1;

  late final ConfettiController _confetti = ConfettiController(
    duration: const Duration(seconds: 2),
  );

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Duration get _proposed =>
      ProposalCalculator.proposed(base: widget.state.base, growth: _growth);

  Future<void> _accept() async {
    if (_accepted) return;
    setState(() => _accepted = true);
    _confetti.play();
    HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 1300));
    await ref
        .read(databaseProvider)
        .acceptProposal(
          targetSeconds: _proposed.inSeconds,
          growthPermille: (_growth * 1000).round(),
          at: DateTime.now(),
        );
    // proposalProvider flips isDue → overlay removed.
  }

  Future<void> _decline() async {
    HapticFeedback.lightImpact();
    await ref.read(databaseProvider).declineProposal(DateTime.now());
  }

  void _onSlide(double v) {
    setState(() => _growth = v);
    final pct = (v * 100).round();
    if (pct != _lastHapticPct) {
      _lastHapticPct = pct;
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.88),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 26,
                maxBlastForce: 24,
                minBlastForce: 8,
                gravity: 0.25,
                emissionFrequency: 0.05,
                colors: [
                  PaceColors.neonMagenta,
                  PaceColors.neonCyan,
                  PaceColors.neonLime,
                  PaceColors.neonOrange,
                  PaceColors.neonPurple,
                ],
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 40,
                ),
                child: _accepted ? _acceptedView() : _proposalView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _proposalView() {
    final l10n = AppLocalizations.of(context);
    final base = widget.state.base;
    final delta = _proposed - base;
    final pct = (_growth * 100).round();

    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.proposalStretchCheck,
              style: TextStyle(
                color: PaceColors.neonOrange,
                fontSize: 13,
                letterSpacing: 4,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            GraffitiHeadline(
              l10n.proposalWeekDone,
              size: 40,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              widget.state.currentTarget == null
                  ? l10n.proposalFirstTargetPrompt
                  : l10n.proposalStretchPrompt,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: PaceColors.textMuted,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.proposalNewTarget,
              style: TextStyle(
                color: PaceColors.neonCyan,
                fontSize: 11,
                letterSpacing: 2,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            // Live target — re-keyed so it pops on every change.
            Text(
              l10n.proposalEvery(formatHumanDuration(_proposed)),
              key: ValueKey(_proposed.inSeconds),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
              ),
            ).animate().scaleXY(
              begin: 0.92,
              end: 1.0,
              duration: 180.ms,
              curve: Curves.easeOut,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.proposalMoreRoom(formatHumanDuration(delta)),
              style: TextStyle(
                color: PaceColors.neonLime,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.proposalStretchBy,
                  style: TextStyle(color: PaceColors.textMuted, fontSize: 13),
                ),
                Text(
                  l10n.proposalPercent(pct),
                  style: TextStyle(
                    color: PaceColors.neonMagenta,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: PaceColors.neonMagenta,
                inactiveTrackColor: PaceColors.panelLight,
                thumbColor: Colors.white,
                overlayColor: PaceColors.neonMagenta.withValues(alpha: 0.2),
                trackHeight: 6,
              ),
              child: Slider(
                min: ProposalCalculator.minGrowth,
                max: ProposalCalculator.maxGrowth,
                value: _growth,
                onChanged: _onSlide,
              ),
            ),
            const SizedBox(height: 16),
            _AcceptButton(onTap: _accept),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _decline,
              child: Text(
                l10n.proposalKeepIt,
                style: TextStyle(color: PaceColors.textMuted, fontSize: 15),
              ),
            ),
            const SizedBox(height: 8),
            Container(height: 0.5, color: PaceColors.chrome),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () async {
                final nav = Navigator.of(context);
                await ref
                    .read(databaseProvider)
                    .declineProposal(DateTime.now());
                await nav.push(
                  MaterialPageRoute<void>(
                    builder: (_) => const QuitDateScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.event_available,
                color: PaceColors.neonCyan,
                size: 18,
              ),
              label: Text(
                l10n.proposalSetQuitDate,
                style: TextStyle(
                  color: PaceColors.neonCyan,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 260.ms)
        .scaleXY(
          begin: 0.85,
          end: 1.0,
          curve: Curves.easeOutBack,
          duration: 420.ms,
        );
  }

  Widget _acceptedView() {
    final l10n = AppLocalizations.of(context);
    return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.flag_circle, color: PaceColors.neonLime, size: 96)
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(
                  begin: 1.0,
                  end: 1.12,
                  duration: 700.ms,
                  curve: Curves.easeInOut,
                ),
            const SizedBox(height: 20),
            GraffitiHeadline(
              l10n.proposalTargetSet,
              size: 40,
              color: PaceColors.neonLime,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.proposalEvery(formatHumanDuration(_proposed)),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.proposalAcceptedHint,
              style: TextStyle(color: PaceColors.textMuted, fontSize: 15),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 260.ms)
        .scaleXY(
          begin: 0.7,
          end: 1.0,
          curve: Curves.elasticOut,
          duration: 800.ms,
        );
  }
}

class _AcceptButton extends StatelessWidget {
  const _AcceptButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 58,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: PaceColors.underglow),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: PaceColors.neonMagenta.withValues(alpha: 0.5),
                  blurRadius: 24,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              l10n.proposalApply,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 2200.ms,
          color: Colors.white.withValues(alpha: 0.18),
        );
  }
}
