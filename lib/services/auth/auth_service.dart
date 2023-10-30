// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:car_pooling/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  SharedPreferences? sharedPreferences;

  signInWithGoogle({required BuildContext context}) async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    GoogleSignInAuthentication googleAuthentication =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuthentication.accessToken,
      idToken: googleAuthentication.idToken,
    );

    UserCredential firebaseCredentials =
        await firebaseAuth.signInWithCredential(credential);

    log("FIREBASE CREDENTIALS : $firebaseCredentials");

    QuerySnapshot querySnapshot = await fireStore
        .collection('users')
        .where('email', isEqualTo: googleUser.email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      log("USER ALREADY EXISTS!!!");
    } else {
      log("CREATING A NEW USER ... !!!");

      fireStore.collection('users').doc(firebaseCredentials.user!.uid).set(
        {
          'userId': firebaseCredentials.user!.uid,
          'username': firebaseCredentials.user!.displayName,
          'email': firebaseCredentials.user!.email,
          'profileImage': firebaseCredentials.user!.photoURL,
        },
        SetOptions(
          merge: true,
        ),
      );
    }

    sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences!.setString('userId', firebaseCredentials.user!.uid);
    sharedPreferences!
        .setString('username', firebaseCredentials.user!.displayName ?? "");
    sharedPreferences!
        .setString('userEmail', firebaseCredentials.user!.email ?? "");
    sharedPreferences!
        .setString('userImage', firebaseCredentials.user!.photoURL ?? "");

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const MainScreen();
    }));

    sharedPreferences!.setBool('isLoggedIn', true);

    return firebaseCredentials;
  }

  signInWithFacebook({required BuildContext context}) async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      log("LOGIN SUCCESSFUL");

      final OAuthCredential facebookCredential =
          FacebookAuthProvider.credential(result.accessToken!.token);

      final userData = await FacebookAuth.instance.getUserData();

      log("Facebook user data : $userData");

      fireStore.collection('users').doc(userData['id']).set(
        {
          'userId': userData['id'],
          'username': userData['name'],
          'email': userData['email'],
          'profileImage': userData['picture']['data']['url'],
        },
        SetOptions(
          merge: true,
        ),
      );

      sharedPreferences = await SharedPreferences.getInstance();

      sharedPreferences!.setString('userId', userData['id']);
      sharedPreferences!.setString('username', userData['name']);
      sharedPreferences!.setString('userEmail', userData['email']);
      sharedPreferences!
          .setString('userImage', userData['picture']['data']['url']);

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const MainScreen();
      }));

      sharedPreferences!.setBool('isLoggedIn', true);

      return firebaseAuth.signInWithCredential(facebookCredential);
    } else {
      log("LOGIN FAILED");
    }
  }
}
