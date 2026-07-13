import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../../services/notification_service.dart';

/// Watches savings goals against the saved-money pool. The first time a goal is
/// reached it marks it (so the badge sticks) and fires a notification — exactly
/// once per goal, guarded by an in-memory set against the per-second recompute.
class GoalWatcher extends ConsumerStatefulWidget {
  const GoalWatcher({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<GoalWatcher> createState() => _GoalWatcherState();
}

class _GoalWatcherState extends ConsumerState<GoalWatcher> {
  final _handled = <String>{};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    ref.listen(unmarkedReachedGoalsProvider, (_, next) {
      for (final g in next) {
        if (_handled.add(g.id)) {
          ref
              .read(databaseProvider)
              .markSavingsGoalReached(g.id, DateTime.now());
          NotificationService.showGoalReached(
            title: l10n.notifGoalTitle,
            body: l10n.notifGoalBody(g.name),
          );
        }
      }
    });
    return widget.child;
  }
}
