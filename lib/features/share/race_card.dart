import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/pace_colors.dart';
import '../../theme/pace_theme.dart';

/// Everything a [RaceCard] needs to render — pure values, no providers, so the
/// card stays a deterministic, testable presentation widget.
class RaceCardData {
  const RaceCardData({
    required this.heroLabel,
    required this.heroValue,
    required this.savedMoney,
    required this.avoidedCigarettes,
    required this.streak,
    required this.carName,
    required this.carTagline,
    required this.carIndex,
    required this.shareText,
    this.subline,
  });

  /// Caption above the hero, e.g. "AKTUELLE RUNDE", "BESTZEIT" or "MEILENSTEIN"
  /// — lets us reuse this card for current-lap, overall-best and achievements.
  final String heroLabel;

  /// The hero itself: a lap-time clock ("52:18:09") or a milestone title.
  final String heroValue;

  /// Optional line under the hero — e.g. a milestone's recovery fact.
  final String? subline;

  /// Caption shared alongside the image in the iOS share sheet.
  final String shareText;
  final String savedMoney;
  final int avoidedCigarettes;
  final int streak;
  final String carName;
  final String carTagline;
  final int carIndex;
}

/// Shareable 9:16 poster in the Pace street-racing look. Rendered at its fixed
/// [width]×[height] inside a RepaintBoundary, then captured to a PNG for the
/// iOS share sheet — so it looks identical on every device.
class RaceCard extends StatelessWidget {
  const RaceCard({super.key, required this.data});

  final RaceCardData data;

  static const double width = 360;
  static const double height = 640;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PaceColors.nightDeep,
                  PaceColors.night,
                  Color(0xFF170E24),
                ],
              ),
            ),
          ),
          Opacity(
            opacity: 0.16,
            child: Image.asset(
              'assets/textures/asphalt.png',
              fit: BoxFit.cover,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.7),
                radius: 1.1,
                colors: [
                  PaceColors.neonMagenta.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
                stops: const [0, 0.6],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(l10n),
                const Spacer(flex: 3),
                _hero(),
                const SizedBox(height: 4),
                Expanded(flex: 9, child: _car()),
                const Spacer(flex: 2),
                _stats(l10n),
                const SizedBox(height: 20),
                _footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/branding/logo.png', height: 30),
        Text(
          l10n.sharePitStopReport,
          textAlign: TextAlign.right,
          style: TextStyle(
            color: PaceColors.textMuted,
            fontSize: 10,
            height: 1.2,
            letterSpacing: 2,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _hero() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.heroLabel,
          style: PaceTheme.dash(
            size: 24,
            weight: FontWeight.w800,
            color: PaceColors.neonMagenta,
            letterSpacing: 7,
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              colors: [PaceColors.neonCyan, PaceColors.neonMagenta],
            ).createShader(rect),
            child: Text(
              data.heroValue,
              style:
                  PaceTheme.dash(
                    size: 108,
                    weight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -1,
                  ).copyWith(
                    shadows: PaceTheme.neonGlow(
                      PaceColors.neonMagenta,
                      blur: 24,
                    ),
                  ),
            ),
          ),
        ),
        if (data.subline != null) ...[
          const SizedBox(height: 10),
          Text(
            data.subline!,
            maxLines: 3,
            style: const TextStyle(
              color: PaceColors.textPrimary,
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _car() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: const Alignment(0, 0.7),
          child: Container(
            height: 26,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  PaceColors.neonCyan.withValues(alpha: 0.45),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Image.asset(
          'assets/cars/car_${data.carIndex.clamp(0, 6)}.png',
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      ],
    );
  }

  Widget _stats(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: PaceColors.panel.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PaceColors.neonCyan.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          _kpi(l10n.shareSaved, data.savedMoney, PaceColors.neonLime),
          _divider(),
          _kpi(
            l10n.shareAvoided,
            '${data.avoidedCigarettes}',
            PaceColors.neonCyan,
          ),
          _divider(),
          _kpi(
            l10n.shareStreak,
            data.streak > 0 ? l10n.shareStreakDays(data.streak) : '—',
            PaceColors.neonOrange,
          ),
        ],
      ),
    );
  }

  Widget _kpi(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            child: Text(
              value,
              style: PaceTheme.dash(
                size: 26,
                weight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: PaceColors.textMuted,
              fontSize: 10,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
    width: 1,
    height: 34,
    color: PaceColors.chrome.withValues(alpha: 0.7),
  );

  Widget _footer() {
    return Column(
      children: [
        Text(
          data.carName.toUpperCase(),
          style:
              PaceTheme.dash(
                size: 20,
                weight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1,
              ).copyWith(
                shadows: PaceTheme.neonGlow(PaceColors.neonMagenta, blur: 12),
              ),
        ),
        const SizedBox(height: 4),
        Text(
          data.carTagline,
          style: TextStyle(
            color: PaceColors.textMuted,
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
