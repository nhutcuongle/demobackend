

import 'dart:typed_data';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  // ================= INIT =================
  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _notifications.initialize(initSettings);

    // 🔔 TẠO CHANNEL (BẮT BUỘC ANDROID 8+)
    final androidPlugin =
    _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      const eventChannel = AndroidNotificationChannel(
        'event_channel',
        'Event Reminder',
        description: 'Nhắc nhở sự kiện',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      const reminderChannel = AndroidNotificationChannel(
        'reminder_channel',
        'Reminder',
        description: 'Nhắc nhở trước giờ sự kiện',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await androidPlugin.createNotificationChannel(eventChannel);
      await androidPlugin.createNotificationChannel(reminderChannel);
    }
  }

  // ================= EVENT NOTIFICATION =================
  static Future<void> scheduleEventNotification({
    required int id,
    required String title,
    String? body,
    required DateTime time,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body ?? "Sự kiện của bạn sắp bắt đầu",
      tz.TZDateTime.from(time, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'event_channel',
          'Event Reminder',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ================= REMINDER NOTIFICATION (RUNG ~10 GIÂY) =================
  static Future<void> scheduleReminderNotification({
    required int id,
    required String title,
    String? body,
    required DateTime time,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body ?? "Sắp đến giờ sự kiện",
      tz.TZDateTime.from(time, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,

          // 🔔 RUNG ~10 GIÂY (5s rung + 5s nghỉ)
          vibrationPattern: Int64List.fromList([
            0,    // delay
            500,  // rung
            500,  // nghỉ
            500,
            500,
            500,
            500,
            500,
            500,
            500,
            500,
          ]),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentSound: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // ================= CANCEL =================
  static Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
