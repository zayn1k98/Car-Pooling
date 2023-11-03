import 'dart:developer';
import 'package:car_pooling/screens/landing_screen/landing_screen.dart';
import 'package:car_pooling/screens/main_screen.dart';
import 'package:car_pooling/services/notifications/notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  log("FIREBASE INITILIASED!");

  await NotificationService().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  Widget? firstPage;

  void isUserLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    isLoggedIn = sharedPreferences.getBool('isLoggedIn') ?? false;

    log(isLoggedIn ? "USER IS LOGGED IN !!!" : "USER IS NOT LOGGED IN !!!");

    setState(() {
      firstPage = isLoggedIn ? const MainScreen() : const LandingScreen();
    });
  }

  @override
  void initState() {
    isUserLoggedIn();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Pooling',
      //! Change theme to light theme from the app's theme data file where the theme is defined for the app.
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: firstPage,
    );
  }
}
