import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin
      flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> requestPermission() async {
    const AndroidFlutterLocalNotificationsPlugin android =
        AndroidFlutterLocalNotificationsPlugin();
    await android.requestPermission();
  }

  static Future<void> scheduleDailyNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_love_channel',
      'Daily Love Messages',
      channelDescription: 'Channel for daily love messages',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Made for Iram',
      'You have a new love message waiting!',
      RepeatInterval.daily,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }
}
