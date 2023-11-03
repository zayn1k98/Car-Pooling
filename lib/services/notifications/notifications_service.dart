import 'dart:developer';
import 'package:car_pooling/constants/constants.dart';
import 'package:car_pooling/models/message_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    await firebaseMessaging.requestPermission();

    final fcmToken = await firebaseMessaging.getToken();

    log("FCM TOKEN : $fcmToken");

    sharedPreferences.setString('pushToken', fcmToken ?? "");

    // FirebaseMessaging.onBackgroundMessage(
    //   (message) => handleBackgroundMessage(message),
    // );
  }

  Future<void> sendNotification({
    required String pushToken,
    required String title, //? title will be the chat sender's name
    required String body, //? body will be the text from the chat sender
    required MessageType messageType,

    //! for body if notification is a text, it will display the text
    //! if it's an image, it will show "user sent an image"
    //! if it's a file, it will show "user sent an attachment"
  }) async {
    const String url = Constants.sendNotificationURL;

    String notificationBody = messageType == MessageType.image
        ? "sent an image"
        : messageType == MessageType.file
            ? "sent an attachment"
            : body;

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer ${Constants.fcmServerToken}',
        },
        body: {
          'to': pushToken,
          'notification': {
            'title': title,
            'body': notificationBody,
          },
        },
      );

      log("RESPONSE : $response");
    } catch (e) {
      log("ERROR : $e");
    }
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  log("Title : ${message.notification!.title}");
  log("Body : ${message.notification!.body}");
  log("Data : ${message.data}");
}
