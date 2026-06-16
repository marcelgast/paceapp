import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/milestones.dart';
import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../util/format.dart';
import 'race_card.dart';

/// The snapshot bits every card variant shows: car, money, avoided, streak.
({
  String savedMoney,
  int avoided,
  int streak,
  String carName,
  String carTagline,
  int carIndex,
}) _commonBits(WidgetRef ref, String lang) {
  final stats = ref.read(statsProvider);
  final streak = ref.read(streakProvider);
  final car = ref.read(currentCarProvider);
  final settings = ref.read(settingsProvider).value;
  return (
    savedMoney: formatMoneyCents(
      stats?.savedMoneyCents ?? 0,
      currencyCode: settings?.currencyCode ?? 'EUR',
    ),
    avoided: stats?.savedCigarettes.floor() ?? 0,
    streak: streak.current,
    carName: car.localizedName(lang),
    carTagline: car.localizedTagline(lang),
    carIndex: kCarTiers.indexOf(car),
  );
}

/// Card for the current lap — time since the last pit stop.
RaceCardData currentLapCard(WidgetRef ref, AppLocalizations l10n, String lang) {
  final clock = formatStintDuration(ref.read(cleanRunProvider).current);
  final b = _commonBits(ref, lang);
  return RaceCardData(
    heroLabel: l10n.shareCurrentLap,
    heroValue: clock,
    shareText: l10n.shareCurrentLapText(clock),
    savedMoney: b.savedMoney,
    avoidedCigarettes: b.avoided,
    streak: b.streak,
    carName: b.carName,
    carTagline: b.carTagline,
    carIndex: b.carIndex,
  );
}

/// Card for an unlocked milestone.
RaceCardData milestoneCard(
    WidgetRef ref, Milestone milestone, AppLocalizations l10n, String lang) {
  final b = _commonBits(ref, lang);
  return RaceCardData(
    heroLabel: l10n.shareMilestone,
    heroValue: milestone.localizedTitle(lang),
    subline: milestone.localizedDetail(lang),
    shareText: l10n.shareMilestoneText(milestone.localizedTitle(lang)),
    savedMoney: b.savedMoney,
    avoidedCigarettes: b.avoided,
    streak: b.streak,
    carName: b.carName,
    carTagline: b.carTagline,
    carIndex: b.carIndex,
  );
}

/// Opens the share preview for a prepared card.
Future<void> showRaceCardSheet(BuildContext context, RaceCardData data) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: PaceColors.nightDeep,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => _ShareCardSheet(data: data),
  );
}

class _ShareCardSheet extends StatefulWidget {
  const _ShareCardSheet({required this.data});

  final RaceCardData data;

  @override
  State<_ShareCardSheet> createState() => _ShareCardSheetState();
}

class _ShareCardSheetState extends State<_ShareCardSheet> {
  final _cardKey = GlobalKey();
  bool _busy = false;

  Future<void> _share() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final boundary =
          _cardKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final png = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/pace_race_card.png');
      await file.writeAsBytes(png!.buffer.asUint8List());

      if (!mounted) return;
      final box = context.findRenderObject() as RenderBox?;
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'image/png')],
          text: widget.data.shareText,
          sharePositionOrigin:
              box == null ? null : box.localToGlobal(Offset.zero) & box.size,
        ),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxCardHeight = MediaQuery.of(context).size.height * 0.62;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: PaceColors.chrome,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 18),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: maxCardHeight),
              child: FittedBox(
                child: RepaintBoundary(
                  key: _cardKey,
                  child: RaceCard(data: widget.data),
                ),
              ),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: _ShareButton(busy: _busy, onTap: _share),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({required this.busy, required this.onTap});

  final bool busy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return GestureDetector(
      onTap: busy ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: PaceColors.underglow),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: PaceColors.neonMagenta.withValues(alpha: 0.4),
                blurRadius: 18),
          ],
        ),
        child: Center(
          child: busy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.ios_share, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(l10n.shareButton,
                        style: PaceTheme.dash(
                            size: 18,
                            weight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 2)),
                  ],
                ),
        ),
      ),
    );
  }
}
