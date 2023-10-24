import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    log("GOOGLE USER DETAILS : $googleUser");

    GoogleSignInAuthentication googleAuthentication =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuthentication.accessToken,
      idToken: googleAuthentication.idToken,
    );

    log("CREDENTIAL : $credential");

    UserCredential firebaseCredentials =
        await FirebaseAuth.instance.signInWithCredential(credential);

    log("FIREBASE CREDENTIALS : $firebaseCredentials");

    return firebaseCredentials;
  }

  signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        log("LOGIN SUCCESSFUL");

        final OAuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        return FirebaseAuth.instance.signInWithCredential(facebookCredential);
      } else {
        log("LOGIN FAILED");
      }
    } on Exception catch (e) {
      return Fluttertoast.showToast(msg: "$e");
    }
  }
}
