import 'package:flutter/foundation.dart';
import 'package:live_activities/live_activities.dart';

/// Bridges the current stint to an iOS Live Activity (Dynamic Island + lock
/// screen). Every call is guarded — a failure here must never break the app.
abstract final class LiveActivityService {
  static final LiveActivities _plugin = LiveActivities();
  static const String _appGroup = 'group.de.mgstudios.pace';
  static bool _inited = false;
  static String? _activityId;

  static Future<void> _ensureInit() async {
    if (_inited) return;
    await _plugin.init(appGroupId: _appGroup);
    _inited = true;
  }

  /// Start the live activity, or update it if one is already running.
  static Future<void> push(Map<String, dynamic> data) async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      await _ensureInit();
      if (_activityId != null) {
        await _plugin.updateActivity(_activityId!, data);
      } else {
        // Local-only activity — no push token, so we don't need (and don't
        // have) the Push-Notifications capability that remote updates require.
        _activityId = await _plugin.createActivity(
          'pace-stint',
          data,
          iOSEnableRemoteUpdates: false,
        );
      }
    } catch (_) {
      // ActivityKit unavailable / not permitted — ignore.
    }
  }

  /// End the live activity.
  static Future<void> stop() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    try {
      await _ensureInit();
      await _plugin.endAllActivities();
      _activityId = null;
    } catch (_) {}
  }
}
