import 'dart:developer';
import 'package:car_pooling/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String fromUserName;
  final String fromUserImage;
  final String fromUserId;
  final bool isUserOnline;
  const ChatScreen({
    required this.fromUserName,
    required this.fromUserImage,
    required this.fromUserId,
    required this.isUserOnline,
    super.key,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  final ChatService chatService = ChatService();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(
        receiverID: widget.fromUserId,
        message: messageController.text,
      );

      messageController.clear();
    } else {
      Fluttertoast.showToast(msg: "Message cannot be empty!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: chatScreenAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: StreamBuilder(
                stream: chatService.getMessage(
                  userId: widget.fromUserId,
                  otherUserId: firebaseAuth.currentUser!.uid,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Text("Loading"),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 300),
                      child: Text("No messages here yet!"),
                    );
                  }
                  return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!.docs
                        .map(
                          (document) => messageBubble(document: document),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ),
          messageTextField(),
        ],
      ),
    );
  }

  PreferredSizeWidget chatScreenAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.chevron_left_rounded,
          size: 36,
        ),
      ),
      title: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              widget.fromUserImage,
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(
                    widget.fromUserName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 3,
                      backgroundColor: widget.isUserOnline
                          ? Colors.greenAccent[700]
                          : Colors.grey[300],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        widget.isUserOnline ? "Online" : "Offline",
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.isUserOnline
                              ? Colors.greenAccent[700]
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu_rounded,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget messageBubble({required DocumentSnapshot document}) {
    Map<String, dynamic> messageData = document.data() as Map<String, dynamic>;

    bool isMessageIncoming =
        messageData['senderID'] != firebaseAuth.currentUser!.uid;

    DateTime dateTime = (messageData['timestamp'] as Timestamp).toDate();

    String messageTime = DateFormat('h:mm a').format(dateTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isMessageIncoming ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isMessageIncoming)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      'assets/icons/read.png',
                      height: 20,
                      width: 20,
                    ),
                    Text(
                      messageTime,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF7D7F88),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: isMessageIncoming
                  ? const Color(0xFFFDFDFD)
                  : const Color(0xFFFF4E00),
              border: Border.all(
                color: isMessageIncoming
                    ? const Color(0xFFE3E3E7)
                    : Colors.transparent,
              ),
              boxShadow: isMessageIncoming
                  ? [
                      BoxShadow(
                        offset: const Offset(0, 3),
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 3,
                      ),
                    ]
                  : null,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                topRight: const Radius.circular(10),
                bottomLeft: Radius.circular(
                  isMessageIncoming ? 0 : 10,
                ),
                bottomRight: Radius.circular(
                  isMessageIncoming ? 10 : 0,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                messageData['message'],
                style: TextStyle(
                  color: isMessageIncoming ? Colors.black : Colors.white,
                ),
              ),
            ),
          ),
          if (isMessageIncoming)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      messageTime,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget messageTextField() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
      child: TextFormField(
        controller: messageController,
        scrollPadding: MediaQuery.of(context).viewInsets,
        decoration: InputDecoration(
          hintText: "Type something",
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: const Color(0xFFF2F2F3),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFFE3E3E7),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFFE3E3E7),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(
              color: Color(0xFFE3E3E7),
            ),
          ),
          prefixIcon: GestureDetector(
            onTap: () {
              log("keyboard tapped");
            },
            child: const Icon(
              Icons.keyboard,
              color: Color(0xFF7D7F88),
            ),
          ),
          suffixIcon: SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    log("file tapped");
                  },
                  child: const Icon(
                    Icons.attach_file,
                    color: Color(0xFF7D7F88),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  icon: const Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
