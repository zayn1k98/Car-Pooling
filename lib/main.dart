import 'dart:developer';
import 'package:car_pooling/screens/landing_screen/landing_screen.dart';
import 'package:car_pooling/screens/main_screen.dart';
import 'package:car_pooling/services/notifications/notifications_service.dart';
import 'package:car_pooling/services/user/user_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'services/chat/chat_service.dart';

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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
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
    super.initState();

    isUserLoggedIn();
    UserServices().updateOnlineStatus(isOnline: online);

    WidgetsBinding.instance.addObserver(this);
  }

  bool online = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    bool isBackground = state == AppLifecycleState.paused;
    bool isClosed = state == AppLifecycleState.detached;
    bool isActive = state == AppLifecycleState.resumed;

    isBackground == false && isClosed == false && isActive == true
        ? UserServices().updateOnlineStatus(isOnline: online)
        : UserServices().updateOnlineStatus(isOnline: !online);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatService()),
        ChangeNotifierProvider(create: (_) => UserServices()),
      ],
      child: MaterialApp(
        title: 'Car Pooling',
        //! Change theme to light theme from the app's theme data file where the theme is defined for the app.
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: firstPage,
      ),
    );
  }
}
