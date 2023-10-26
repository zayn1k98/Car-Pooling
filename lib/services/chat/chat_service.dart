import 'dart:developer';
import 'dart:io';

import 'package:car_pooling/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getMessage({
    required String userId,
    required String otherUserId,
  }) {
    List<String> ids = [userId, otherUserId];

    ids.sort();

    String chatRoomId = ids.join("_");

    return fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage({
    required String receiverID,
    required String message,
  }) async {
    //* GET CURRENT USER INFORMATION

    final String userID = firebaseAuth.currentUser!.uid;
    final String userEmail = firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //* CREATE A NEW MESSAGE

    ChatMessage newMessage = ChatMessage(
      senderID: userID,
      senderEmail: userEmail,
      receiverID: receiverID,
      message: message,
      timeStamp: timestamp,
      messageType: MessageType.text,
    );

    //* CREATE A CHAT ROOM ID FOR USERID AND RECEIVERID - PAIRING AND AMBIGUITY

    List<String> ids = [userID, receiverID];

    ids.sort();

    String chatRoomID = ids.join("_");

    //* POST MESSAGE TO DATABASE

    await fireStore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //! post file to firebase message collection

  Future<void> uploadAndSendFile() async {}

  //! post image to firebase message collection

  Future<void> uploadAndSendImageOrFile({
    required File file,
    required String receiverID,
    required bool isImage,
  }) async {
    try {
      FirebaseStorage firebaseStorage = FirebaseStorage.instance;

      final Reference firebaseStorageReference = isImage
          ? firebaseStorage.ref().child(
                'images/${DateTime.now()}.jpg',
              )
          : firebaseStorage.ref().child(
                'files/${DateTime.now()}_file',
              );

      UploadTask uploadImage = firebaseStorageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadImage;

      String fileUrl = await taskSnapshot.ref.getDownloadURL();

      log("Uploaded to Firebase successfully! : $fileUrl");

      final String userID = firebaseAuth.currentUser!.uid;
      final String userEmail = firebaseAuth.currentUser!.email.toString();
      final Timestamp timestamp = Timestamp.now();

      ChatMessage newMessage = ChatMessage(
        senderID: userID,
        senderEmail: userEmail,
        receiverID: receiverID,
        message: fileUrl,
        timeStamp: timestamp,
        messageType: isImage ? MessageType.image : MessageType.file,
      );

      List<String> ids = [receiverID, userID];
      ids.sort();
      final String chatRoomID = ids.join('_');

      await fireStore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .add(newMessage.toMap());
    } catch (e) {
      log("Error uploading to Firebase!");
    }
  }
}
