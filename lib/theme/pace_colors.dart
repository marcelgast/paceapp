import 'package:flutter/material.dart';

import 'skin.dart';

/// Y2K street-racing palette. Surfaces are fixed; the neon accents are swapped
/// at runtime by the active [Skin] (a Pro feature), so they can no longer be
/// used in `const` expressions.
abstract final class PaceColors {
  // Night surfaces — near-black with a purple cast. Fixed across skins.
  static const Color night = Color(0xFF0B0712);
  static const Color nightDeep = Color(0xFF06040A);
  static const Color panel = Color(0xFF15101F);
  static const Color panelLight = Color(0xFF1E1730);
  static const Color chrome = Color(0xFF2A2440);

  // Neon accents — recoloured by the active skin.
  static Color neonMagenta = Skin.underground.magenta;
  static Color neonMagentaDark = _darken(Skin.underground.magenta);
  static Color neonCyan = Skin.underground.cyan;
  static Color neonPurple = Skin.underground.purple;
  static Color neonOrange = Skin.underground.orange;
  static Color neonLime = Skin.underground.lime;
  static Color neonLimeBright = _brighten(Skin.underground.lime);

  // Staging-tree bulbs.
  static const Color stageAmber = Color(0xFFFFB020);
  static Color stageGreen = Skin.underground.lime;

  // Text — fixed.
  static const Color textPrimary = Color(0xFFF3F0FA);
  static const Color textMuted = Color(0xFF9A93AD);
  static const Color textFaint = Color(0xFF5E5775);

  // Underglow gradient (buttons, accents).
  static List<Color> underglow = [
    Skin.underground.magenta,
    Skin.underground.purple,
    Skin.underground.cyan,
  ];

  // Gauge sweep, cool → hot (RPM / boost band).
  static List<Color> rpmBand = [
    Skin.underground.cyan,
    Skin.underground.lime,
    Skin.underground.orange,
    Skin.underground.magenta,
  ];

  /// Recolour every accent from [s]. Call at startup and whenever the skin
  /// changes (followed by a UI rebuild).
  static void applySkin(Skin s) {
    neonMagenta = s.magenta;
    neonMagentaDark = _darken(s.magenta);
    neonCyan = s.cyan;
    neonPurple = s.purple;
    neonOrange = s.orange;
    neonLime = s.lime;
    neonLimeBright = _brighten(s.lime);
    stageGreen = s.lime;
    underglow = [s.magenta, s.purple, s.cyan];
    rpmBand = [s.cyan, s.lime, s.orange, s.magenta];
  }

  static Color _darken(Color c) => Color.lerp(c, Colors.black, 0.35)!;
  static Color _brighten(Color c) => Color.lerp(c, Colors.white, 0.4)!;
}
