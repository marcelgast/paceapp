import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Premium features Pace will gate once monetisation goes live. Race Cards are
/// deliberately NOT in here — sharing stays free forever.
enum PaceProFeature {
  /// Alternative neon palettes & graffiti skins (first paid feature).
  themes,
}

/// Single source of truth for paid entitlements.
///
/// Monetisation is not live yet: the app ships fully free for the test phase,
/// so [Entitlements.freePhase] unlocks everything. When StoreKit is wired,
/// replace [entitlementsProvider] with the real purchase-backed state — every
/// `ref.watch(entitlementsProvider).can(feature)` call in the UI then starts
/// gating without further changes.
class Entitlements {
  const Entitlements({required this.isPro});

  /// Test phase: all premium features unlocked, no purchase required.
  const Entitlements.freePhase() : isPro = true;

  final bool isPro;

  bool can(PaceProFeature feature) => isPro;
}

final entitlementsProvider =
    Provider<Entitlements>((ref) => const Entitlements.freePhase());
