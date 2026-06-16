import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app.dart';
import 'data/database.dart';
import 'features/shell/home_shell.dart';
import 'services/demo_seeder.dart';
import 'services/notification_service.dart';
import 'services/widget_service.dart';

// Compile-time flags used only by the App Store screenshot tooling.
const bool _seedDemo = bool.fromEnvironment('SEED_DEMO');
const bool _shots = bool.fromEnvironment('SHOTS');

void main() {
  // Guard against uncaught async errors from native plugins — e.g. home_widget's
  // objective_c framework failing to load on the iOS simulator. Such errors must
  // never block the app, the database or the UI from loading.
  runZonedGuarded(() async {
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
    if (_shots) await _applyShotTab();
    runApp(const ProviderScope(child: PaceApp()));
    unawaited(_bootstrapPlugins());
  }, (error, stack) {
    debugPrint('Uncaught (ignored): $error');
  });
}

/// Reads `Documents/shot_tab.txt` (written by the screenshot script between
/// launches) so we can switch the initial tab without rebuilding.
Future<void> _applyShotTab() async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'shot_tab.txt'));
    if (file.existsSync()) {
      kDemoInitialTab = int.tryParse(file.readAsStringSync().trim()) ?? 0;
    }
  } catch (_) {}
}

Future<void> _bootstrapPlugins() async {
  try {
    await NotificationService.init();
  } catch (_) {}
  try {
    await WidgetService.init();
  } catch (_) {}
}
