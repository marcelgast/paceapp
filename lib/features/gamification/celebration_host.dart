import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/milestones.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../widgets/graffiti_headline.dart';
import '../share/share_card_sheet.dart';
import 'milestone_style.dart';

/// Wraps the app and pops a celebration whenever a milestone is newly reached —
/// at launch or live while the user watches.
class CelebrationHost extends ConsumerStatefulWidget {
  const CelebrationHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<CelebrationHost> createState() => _CelebrationHostState();
}

class _CelebrationHostState extends ConsumerState<CelebrationHost> {
  final Set<String> _handled = {};
  final List<Milestone> _queue = [];
  Milestone? _current;
  late final ConfettiController _confetti =
      ConfettiController(duration: const Duration(seconds: 2));

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _ingest(List<Milestone> pending) {
    var added = false;
    for (final m in pending) {
      if (_handled.add(m.key)) {
        _queue.add(m);
        added = true;
      }
    }
    if (added) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showNext();
      });
    }
  }

  void _showNext() {
    if (_current != null || _queue.isEmpty) return;
    setState(() => _current = _queue.removeAt(0));
    _confetti.play();
    HapticFeedback.heavyImpact();
  }

  void _dismiss() {
    final done = _current;
    if (done != null) {
      ref.read(databaseProvider).markCelebrated([done.key], DateTime.now());
    }
    setState(() => _current = null);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _showNext();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<List<Milestone>>(
      pendingMilestonesProvider,
      (_, next) => _ingest(next),
    );

    // The weekly proposal takes precedence; milestones wait their turn.
    final proposalDue = ref.watch(proposalProvider)?.isDue ?? false;

    return Stack(
      children: [
        widget.child,
        if (_current != null && !proposalDue)
          _CelebrationOverlay(
            milestone: _current!,
            confetti: _confetti,
            onDismiss: _dismiss,
            onShare: () =>
                showRaceCardSheet(context, milestoneCard(ref, _current!)),
          ),
      ],
    );
  }
}

class _CelebrationOverlay extends StatelessWidget {
  const _CelebrationOverlay({
    required this.milestone,
    required this.confetti,
    required this.onDismiss,
    required this.onShare,
  });

  final Milestone milestone;
  final ConfettiController confetti;
  final VoidCallback onDismiss;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final style = MilestoneStyle.of(milestone.kind);
    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.82),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: confetti,
                blastDirectionality: BlastDirectionality.explosive,
                blastDirection: math.pi / 2,
                emissionFrequency: 0.05,
                numberOfParticles: 24,
                maxBlastForce: 22,
                minBlastForce: 8,
                gravity: 0.25,
                colors: const [
                  PaceColors.neonMagenta,
                  PaceColors.neonCyan,
                  PaceColors.neonLime,
                  PaceColors.neonOrange,
                  PaceColors.neonPurple,
                ],
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Badge(icon: style.icon, color: style.color),
                    const SizedBox(height: 24),
                    Text(
                      'MEILENSTEIN',
                      style: TextStyle(
                        color: style.color,
                        fontSize: 14,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GraffitiHeadline(milestone.title, size: 38, color: style.color)
                        .animate()
                        .shimmer(
                          duration: 1400.ms,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                    const SizedBox(height: 14),
                    Text(
                      milestone.detail,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: PaceColors.textPrimary,
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: onDismiss,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: PaceColors.underglow),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: style.color.withValues(alpha: 0.5),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: const Text(
                          'LASS KRACHEN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextButton.icon(
                      onPressed: onShare,
                      icon: Icon(Icons.ios_share, color: style.color, size: 18),
                      label: Text('Als Karte teilen',
                          style: TextStyle(
                              color: style.color,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                    ),
                  ],
                ),
              )
                  .animate()
                  .fadeIn(duration: 260.ms)
                  .scaleXY(begin: 0.7, end: 1.0, curve: Curves.elasticOut, duration: 700.ms),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: PaceColors.panel,
        border: Border.all(color: color, width: 3),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 36, spreadRadius: 4),
        ],
      ),
      child: Icon(icon, color: color, size: 54),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scaleXY(begin: 1.0, end: 1.08, duration: 1100.ms, curve: Curves.easeInOut);
  }
}
