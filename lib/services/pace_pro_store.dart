import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../data/database.dart';
import '../providers.dart';

/// App Store Connect product id for the one-time "Pace Pro" unlock.
/// Must match the non-consumable IAP created in App Store Connect exactly.
const String kProProductId = 'de.mgstudios.pace.pro';

/// Drives the one-time "Pace Pro" purchase against StoreKit and persists the
/// result locally via [AppDatabase.setProPurchased]. The entitlement itself is
/// read reactively from the settings stream — this store only flips the flag
/// and exposes the buy/restore UX state (price, pending, error) to the paywall.
class PaceProStore extends ChangeNotifier {
  PaceProStore(this._db);

  final AppDatabase _db;
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;

  bool available = false;
  ProductDetails? product;
  bool purchasePending = false;

  /// True after the last buy/restore failed for a non-cancel reason. The UI
  /// shows a friendly message — the raw StoreKit error stays internal.
  bool hasError = false;

  String? get priceLabel => product?.price;

  Future<void> init() async {
    try {
      available = await _iap.isAvailable();
    } catch (_) {
      available = false;
    }
    if (!available) {
      notifyListeners();
      return;
    }
    _sub = _iap.purchaseStream.listen(
      _onPurchases,
      onError: (Object _) {
        purchasePending = false;
        hasError = true;
        notifyListeners();
      },
    );
    await _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final resp = await _iap.queryProductDetails({kProProductId});
      if (resp.productDetails.isNotEmpty) {
        product = resp.productDetails.first;
      }
    } catch (_) {
      // Leave product null — the paywall handles the unavailable case.
    }
    notifyListeners();
  }

  Future<void> buy() async {
    if (product == null) await _loadProduct();
    final pd = product;
    if (pd == null) {
      hasError = true;
      notifyListeners();
      return;
    }
    hasError = false;
    purchasePending = true;
    notifyListeners();
    try {
      await _iap.buyNonConsumable(purchaseParam: PurchaseParam(productDetails: pd));
    } catch (_) {
      purchasePending = false;
      hasError = true;
      notifyListeners();
    }
  }

  Future<void> restore() async {
    hasError = false;
    purchasePending = true;
    notifyListeners();
    try {
      await _iap.restorePurchases();
    } catch (_) {
      hasError = true;
    }
    // Results (if any) arrive via the stream; drop the spinner regardless.
    purchasePending = false;
    notifyListeners();
  }

  Future<void> _onPurchases(List<PurchaseDetails> purchases) async {
    for (final p in purchases) {
      if (p.productID != kProProductId) {
        if (p.pendingCompletePurchase) await _iap.completePurchase(p);
        continue;
      }
      switch (p.status) {
        case PurchaseStatus.pending:
          purchasePending = true;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          await _db.setProPurchased(true);
          purchasePending = false;
          hasError = false;
        case PurchaseStatus.error:
          purchasePending = false;
          hasError = true;
        case PurchaseStatus.canceled:
          purchasePending = false;
      }
      if (p.pendingCompletePurchase) await _iap.completePurchase(p);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

/// App-lifetime singleton. Watched at the app root so the purchase stream is
/// always listening (catches restores and purchases completing in the
/// background), and read by the paywall for buy/restore.
final paceProStoreProvider = Provider<PaceProStore>((ref) {
  final store = PaceProStore(ref.read(databaseProvider));
  store.init();
  ref.onDispose(store.dispose);
  return store;
});
