import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String? senderID;
  final String? receiverID;
  final String? senderEmail;
  final String? receiverEmail;
  final String? message;
  final Timestamp? timeStamp;
  final MessageType? messageType;

  ChatMessage({
    this.senderID,
    this.receiverID,
    this.senderEmail,
    this.receiverEmail,
    this.message,
    this.timeStamp,
    this.messageType,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'receiverID': receiverID,
      'senderEmail': senderEmail,
      'receiverEmail': receiverEmail,
      'message': message,
      'timestamp': timeStamp,
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
