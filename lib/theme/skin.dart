import 'package:flutter/material.dart';

/// A neon palette the user can switch (Pro). Each skin redefines the five
/// accent roles; surfaces (night/panel/chrome/text) stay fixed so contrast and
/// legibility hold across every skin.
class Skin {
  const Skin({
    required this.id,
    required this.name,
    required this.magenta,
    required this.cyan,
    required this.purple,
    required this.orange,
    required this.lime,
  });

  final String id;
  final String name;
  final Color magenta; // primary brand accent
  final Color cyan; // info / countdown
  final Color purple; // secondary
  final Color orange; // warning / Most-Wanted
  final Color lime; // success / overtime

  static const Skin underground = Skin(
    id: 'underground',
    name: 'Underground',
    magenta: Color(0xFFFF2D95),
    cyan: Color(0xFF19E0FF),
    purple: Color(0xFF9B5CFF),
    orange: Color(0xFFFF7A1E),
    lime: Color(0xFF39FF6A),
  );

  static const List<Skin> all = [
    underground,
    Skin(
      id: 'sunset',
      name: 'Sunset Strip',
      magenta: Color(0xFFFF3D6E),
      cyan: Color(0xFFFFC24B),
      purple: Color(0xFFC44BFF),
      orange: Color(0xFFFF7A2C),
      lime: Color(0xFFFFD23B),
    ),
    Skin(
      id: 'toxic',
      name: 'Toxic',
      magenta: Color(0xFFB6FF1A),
      cyan: Color(0xFF1AFFC3),
      purple: Color(0xFF8CFF3B),
      orange: Color(0xFFE0FF00),
      lime: Color(0xFF39FF6A),
    ),
    Skin(
      id: 'ice',
      name: 'Ice',
      magenta: Color(0xFF4FC3FF),
      cyan: Color(0xFF8AE6FF),
      purple: Color(0xFF6E8BFF),
      orange: Color(0xFF00E5FF),
      lime: Color(0xFFB0F0FF),
    ),
    Skin(
      id: 'vapor',
      name: 'Vaporwave',
      magenta: Color(0xFFFF6AD5),
      cyan: Color(0xFF6EE7FF),
      purple: Color(0xFFB388FF),
      orange: Color(0xFFFF8AC2),
      lime: Color(0xFF8AF0E0),
    ),
    Skin(
      id: 'police',
      name: 'Police',
      magenta: Color(0xFFFF2D4B), // siren red
      cyan: Color(0xFF2D7BFF), // siren blue
      purple: Color(0xFF5468FF),
      orange: Color(0xFFFF5630),
      lime: Color(0xFF36C5FF),
    ),
    Skin(
      id: 'nightshade',
      name: 'Nightshade',
      magenta: Color(0xFFB14BFF), // deep purple
      cyan: Color(0xFF00C2A8), // teal pop
      purple: Color(0xFF7A1FFF),
      orange: Color(0xFFD24BFF),
      lime: Color(0xFF8C5CFF),
    ),
    Skin(
      id: 'inferno',
      name: 'Inferno',
      magenta: Color(0xFFFF4D2E), // fire
      cyan: Color(0xFFFFB020), // amber
      purple: Color(0xFFFF6A3D),
      orange: Color(0xFFFF2A1A), // deep red
      lime: Color(0xFFFFD23B), // flame yellow
    ),
    Skin(
      id: 'podium',
      name: 'Podium',
      magenta: Color(0xFFFFC93C), // champagne gold
      cyan: Color(0xFF2BD9C0), // teal pop
      purple: Color(0xFFFFD24B),
      orange: Color(0xFFFF9E2C),
      lime: Color(0xFFFFE45C),
    ),
    Skin(
      id: 'chrome',
      name: 'Chrome',
      magenta: Color(0xFFE8ECF5), // chrome white
      cyan: Color(0xFF9FD8FF), // icy
      purple: Color(0xFFC4B5FD), // soft lilac
      orange: Color(0xFFFF5C7A), // warm pop
      lime: Color(0xFFA0FFC8), // mint
    ),
  ];

  static Skin byId(String? id) =>
      all.firstWhere((s) => s.id == id, orElse: () => underground);
}
