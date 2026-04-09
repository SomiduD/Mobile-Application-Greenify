import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  static final _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> init() async {
    // 1. Request permission from the user (Shows the pop-up)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) print('User granted permission for Notifications');
    }

    // 2. Listen for messages while the app is actively open
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        if (kDebugMode) {
          print('Foreground Notification Received: ${message.notification!.title}');
        }
        // Note: You can add a SnackBar here later if you want in-app popups!
      }
    });
  }
}