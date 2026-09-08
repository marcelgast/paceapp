import 'package:flutter/material.dart';

import '../../theme/pace_colors.dart';

/// The car for a garage tier — a real rendered asset. Locked tiers are shown
/// desaturated and dimmed.
class CarArt extends StatelessWidget {
  const CarArt({
    super.key,
    required this.tierIndex,
    required this.width,
    this.unlocked = true,
  });

  final int tierIndex;
  final double width;
  final bool unlocked;

  /// Accent colour per garage tier (borders, glow, hubs).
  static final List<Color> tierColors = [
    Color(0xFF8A7A6A), // Rostlaube
    PaceColors.neonCyan, // Tuned Hatchback
    PaceColors.neonMagenta, // Street Coupé
    PaceColors.neonPurple, // Drift Machine
    PaceColors.neonOrange, // Muscle Car
    PaceColors.neonLime, // GT-Renner
    Color(0xFFE8ECF5), // Hypercar
  ];

  static Color colorFor(int index) =>
      tierColors[index.clamp(0, tierColors.length - 1)];

  static const ColorFilter _grayscale = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/cars/car_${tierIndex.clamp(0, 6)}.png',
      width: width,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
    if (unlocked) return image;
    return Opacity(
      opacity: 0.45,
      child: ColorFiltered(colorFilter: _grayscale, child: image),
    );
  }
}
