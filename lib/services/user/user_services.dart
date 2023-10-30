import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  Future<void> updateActiveStatus({
    required bool isOnline,
  }) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    String currentUserId = firebaseAuth.currentUser!.uid;

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String? pushToken = sharedPreferences.getString('pushToken');

    firestore.collection('users').doc(currentUserId).update({
      'isOnline': isOnline,
      'pushToken': pushToken,
    });
  }
}
