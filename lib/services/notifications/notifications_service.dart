import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();

    final fcmToken = await firebaseMessaging.getToken();

    log("FCM TOKEN : $fcmToken");

    FirebaseMessaging.onBackgroundMessage(
      (message) => handleBackgroundMessage(message),
    );
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log("Title : ${message.notification!.title}");
  log("Body : ${message.notification!.body}");
  log("Data : ${message.data}");
}
