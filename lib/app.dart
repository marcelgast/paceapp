import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'l10n/app_localizations.dart';
import 'features/gamification/celebration_host.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/proposal/proposal_host.dart';
import 'features/shell/home_shell.dart';
import 'providers.dart';
import 'services/pace_pro_store.dart';
import 'theme/pace_colors.dart';
import 'theme/pace_theme.dart';

class PaceApp extends ConsumerWidget {
  const PaceApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Apply the selected skin's accents before the tree builds; re-keying the
    // subtree on skin change forces every widget to re-read the new colours.
    final skin = ref.watch(skinProvider);
    PaceColors.applySkin(skin);
    // Keep the purchase store alive for the app's lifetime so StoreKit
    // purchases and restores are always caught by its stream listener.
    ref.watch(paceProStoreProvider);
    SystemChrome.setSystemUIOverlayStyle(PaceTheme.overlay);
    return MaterialApp(
      title: 'Pace',
      debugShowCheckedModeBanner: false,
      theme: PaceTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      // Follow the device language (German or English); falls back to German.
      home: KeyedSubtree(key: ValueKey(skin.id), child: const _Gate()),
    );
  }
}

/// Routes to onboarding until settings exist, then to the cockpit shell.
class _Gate extends ConsumerWidget {
  const _Gate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    return settings.when(
      loading: () => const _Splash(),
      error: (_, _) => const _Splash(),
      data: (row) => (row?.onboardingDone ?? false)
          ? const ProposalHost(child: CelebrationHost(child: HomeShell()))
          : const OnboardingScreen(),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PaceColors.night,
      body: Center(
        child: CircularProgressIndicator(color: PaceColors.neonMagenta),
      ),
    );
  }
}
