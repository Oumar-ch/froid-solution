import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../config/app_config.dart';

class NotificationService {
  static String get notificationKey =>
      AppConfig.isProduction ? 'PROD_KEY' : 'DEV_KEY';
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(BuildContext context) async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: DarwinInitializationSettings(),
        );
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Optionally handle notification tap
      },
    );
  }

  static Future<void> scheduleInterventionNotifications({
    required int id,
    required String title,
    required String body,
    required DateTime interventionDate,
  }) async {
    // 3 jours avant
    final DateTime threeDaysBefore = interventionDate.subtract(
      const Duration(days: 3),
    );
    if (threeDaysBefore.isAfter(DateTime.now())) {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        'Intervention prévue dans 3 jours : $body',
        _toTZDateTime(threeDaysBefore),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'intervention_channel',
            'Interventions',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    }
    // Le jour J
    if (interventionDate.isAfter(DateTime.now())) {
      await _notificationsPlugin.zonedSchedule(
        id + 100000, // Unique id for day-of notification
        title,
        'Intervention aujourd\'hui : $body',
        _toTZDateTime(interventionDate),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'intervention_channel',
            'Interventions',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
    }
  }

  static tz.TZDateTime _toTZDateTime(DateTime dateTime) {
    return tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
    );
  }
}
