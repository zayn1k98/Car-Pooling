import 'dart:developer';
import 'package:car_pooling/screens/landing_screen/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log("FIREBASE INITILIASED!");

  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  log("FCM ENABLED!");

  final fcmToken = await FirebaseMessaging.instance.getToken();
  log("FCM TOKEN : $fcmToken");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Pooling',
      //! Change theme to light theme from the app's theme data file where the theme is defined for the app.
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const LandingScreen(),
    );
  }
}
