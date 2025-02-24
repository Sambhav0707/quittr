import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

abstract class LocalNotificationDataSource {
  Future<void> initialize();
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required Duration delay,
  });

  //these two are for testing if the notifications are working or not 
  Future<void> scheduleSimpleNotification();
  Future<void> showInstantNotification();
}

class LocalNotificationDataSourceImpl implements LocalNotificationDataSource {
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  LocalNotificationDataSourceImpl(this.notificationsPlugin);

  @override
  Future<void> initialize() async {
    log("Initializing Local Notification Data Source...");
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    final bool? initialized =
        await notificationsPlugin.initialize(initializationSettings);

    if (initialized != null && initialized) {
      log("Local Notification Plugin Initialized Successfully!");
    } else {
      log("Failed to initialize Local Notification Plugin!");
    }
  }

  @override
  Future<void> scheduleNotification({
    required String title,
    required String body,
    required Duration delay,
  }) async {
    log("Scheduling notification in ${delay.inSeconds} seconds...");

    tz.initializeTimeZones(); // Ensure this is called

    final tz.TZDateTime scheduledTime = tz.TZDateTime.now(tz.local).add(delay);

    await notificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'Scheduled Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    log("Notification scheduled successfully at: $scheduledTime");
  }

  @override
  Future<void> scheduleSimpleNotification() async {
    log("Scheduling a test notification in 5 seconds...");

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_channel_id',
      'Test Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await Future.delayed(const Duration(seconds: 5), () async {
      await notificationsPlugin.show(
        1,
        'Scheduled Test',
        'This is a test notification that was scheduled!',
        platformChannelSpecifics,
      );
      log("Scheduled Test notification sent!");
    });

    log("Scheduled notification setup complete.");
  }

  @override
  Future<void> showInstantNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_channel_id',
      'Test Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );

    await notificationsPlugin.show(
      0,
      'Test Notification',
      'This is an immediate test notification!',
      platformChannelSpecifics,
    );

    log("Test notification sent!");
  }
}
