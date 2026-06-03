import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

import '../domain/stint_calculator.dart';
import '../providers.dart';
import '../util/format.dart';

/// Bridges app state to the iOS home-screen widget via the shared App Group.
/// The widget renders a self-updating SwiftUI timer from [timerRef], so we only
/// push fresh data on meaningful changes — not every second.
abstract final class WidgetService {
  static const appGroupId = 'group.de.mgstudios.pace';
  static const iosWidgetName = 'PaceWidget';

  static Future<void> init() async {
    await HomeWidget.setAppGroupId(appGroupId);
  }

  static Future<void> write({
    required bool isBaseline,
    required DateTime timerRef,
    required String bestLabel,
    required String savedMoney,
    required String carName,
    required int streak,
  }) async {
    await HomeWidget.saveWidgetData<String>('is_baseline', isBaseline ? '1' : '0');
    await HomeWidget.saveWidgetData<int>(
        'timer_ref_ms', timerRef.millisecondsSinceEpoch);
    await HomeWidget.saveWidgetData<String>('best_label', bestLabel);
    await HomeWidget.saveWidgetData<String>('saved_money', savedMoney);
    await HomeWidget.saveWidgetData<String>('car_name', carName);
    await HomeWidget.saveWidgetData<int>('streak', streak);
    await HomeWidget.updateWidget(iOSName: iosWidgetName);
  }
}

/// Reads the current state and pushes it to the widget. Safe to call even
/// before the widget extension exists (updateWidget then simply no-ops).
Future<void> pushPaceWidget(WidgetRef ref) async {
  final settings = ref.read(settingsProvider).value;
  if (settings == null) return;

  final now = DateTime.now();
  final stint = ref.read(liveStintProvider);
  final stats = ref.read(statsProvider);
  final target = ref.read(targetIntervalProvider);
  final car = ref.read(currentCarProvider);
  final streak = ref.read(streakProvider).current;
  final pitStops = ref.read(pitStopsProvider).value ?? const [];

  // Chronological order to measure clean stretches.
  final asc = [...pitStops]..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
  final lastPit = asc.isNotEmpty ? asc.last.occurredAt : settings.startedAt;

  // Best stint = longest clean stretch (start→first, between pits, last→now).
  var best = Duration.zero;
  var prev = settings.startedAt;
  for (final p in asc) {
    final d = p.occurredAt.difference(prev);
    if (d > best) best = d;
    prev = p.occurredAt;
  }
  final ongoing = now.difference(prev);
  if (ongoing > best) best = ongoing;

  final isBaseline = (stint?.phase ?? StintPhase.baseline) == StintPhase.baseline;
  final timerRef =
      isBaseline ? lastPit : lastPit.add(target ?? Duration.zero);

  try {
    await WidgetService.init();
    await WidgetService.write(
      isBaseline: isBaseline,
      timerRef: timerRef,
      bestLabel: formatHumanDuration(best),
      savedMoney: stats == null
          ? '—'
          : formatMoneyCents(stats.savedMoneyCents,
              currencyCode: settings.currencyCode),
      carName: car.name,
      streak: streak,
    );
  } catch (_) {
    // home_widget can fail on the iOS simulator (objective_c framework) —
    // never let widget updates break the app.
  }
}
