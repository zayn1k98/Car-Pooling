import 'dart:developer';
import 'dart:io';
import 'package:car_pooling/models/message_model.dart';
import 'package:car_pooling/services/notifications/notifications_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatService with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  List unreadMessages = [];

  Future<List> getChatMessages({
    required String docID,
  }) async {
    List messages = [];
    List lastMessage = [];

    QuerySnapshot chatMessages = await fireStore
        .collection('chat_rooms')
        .doc(docID)
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .get();

    List allMessages = chatMessages.docs.toList();

    for (var ele in allMessages) {
      if (ele['isMessageRead'] == false &&
          ele['receiverID'] != firebaseAuth.currentUser!.uid) {
        messages.add(ele.data());
      } else if (ele['isMessageRead'] == true &&
          ele['receiverID'] != firebaseAuth.currentUser!.uid) {
        if (lastMessage.isEmpty) {
          lastMessage.add(ele.data());
        } else {
          continue;
        }
      }
    }

    print("ALL MESSAGES : $messages + $lastMessage");

    unreadMessages = messages.isEmpty ? lastMessage : messages;

    notifyListeners();

    return unreadMessages;
  }

  Stream<QuerySnapshot> getMessage({
    required String userId,
    required String otherUserId,
  }) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    log("CHAT ROOM ID : $chatRoomId");

    return fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage({
    required String receiverID,
    required String receiverPushToken,
    required String message,
  }) async {
    final String userID = firebaseAuth.currentUser!.uid;
    final Timestamp timestamp = Timestamp.now();

    ChatMessage chatData = ChatMessage(
      senderID: userID,
      receiverID: receiverID,
      message: message,
      timeStamp: timestamp,
      isMessageRead: false,
      messageType: MessageType.text,
    );

    // QuerySnapshot singleChat = await fireStore
    //     .collection('chat_rooms')
    //     .where('receiver_id', isEqualTo: receiverID)
    //     .get();

    // List singleChatList = singleChat.docs;

    // Map<String, dynamic> chat = {
    //   'sender_id': userID,
    //   'receiver_id': receiverID,
    //   'chats': singleChatList,
    // };

    List<String> ids = [userID, receiverID];

    ids.sort();
    String chatRoomID = ids.join("_");

    await fireStore.collection('chat_rooms').doc(chatRoomID).set(
      {
        'sender_id': userID,
        'receiver_id': receiverID,
      },
    );

    await fireStore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('chats')
        .add(chatData.toMap())
        .then((value) {
      print("MESSAGE SENT SUCCESSFULLY !!!");
    });

    await NotificationService().sendNotification(
      pushToken: receiverPushToken,
      title: firebaseAuth.currentUser!.displayName!,
      body: chatData.message ?? "",
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
