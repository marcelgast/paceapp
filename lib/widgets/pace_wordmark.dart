import 'package:flutter/material.dart';

/// The PACE graffiti wordmark, rendered from the branding raster asset. [size]
/// is the cap-height target; the asset carries its own padding, so we render a
/// little taller to compensate.
class PaceWordmark extends StatelessWidget {
  const PaceWordmark({super.key, this.size = 72, this.slash = true});

  final double size;

  /// Kept for call-site compatibility; the raster art carries its own styling.
  final bool slash;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/branding/logo.png',
      height: size * 1.45,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.medium,
    );
  }
}
