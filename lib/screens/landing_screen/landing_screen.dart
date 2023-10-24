import 'package:car_pooling/screens/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 10),
              child: Image.asset(
                'assets/icons/top.png',
                height: 109,
              ),
            ),
            Center(
              child: Container(
                height: 503,
                width: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF93D3FF),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 46),
                      child: Text(
                        "Carpool Adventures: Sharing, Laughing, Navigating",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 40,
                bottom: 20,
              ),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const WelcomeScreen();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF333333),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: const Size(188, 46),
                    maximumSize: const Size(188, 46),
                  ),
                  child: const Text(
                    "Let's go",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Center(
                child: Text(
                  "Version 4.5.0 (4851)",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFAFAFAF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
