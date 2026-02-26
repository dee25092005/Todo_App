import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timezone/timezone.dart' as tz;

part 'notification.g.dart';

@riverpod
NotificationService notificationService(NotificationServiceRef ref) {
  return NotificationService();
}

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    // Request normal notification permission
    await androidImplementation?.requestNotificationsPermission();

    // 🔥 ADD THIS: Request Exact Alarm permission for Android 13+
    await androidImplementation?.requestExactAlarmsPermission();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: DarwinInitializationSettings(),
        );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> cancelNotification(String taskId) async {
    await _notificationsPlugin.cancel(taskId.hashCode);
    debugPrint('Notification canceled for task: $taskId');
  }

  Future<void> scheduleTaskNotification(
    String taskId,
    String title,
    DateTime scheduledTime,
  ) async {
    debugPrint('Scheduling for: $scheduledTime');

    await _notificationsPlugin.zonedSchedule(
      taskId.hashCode,
      'Task Reminder!!',
      title,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        // <--- Start of Details
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Notifications',
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );

    debugPrint('✅ Notification successfully scheduled!');
  }
}
