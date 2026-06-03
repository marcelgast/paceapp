import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/stint_calculator.dart';
import '../../providers.dart';
import '../../services/notification_service.dart';
import '../../services/widget_service.dart';
import 'pit_stop_sheet.dart';

/// Shared pit-stop flow: opens the form, persists the entry, (re)schedules the
/// stint notification and refreshes the widget. Used by the cockpit button and
/// by the widget deep link, so both behave identically.
Future<void> recordPitStop(BuildContext context, WidgetRef ref) async {
  final stint = ref.read(liveStintProvider);
  final forwardTarget = ref.read(targetIntervalProvider);
  final settings = ref.read(settingsProvider).value;

  HapticFeedback.selectionClick();
  final draft = await showPitStopSheet(context);
  if (draft == null) return;

  final now = DateTime.now();
  final target = stint?.target;
  await ref.read(databaseProvider).addPitStop(
        occurredAt: now,
        cravingLevel: draft.cravingLevel,
        stressLevel: draft.stressLevel,
        situationId: draft.situationId,
        wasEarlyPit: stint?.phase == StintPhase.countdown,
        targetIntervalSeconds:
            (target != null && target > Duration.zero) ? target.inSeconds : null,
        note: draft.note,
      );
  HapticFeedback.mediumImpact();

  final inBaseline = settings != null &&
      now.difference(settings.startedAt) < StintCalculator.baselineDuration;
  if (!inBaseline && forwardTarget != null && forwardTarget > Duration.zero) {
    await NotificationService.scheduleStintComplete(now.add(forwardTarget));
  }
  await pushPaceWidget(ref);
}
