import 'dart:convert';
import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  late final FlutterLocalNotificationsPlugin _localNotifications;
  late final FirebaseMessaging _firebaseMessaging;

  NotificationService._internal() {
    _localNotifications = FlutterLocalNotificationsPlugin();
    _firebaseMessaging = FirebaseMessaging.instance;
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);

    // Initialize local notifications
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    // const iosSettings = DarwinInitializationSettings(
    //   requestSoundPermission: true,
    //   requestBadgePermission: true,
    //   requestAlertPermission: true,
    // );

    await _localNotifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        // iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTapBackground);

    // Register FCM Token with Appwrite
    _setupFCMToken();
  }

  void _handleNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
  }

  void _handleNotificationTapBackground(RemoteMessage message) {
    debugPrint('Background notification tapped: ${message.messageId}');
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Received foreground message: ${message.messageId}');

    await _showLocalNotification(
      title: message.notification?.title ?? 'New Message',
      body: message.notification?.body ?? '',
      payload: message.data.toString(),
    );
  }

  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      const NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
      payload: payload,
    );
  }

  Future<void> _setupFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    log("FCM Token: $token");
    if (token != null) {
      await _registerPushToken(token);
    }

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      log("FCM Token Refresh: $token");
      await _registerPushToken(newToken);
    });
  }

  Future<void> _registerPushToken(String token) async {
    try {
      if (user != null) {
        log("${user?.email} | ${user?.$id}");
        await account.createPushTarget(
          targetId: user!.$id,
          identifier: token,
          providerId: notifcationProviderId,
        );
        await messaging.createSubscriber(
          topicId: notifcationsTopic,
          subscriberId: ID.unique(),
          targetId: user!.$id,
        );
        debugPrint("FCM Token registered in Appwrite: $token");
      }
    } on AppwriteException catch (e) {
      debugPrint("Error registering FCM token in Appwrite: ${e.message}");
    }
  }

  Future<void> removeExpiredToken() async {
    try {
      if (user != null) {
        await account.deletePushTarget(targetId: user!.$id);
        debugPrint("Expired FCM Token removed from Appwrite");
      }
    } on AppwriteException catch (e) {
      debugPrint("Error removing expired token: ${e.message}");
    }
  }

  static Future<void> sendPushNotification(title, body, userIds) async {
    try {
      debugPrint(title);
      debugPrint(body);
      debugPrint(userIds);

      var execution = await functions.createExecution(
        functionId: funId,
        body: jsonEncode({
          'title': title,
          'body': body,
          'users': userIds,
        }),
        path: sendMsgPath,
      );
      debugPrint("Push notification status: " + execution.responseBody);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
