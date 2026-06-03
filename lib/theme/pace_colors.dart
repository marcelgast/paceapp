import 'package:flutter/material.dart';

/// Y2K street-racing palette — NFS Underground 2 / Most Wanted at night.
/// Wet asphalt under neon: magenta, cyan, purple, plus the Most-Wanted orange.
abstract final class PaceColors {
  // Night surfaces — near-black with a purple cast.
  static const Color night = Color(0xFF0B0712);
  static const Color nightDeep = Color(0xFF06040A);
  static const Color panel = Color(0xFF15101F);
  static const Color panelLight = Color(0xFF1E1730);
  static const Color chrome = Color(0xFF2A2440);

  // Neon accents.
  static const Color neonMagenta = Color(0xFFFF2D95);
  static const Color neonMagentaDark = Color(0xFFB3146A);
  static const Color neonCyan = Color(0xFF19E0FF);
  static const Color neonPurple = Color(0xFF9B5CFF);
  static const Color neonOrange = Color(0xFFFF7A1E); // Most Wanted signature
  static const Color neonLime = Color(0xFF39FF6A);
  static const Color neonLimeBright = Color(0xFF8CFFB0);

  // Staging-tree bulbs.
  static const Color stageAmber = Color(0xFFFFB020);
  static const Color stageGreen = neonLime;

  // Text.
  static const Color textPrimary = Color(0xFFF3F0FA);
  static const Color textMuted = Color(0xFF9A93AD);
  static const Color textFaint = Color(0xFF5E5775);

  // Underglow gradient (buttons, accents).
  static const List<Color> underglow = [neonMagenta, neonPurple, neonCyan];

  // Gauge sweep, cool → hot (RPM / boost band).
  static const List<Color> rpmBand = [
    neonCyan,
    neonLime,
    neonOrange,
    neonMagenta,
  ];
}
