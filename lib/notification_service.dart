import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutternotificationdemo/preference.dart';

FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

//private variable to check if Notification is already Selected;
bool _isNotificationSelected = false;

//Function to handle Notification data in background. Only Work on Android
Future<dynamic> backgroundMessageHandler(Map<String, dynamic> message) {
  return Future<void>.value();
}

//Function to handle Notification Click.
Future<void> onSelectNotification(String payload) {
  if (!_isNotificationSelected) {
    _isNotificationSelected = true;
  }
  _isNotificationSelected = false;
  return Future<void>.value();
}

//Navigate to a route when click on the notification
Future<dynamic> handleNotificationNavigation(dynamic data) {
  var routeName;
  var arguments;

  // Navigate To Route
}

//Function to parse Notification Data key
parseNotificationData(Map<String, dynamic> data) {}

//Function to Parse and Show Notification when app is in foreground
Future<dynamic> onMessage(Map<String, dynamic> message) {
  print('onMessage ${message.toString()}');
  Preference.setString(
      'key1', 'onMessage ${DateTime.now().toIso8601String()} ${message.toString()}');
  return Future<void>.value();
}

//Function to Handle notification click if app is in background
Future<dynamic> onResume(Map<String, dynamic> message) {
  print('onResume ${message.toString()}');
  Preference.setString(
      'key2', 'onResume ${DateTime.now().toIso8601String()} ${message.toString()}');

  return Future<void>.value();
}

//Function to Handle notification click if app is not in foreground neither in background
Future<dynamic> onLaunch(Map<String, dynamic> message) {
  print('onLaunche ${message.toString()}');
  Preference.setString(
      'key3', 'onLaunch ${DateTime.now().toIso8601String()} ${message.toString()}');

  return Future<void>.value();
}

class NotificationService {
  FirebaseMessaging _fcm = FirebaseMessaging();

  static final NotificationService _singleton = NotificationService._internal();

  factory NotificationService() {
    return _singleton;
  }

  NotificationService._internal() {
    initializeFcm();
  }

  void initializeFcm() async {
    // final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // const channelGroupId = 'educatlyNotificationGroupID';
    // if (Platform.isAndroid) {
    //   const androidNotificationChannelGroup = AndroidNotificationChannelGroup(
    //       channelGroupId, 'Educatly Group Notification Channel',
    //       description: 'Grouped notifications for Educatly.');

    //   await flutterLocalNotificationsPlugin
    //       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    //       .createNotificationChannelGroup(androidNotificationChannelGroup);

    //   await flutterLocalNotificationsPlugin
    //       .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    //       .createNotificationChannel(const AndroidNotificationChannel(
    //           'channelEducatly', 'channelEducatly', 'Notification channel for Educatly.',
    //           groupId: channelGroupId));
    // } else if (Platform.isIOS) {
    //   final iosNotificatiinGroup =
    //       IosNotificationSettings(alert: true, provisional: false, badge: true, sound: true);

    //   await flutterLocalNotificationsPlugin
    //       .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>().initialize(iosNotificatiinGroup)
    // }

    var initializationSettingsAndroid = AndroidInitializationSettings('in_app_notification');
    var initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (value) => onSelectNotification(value));

    if (Platform.isIOS) {
      _fcm.onIosSettingsRegistered.listen((data) {
        _saveDeviceToken();
      });

      await _fcm.requestNotificationPermissions(
          IosNotificationSettings(sound: true, alert: true, badge: true, provisional: true));
    } else {
      _saveDeviceToken();
    }

    _fcm.configure(
      onMessage: onMessage,
      onBackgroundMessage: Platform.isAndroid ? backgroundMessageHandler : null,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }

  // save the token  OR subscribe to a topic here
  _saveDeviceToken() async {
    String fcmToken = await _fcm.getToken();
    print("$fcmToken");
    //Subscribe to FCM Topic Here
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
  }
}
