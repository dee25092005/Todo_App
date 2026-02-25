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
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

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
    await _notificationsPlugin.zonedSchedule(
      taskId.hashCode,
      'Task Reminder!!',
      title,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'task Notification',
          importance: Importance.max,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('notification_sound'),
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
