import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/milestones.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../theme/racetrack_background.dart';
import '../../util/format.dart';
import '../../widgets/graffiti_headline.dart';
import '../gamification/milestone_style.dart';
import '../share/share_card_sheet.dart';
import 'car_art.dart';

class TrophiesScreen extends ConsumerWidget {
  const TrophiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achieved = ref
        .watch(achievedMilestonesProvider)
        .map((m) => m.key)
        .toSet();
    final car = ref.watch(currentCarProvider);
    final nextCar = ref.watch(nextCarProvider);
    final savedCents = ref.watch(statsProvider)?.savedMoneyCents ?? 0;

    return Scaffold(
      body: RacetrackBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const GraffitiHeadline('Pokalvitrine', size: 30),
                      _ShareChip(onTap: () => showRaceCardSheet(context, ref)),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _GarageCard(
                    car: car,
                    carIndex: kCarTiers.indexOf(car),
                    nextCar: nextCar,
                    savedCents: savedCents),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                  child: Text('GARAGE',
                      style: TextStyle(
                          color: PaceColors.textMuted,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              SliverToBoxAdapter(child: _GarageRow(savedCents: savedCents)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                  child: Text('MEILENSTEINE',
                      style: TextStyle(
                          color: PaceColors.textMuted,
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700)),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.55,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final m = kMilestones[i];
                      return _MilestoneTile(
                        milestone: m,
                        unlocked: achieved.contains(m.key),
                      );
                    },
                    childCount: kMilestones.length,
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

class _ShareChip extends StatelessWidget {
  const _ShareChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: PaceColors.neonMagenta),
          color: PaceColors.neonMagenta.withValues(alpha: 0.12),
        ),
        child: const Row(
          children: [
            Icon(Icons.ios_share, color: PaceColors.neonMagenta, size: 16),
            SizedBox(width: 6),
            Text('Teilen',
                style: TextStyle(
                    color: PaceColors.neonMagenta,
                    fontSize: 13,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _GarageRow extends StatelessWidget {
  const _GarageRow({required this.savedCents});

  final int savedCents;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 154,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: kCarTiers.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, i) {
          final tier = kCarTiers[i];
          final unlocked = savedCents >= tier.unlockCents;
          final accent = CarArt.colorFor(i);
          return Container(
            width: 158,
            padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
            decoration: BoxDecoration(
              color: PaceColors.panel.withValues(alpha: unlocked ? 0.9 : 0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: unlocked
                    ? accent.withValues(alpha: 0.5)
                    : PaceColors.chrome.withValues(alpha: 0.4),
              ),
            ),
            child: Column(
              children: [
                CarArt(tierIndex: i, width: 134, unlocked: unlocked),
                const Spacer(),
                Text(tier.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: unlocked
                            ? PaceColors.textPrimary
                            : PaceColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
                Text(unlocked ? 'freigeschaltet' : formatMoneyCents(tier.unlockCents),
                    style: TextStyle(
                        color: unlocked ? accent : PaceColors.textFaint,
                        fontSize: 11)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _GarageCard extends StatelessWidget {
  const _GarageCard({
    required this.car,
    required this.carIndex,
    required this.nextCar,
    required this.savedCents,
  });

  final CarTier car;
  final int carIndex;
  final CarTier? nextCar;
  final int savedCents;

  @override
  Widget build(BuildContext context) {
    final double progress;
    final String hint;
    if (nextCar == null) {
      progress = 1;
      hint = 'Garage komplett — alles freigeschaltet!';
    } else {
      final span = nextCar!.unlockCents - car.unlockCents;
      progress = span <= 0
          ? 0
          : ((savedCents - car.unlockCents) / span).clamp(0.0, 1.0);
      final remaining = nextCar!.unlockCents - savedCents;
      hint =
          'Noch ${formatMoneyCents(remaining)} bis ${nextCar!.name}';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [PaceColors.panelLight, PaceColors.panel],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: PaceColors.neonMagenta.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: PaceColors.neonMagenta.withValues(alpha: 0.15),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CarArt(tierIndex: carIndex, width: 230)
                .animate(onPlay: (c) => c.repeat())
                .shimmer(duration: 2600.ms, color: Colors.white.withValues(alpha: 0.18)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(Icons.directions_car_filled,
                  color: PaceColors.neonMagenta, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DEIN WAGEN',
                        style: TextStyle(
                            color: PaceColors.textMuted,
                            fontSize: 11,
                            letterSpacing: 2)),
                    Text(car.name,
                        style: PaceTheme.dash(size: 26, italic: true)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(car.tagline,
              style: TextStyle(color: PaceColors.textMuted, fontSize: 13)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: PaceColors.night,
              valueColor:
                  const AlwaysStoppedAnimation(PaceColors.neonLime),
            ),
          ),
          const SizedBox(height: 8),
          Text(hint,
              style: const TextStyle(
                  color: PaceColors.neonLime, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({required this.milestone, required this.unlocked});

  final Milestone milestone;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final style = MilestoneStyle.of(milestone.kind);
    final color = unlocked ? style.color : PaceColors.textFaint;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PaceColors.panel.withValues(alpha: unlocked ? 0.9 : 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: unlocked
              ? style.color.withValues(alpha: 0.6)
              : PaceColors.chrome.withValues(alpha: 0.4),
        ),
        boxShadow: unlocked
            ? [BoxShadow(color: style.color.withValues(alpha: 0.2), blurRadius: 16)]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(unlocked ? style.icon : Icons.lock_outline, color: color, size: 26),
              Text(style.label,
                  style: TextStyle(
                      color: color.withValues(alpha: 0.8),
                      fontSize: 9,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700)),
            ],
          ),
          Text(
            milestone.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: unlocked ? PaceColors.textPrimary : PaceColors.textMuted,
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
