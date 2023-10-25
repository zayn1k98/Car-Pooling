import 'package:car_pooling/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  //? GET MESSAGE

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

  //? SEND MESSAGE

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
}
