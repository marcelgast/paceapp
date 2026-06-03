import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Schedules the "your stint is complete" notification so the reward lands even
/// when the app is closed. The countdown itself is timestamp-based, so it never
/// pauses — this only surfaces the moment it crosses into overtime.
abstract final class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const int _stintId = 1;

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Falls back to UTC; scheduling still works, just in UTC reference.
    }
    const settings = InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await _plugin.initialize(settings: settings);
  }

  static Future<void> requestPermission() async {
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } catch (_) {}
  }

  /// (Re)schedule the overtime notification for the active stint.
  static Future<void> scheduleStintComplete(DateTime at) async {
    if (!at.isAfter(DateTime.now())) return;
    try {
      await _plugin.cancel(id: _stintId);
      await _plugin.zonedSchedule(
      id: _stintId,
      title: 'Stint geschafft! 🏁',
      body: 'Du bist in der Overtime — ab jetzt ist jede Sekunde geschenkte Zeit.',
      scheduledDate: tz.TZDateTime.from(at, tz.local),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      notificationDetails: const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          'stint',
          'Stint-Ende',
          channelDescription: 'Meldet, wenn dein Ziel-Stint erreicht ist.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      );
    } catch (_) {}
  }

  static Future<void> cancelStint() => _plugin.cancel(id: _stintId);
}
