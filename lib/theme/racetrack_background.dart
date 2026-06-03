import 'package:flutter/material.dart';

/// Wet-asphalt photo backdrop with a dark scrim so neon UI and text stay legible.
class RacetrackBackground extends StatelessWidget {
  const RacetrackBackground({
    super.key,
    this.child,
    this.vignette = true,
  });

  final Widget? child;
  final bool vignette;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/textures/asphalt.png',
          fit: BoxFit.cover,
          alignment: Alignment.center,
          filterQuality: FilterQuality.medium,
        ),
        // Readability scrim — darker at the top (status bar) and bottom (nav).
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xCC0A0A0E),
                Color(0x8A0A0A0E),
                Color(0xB00A0A0E),
              ],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
        ),
        if (vignette)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.1,
                colors: [Colors.transparent, Color(0x7A000000)],
                stops: [0.55, 1.0],
              ),
            ),
          ),
        ?child,
      ],
    );
  }
}
