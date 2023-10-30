import 'dart:developer';
import 'dart:io';
import 'package:car_pooling/models/message_model.dart';
import 'package:car_pooling/services/notifications/notifications_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

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
    required String receiverPushToken,
    required String message,
  }) async {
    //* GET CURRENT USER INFORMATION

    final String userID = firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    //* CREATE A NEW MESSAGE

    ChatMessage newMessage = ChatMessage(
      senderID: userID,
      receiverID: receiverID,
      message: message,
      timeStamp: timestamp,
      isMessageRead: false,
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

    await NotificationService().sendNotification(
      pushToken: receiverPushToken,
      title: firebaseAuth.currentUser!.displayName!,
      body: newMessage.message ?? "",
      messageType: MessageType.text,
    );
  }

  //! post image or file to firebase message collection

  Future<void> uploadAndSendImageOrFile({
    required File file,
    required String receiverID,
    required String receiverPushToken,
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
      final Timestamp timestamp = Timestamp.now();

      ChatMessage newMessage = ChatMessage(
        senderID: userID,
        receiverID: receiverID,
        message: fileUrl,
        timeStamp: timestamp,
        isMessageRead: false,
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

      await NotificationService().sendNotification(
        pushToken: receiverPushToken,
        title: firebaseAuth.currentUser!.displayName!,
        body: newMessage.message ?? "",
        messageType: isImage ? MessageType.image : MessageType.file,
      );
    } catch (e) {
      log("Error uploading to Firebase!");
    }
  }

  //? GETTING ALL THE UNREAD MESSAGES FOR EACH CHAT ON THE HOME SCREEN

  Future<Map<String, dynamic>> getUnreadMessages({
    required String receiverUserID,
  }) async {
    List unreadMessages = [];
    String userID = FirebaseAuth.instance.currentUser!.uid;

    List<String> ids = [receiverUserID, userID];
    ids.sort();
    String chatRoomID = ids.join('_');

    QuerySnapshot allMessages = await FirebaseFirestore.instance
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .get();

    List messages =
        allMessages.docs.map((document) => document.data()).toList();

    Map<String, dynamic> unreadMessageModel = {};

    for (var ele in messages) {
      DateTime messageDateTime = (ele['timestamp'] as Timestamp).toDate();
      String messageTime = DateFormat('h:mm a').format(messageDateTime);
      // log("${ele['message']} = at $messageTime : seen = ${ele['isMessageRead']}");
      if (ele['isMessageRead'] == false && ele['senderID'] != userID) {
        unreadMessages.add({
          'message': ele['message'],
          'timestamp': messageTime,
        });
        unreadMessageModel = {
          'senderID': receiverUserID,
          'unreadMessages': unreadMessages,
        };
      } else {
        continue;
      }
    }
    return unreadMessageModel;
  }
}
