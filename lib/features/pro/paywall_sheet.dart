import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../services/entitlements.dart';
import '../../services/pace_pro_store.dart';
import '../../theme/pace_colors.dart';

/// Shows the one-time "Pace Pro" purchase sheet. Auto-dismisses once the
/// purchase (or a restore) completes and the entitlement flips to Pro.
Future<void> showPaceProPaywall(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _Paywall(),
  );
}

class _Paywall extends ConsumerStatefulWidget {
  const _Paywall();

  @override
  ConsumerState<_Paywall> createState() => _PaywallState();
}

class _PaywallState extends ConsumerState<_Paywall> {
  late final PaceProStore _store;

  @override
  void initState() {
    super.initState();
    _store = ref.read(paceProStoreProvider);
    _store.addListener(_onStore);
  }

  @override
  void dispose() {
    _store.removeListener(_onStore);
    super.dispose();
  }

  void _onStore() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Close the sheet the moment the purchase/restore unlocks Pro.
    ref.listen<Entitlements>(entitlementsProvider, (_, next) {
      if (next.isPro && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });

    final price = _store.priceLabel;
    final pending = _store.purchasePending;

    return Container(
      decoration: const BoxDecoration(
        color: PaceColors.night,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: PaceColors.chrome,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  ShaderMask(
                    shaderCallback: (b) => LinearGradient(
                      colors: PaceColors.underglow,
                    ).createShader(b),
                    child: const Text(
                      'Pace Pro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.paywallSubtitle,
                style: const TextStyle(
                    color: PaceColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 22),
              _Feature(
                icon: Icons.insights,
                title: l10n.settingsProRaceEngineer,
                subtitle: l10n.settingsProRaceEngineerSub,
              ),
              _Feature(
                icon: Icons.palette_outlined,
                title: l10n.paywallThemesTitle,
                subtitle: l10n.paywallThemesSub,
              ),
              _Feature(
                icon: Icons.bolt,
                title: l10n.settingsProLiveActivity,
                subtitle: l10n.settingsProLiveActivitySub,
              ),
              const SizedBox(height: 8),
              if (_store.hasError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _store.available
                        ? l10n.paywallError
                        : l10n.paywallUnavailable,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: PaceColors.neonOrange, fontSize: 13),
                  ),
                ),
              _BuyButton(
                label: price == null
                    ? l10n.paywallUnlockNoPrice
                    : l10n.paywallUnlock(price),
                pending: pending,
                onTap: pending ? null : _store.buy,
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: pending ? null : _store.restore,
                child: Text(
                  l10n.paywallRestore,
                  style: TextStyle(
                      color: PaceColors.textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.paywallOneTime,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: PaceColors.textFaint, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: PaceColors.neonMagenta.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: PaceColors.neonMagenta.withValues(alpha: 0.4)),
            ),
            child: Icon(icon, color: PaceColors.neonMagenta, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: PaceColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        color: PaceColors.textMuted, fontSize: 12.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BuyButton extends StatelessWidget {
  const _BuyButton({
    required this.label,
    required this.pending,
    required this.onTap,
  });

  final String label;
  final bool pending;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: PaceColors.underglow),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: PaceColors.neonMagenta.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: pending
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    strokeWidth: 2.5, color: Colors.white),
              )
            : Text(
                label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5),
              ),
      ),
    );
  }
}
