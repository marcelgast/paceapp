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
  ];

  static Skin byId(String? id) =>
      all.firstWhere((s) => s.id == id, orElse: () => underground);
}
