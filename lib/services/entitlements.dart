import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Feature groups that used to sit behind the "Pace Pro" purchase. As of the
/// final free release everything is unlocked for everyone — the enum stays so
/// the gate call sites keep compiling, but [Entitlements.can] is always true.
enum PaceProFeature {
  /// Alternative neon palettes & skins for the cockpit.
  themes,

  /// Deep analytics: time-of-day patterns, triggers, trends.
  raceEngineer,

  /// Live Activity / Dynamic Island stint timer.
  liveActivity,
}

class Entitlements {
  const Entitlements({required this.isPro});

  final bool isPro;

  bool can(PaceProFeature feature) => isPro;
}

/// Everything is free now — always unlocked.
final entitlementsProvider =
    Provider<Entitlements>((ref) => const Entitlements(isPro: true));
