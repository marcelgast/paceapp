import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

/// Premium features behind the one-time "Pace Pro" purchase. Race Cards and
/// everything that helps you quit stay free forever — only added value is paid.
enum PaceProFeature {
  /// Alternative neon palettes & skins for the cockpit.
  themes,

  /// Deep analytics: time-of-day patterns, triggers, trends.
  raceEngineer,

  /// Live Activity / Dynamic Island stint timer.
  liveActivity,
}

/// Single source of truth for paid entitlements.
///
/// Backed by the locally persisted `proPurchased` flag (set by [PaceProStore]
/// on a verified StoreKit purchase or restore). Every
/// `ref.watch(entitlementsProvider).can(feature)` in the UI gates against it.
class Entitlements {
  const Entitlements({required this.isPro});

  final bool isPro;

  bool can(PaceProFeature feature) => isPro;
}

final entitlementsProvider = Provider<Entitlements>((ref) {
  final purchased = ref.watch(settingsProvider).value?.proPurchased ?? false;
  return Entitlements(isPro: purchased);
});
