import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'data/database.dart';
import 'services/demo_seeder.dart';
import 'services/notification_service.dart';
import 'services/widget_service.dart';

/// Seeds a realistic demo dataset on launch. Off unless built with
/// `--dart-define=SEED_DEMO=true` — used only to produce a populated app for
/// screenshots and never ships enabled.
const bool _seedDemo = bool.fromEnvironment('SEED_DEMO');

void main() {
  // Native plugins (e.g. home_widget's objective_c framework, Live Activities)
  // can throw asynchronously on startup — most reliably on the iOS simulator.
  // Those failures are non-fatal: the timeline widget simply won't update, and
  // the app, database and UI must still come up. We guard the zone so such an
  // error can never take the whole app down, and surface it in debug logs.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      if (_seedDemo) {
        final db = AppDatabase();
        try {
          await seedDemoData(db);
        } catch (e) {
          debugPrint('Demo seed failed: $e');
        }
        await db.close();
      }
      runApp(const ProviderScope(child: PaceApp()));
      unawaited(_bootstrapPlugins());
    },
    (error, stack) {
      debugPrint('Uncaught async error (non-fatal, ignored): $error');
    },
  );
}

Future<void> _bootstrapPlugins() async {
  try {
    await NotificationService.init();
  } catch (_) {}
  try {
    await WidgetService.init();
  } catch (_) {}
}
