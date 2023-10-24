import 'package:car_pooling/screens/main_screen.dart';
import 'package:car_pooling/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  GoogleSignInAccount? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 36,
          ),
        ),
      ),
      body: Column(
        children: [
          headerText(),
          imageStack(context: context),
          const Spacer(),
          signInOptions(context: context),
        ],
      ),
    );
  }

  Widget headerText() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome!",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              "Embark on this adventure with us! Please choose an option below to sign in",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Color(0xFF7C7C7C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageStack({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 30,
              top: 0,
              child: Container(
                height: 137,
                width: 185,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBC8FE),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: 0,
              child: Container(
                height: 181,
                width: 243,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEAE89),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            Container(
              height: 188,
              width: 265,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/welcome_1.jpeg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signInOptions({required BuildContext context}) {
    return Column(
      children: [
        ListTile(
          leading: Image.asset('assets/icons/google.png'),
          title: const Center(
            child: Text("Continue with Google"),
          ),
          onTap: () async {
            //! temporarily commented code to build account screen
            // AuthService().signInWithGoogle();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MainScreen();
            }));
          },
        ),
        const Divider(),
        ListTile(
          leading: Image.asset('assets/icons/facebook.png'),
          title: const Center(
            child: Text("Continue with Facebook"),
          ),
          onTap: () {
            AuthService().signInWithFacebook();
          },
        ),
      ],
    );
  }
}
