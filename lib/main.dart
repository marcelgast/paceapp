import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'services/notification_service.dart';
import 'services/widget_service.dart';

void main() {
  // Guard against uncaught async errors from native plugins — e.g. home_widget's
  // objective_c framework failing to load on the iOS simulator. Such errors must
  // never block the app, the database or the UI from loading.
  runZonedGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    runApp(const ProviderScope(child: PaceApp()));
    unawaited(_bootstrapPlugins());
  }, (error, stack) {
    debugPrint('Uncaught (ignored): $error');
  });
}

Future<void> _bootstrapPlugins() async {
  try {
    await NotificationService.init();
  } catch (_) {}
  try {
    await WidgetService.init();
  } catch (_) {}
}
