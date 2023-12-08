import 'dart:developer';
import 'dart:io';
import 'package:car_pooling/models/message_model.dart';
import 'package:car_pooling/services/notifications/notifications_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ChatService with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  List unreadMessages = [];

  Future<List> getChatMessages({
    required String docID,
  }) async {
    List unreadMessages = [];
    List readMessages = [];

    QuerySnapshot chatMessages = await fireStore
        .collection('chat_rooms')
        .doc(docID)
        .collection('chats')
        .orderBy('timestamp', descending: true)
        .get();

    List allMessages = chatMessages.docs.toList();

    for (var ele in allMessages) {
      if (ele['senderID'] != firebaseAuth.currentUser!.uid) {
        if (ele['isMessageRead'] == false) {
          unreadMessages.add(ele.data());
        } else {
          if (readMessages.isEmpty) {
            readMessages.add(ele.data());
          } else {
            continue;
          }
        }
      } else {
        if (readMessages.isEmpty) {
          readMessages.add(ele.data());
        } else {
          continue;
        }
      }
    }

    unreadMessages = unreadMessages.isEmpty ? readMessages : unreadMessages;

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

    List<String> ids = [userID, receiverID];

    ids.sort();
    String chatRoomID = ids.join("_");

    await fireStore.collection('chat_rooms').doc(chatRoomID).set(
      {
        'doc_id': chatRoomID,
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
          .collection('unreadMessages')
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

  Future<void> markAllUnreadMessagesAsRead({
    required String otherUserId,
  }) async {
    final String userID = firebaseAuth.currentUser!.uid;

    List<String> ids = [otherUserId, userID];
    ids.sort();
    final String chatRoomID = ids.join('_');

    var messageCollection =
        fireStore.collection('chat_rooms').doc(chatRoomID).collection('chats');

    var querySnapshots = await messageCollection.get();

    for (var doc in querySnapshots.docs) {
      Map<String, dynamic> document = doc.data();
      if (document['senderID'] != userID &&
          document['isMessageRead'] == false) {
        await doc.reference.update({
          'isMessageRead': true,
        });
        print("`${document['message']}` MARKED AS READ!");
      } else {
        continue;
      }
    }
  }
}
