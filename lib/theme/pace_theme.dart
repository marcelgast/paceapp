import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pace_colors.dart';

/// Central theme. Dashboard numerics use Rajdhani (digital-dash feel),
/// body copy uses Inter for legibility.
abstract final class PaceTheme {
  static const SystemUiOverlayStyle overlay = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: PaceColors.night,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  /// Condensed technical face for big numbers / gauges.
  static TextStyle dash({
    double size = 48,
    FontWeight weight = FontWeight.w700,
    Color color = PaceColors.textPrimary,
    double letterSpacing = 0.5,
    bool italic = false,
  }) {
    return GoogleFonts.rajdhani(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: letterSpacing,
      height: 1.0,
      fontStyle: italic ? FontStyle.italic : FontStyle.normal,
    );
  }

  /// Neon glow shadow stack for text / wordmarks.
  static List<Shadow> neonGlow(Color color, {double blur = 18}) => [
        Shadow(color: color, blurRadius: blur),
        Shadow(color: color.withValues(alpha: 0.6), blurRadius: blur * 2),
      ];

  static ThemeData dark() {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = GoogleFonts.interTextTheme(base.textTheme).apply(
      bodyColor: PaceColors.textPrimary,
      displayColor: PaceColors.textPrimary,
    );

    return base.copyWith(
      scaffoldBackgroundColor: PaceColors.night,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: PaceColors.neonMagenta,
        secondary: PaceColors.neonCyan,
        tertiary: PaceColors.neonPurple,
        surface: PaceColors.panel,
        onPrimary: PaceColors.textPrimary,
        onSurface: PaceColors.textPrimary,
      ),
      splashColor: PaceColors.neonMagenta.withValues(alpha: 0.12),
      highlightColor: Colors.transparent,
      cardTheme: const CardThemeData(
        color: PaceColors.panel,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      dividerColor: PaceColors.chrome.withValues(alpha: 0.6),
    );
  }
}
