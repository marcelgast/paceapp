import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/milestones.dart';
import '../../providers.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';
import '../../util/format.dart';
import 'race_card.dart';

/// Snapshots the current app state into the values a [RaceCard] shows.
RaceCardData buildRaceCardData(WidgetRef ref) {
  final stats = ref.read(statsProvider);
  final streak = ref.read(streakProvider);
  final car = ref.read(currentCarProvider);
  final settings = ref.read(settingsProvider).value;
  final pitStops = ref.read(pitStopsProvider).value ?? const [];

  // Current lap = time since the last pit stop (or since the start if none yet).
  final lastPit =
      pitStops.isNotEmpty ? pitStops.first.occurredAt : settings?.startedAt;
  final currentLap =
      lastPit == null ? Duration.zero : DateTime.now().difference(lastPit);

  return RaceCardData(
    heroLabel: 'AKTUELLE RUNDE',
    heroValue: formatStintDuration(currentLap),
    savedMoney: formatMoneyCents(
      stats?.savedMoneyCents ?? 0,
      currencyCode: settings?.currencyCode ?? 'EUR',
    ),
    avoidedCigarettes: stats?.savedCigarettes.floor() ?? 0,
    streak: streak.current,
    carName: car.name,
    carTagline: car.tagline,
    carIndex: kCarTiers.indexOf(car),
  );
}

/// Opens the share preview with the current snapshot.
Future<void> showRaceCardSheet(BuildContext context, WidgetRef ref) {
  final data = buildRaceCardData(ref);
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
          text: 'Aktuelle Runde: ${widget.data.heroValue} ohne Zigarette. 🏁',
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
                    Text('TEILEN',
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
