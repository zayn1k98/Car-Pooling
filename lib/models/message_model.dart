import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String? senderID;
  final String? receiverID;
  final String? message;
  final Timestamp? timeStamp;
  final bool? isMessageRead;
  final MessageType? messageType;

  ChatMessage({
    this.senderID,
    this.receiverID,
    this.message,
    this.timeStamp,
    this.isMessageRead,
    this.messageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timeStamp,
      'isMessageRead': isMessageRead,
      'messageType': messageType!.toJson(),
    };
  }
}

enum MessageType {
  text,
  image,
  file;

  String toJson() => name;
}
