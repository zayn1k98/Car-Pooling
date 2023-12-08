import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserServices with ChangeNotifier {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<void> updateOnlineStatus({
    required bool isOnline,
  }) async {
    String currentUserId = firebaseAuth.currentUser!.uid;

    firestore.collection('users').doc(currentUserId).update({
      'isOnline': isOnline,
    });

    print("USER UPDATED TO $isOnline");
  }

  Future<bool> checkUserOnlineStatus({
    required String userId,
  }) async {
    bool isUserOnline = false;
    DocumentReference documentReference =
        firestore.collection('users').doc(userId);

    documentReference.snapshots().listen((event) async {
      isUserOnline = await event.get('isOnline');
      // this prints perfectly fine ...
      isUserOnline ? print("user is online") : print("user is offline");
    });

    return isUserOnline;
    // but here the value is always returned as false ...
  }

  Future<Map<String, dynamic>> getUserData({required String userId}) async {
    DocumentSnapshot userInfo =
        await firestore.collection('users').doc(userId).get();

    Map<String, dynamic> userData = userInfo.data() as Map<String, dynamic>;

    return userData;
  }
}
