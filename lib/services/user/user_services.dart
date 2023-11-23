import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> updateActiveStatus({
    required bool isOnline,
  }) async {
    String currentUserId = firebaseAuth.currentUser!.uid;

    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final String? pushToken = sharedPreferences.getString('pushToken');

    firestore.collection('users').doc(currentUserId).update({
      'isOnline': isOnline,
      'pushToken': pushToken,
    });
  }

  Future<Map<String, dynamic>> getUserData({required String userId}) async {
    DocumentSnapshot userInfo =
        await firestore.collection('users').doc(userId).get();

    Map<String, dynamic> userData = userInfo.data() as Map<String, dynamic>;

    return userData;
  }
}
