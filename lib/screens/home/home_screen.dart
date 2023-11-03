import 'dart:developer';

import 'package:car_pooling/screens/chat_screen/chat_screen.dart';
import 'package:car_pooling/services/chat/chat_service.dart';
import 'package:car_pooling/services/user/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  SharedPreferences? sharedPreferences;

  String? userEmail;

  @override
  void initState() {
    super.initState();

    getUserData();
    UserServices().updateActiveStatus(isOnline: true);

    getUserMessageData(
      messages: [],
      receiverUserID: FirebaseAuth.instance.currentUser!.uid,
    );
  }

  void getUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    userEmail = sharedPreferences!.getString('userEmail');
  }

  @override
  void dispose() {
    super.dispose();

    UserServices().updateActiveStatus(isOnline: false);
  }

  Map<String, dynamic> userMessages = {};
  List unreadMessages = [];

  void getUserMessageData({
    required List<QueryDocumentSnapshot> messages,
    required String receiverUserID,
  }) async {
    for (var ele in messages) {
      Map<String, dynamic> data = ele.data() as Map<String, dynamic>;

      if (data['userId'] != FirebaseAuth.instance.currentUser!.uid) {
        userMessages = await ChatService().getUnreadMessages(
          receiverUserID: data['userId'],
        );

        if (unreadMessages.contains(userMessages) || unreadMessages.isEmpty) {
          unreadMessages.add(userMessages);
        } else if (userMessages.isEmpty) {
          unreadMessages.add({
            'senderID': receiverUserID,
            'unreadMessages': [],
          });
        }
      }
    }
    log("All messages => $unreadMessages");
  }

  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "Inbox",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchBar(
              controller: searchController,
              elevation: const MaterialStatePropertyAll(0),
              backgroundColor: const MaterialStatePropertyAll(
                Color(0xFFF2F2F3),
              ),
              leading: const Icon(Icons.search),
              hintText: "Search messages",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text("Loading..."),
                  );
                }
                return Column(
                  children: snapshot.data!.docs.map<Widget>((doc) {
                    // getUserMessageData(
                    //   messages: snapshot.data!.docs,
                    //   receiverUserID: doc['userId'],
                    // );
                    return buildInboxList(
                      snapshot: doc,
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInboxList({required DocumentSnapshot snapshot}) {
    Map<String, dynamic> inboxData = snapshot.data() as Map<String, dynamic>;

    Map<String, dynamic> chatData = {};

    for (var ele in unreadMessages) {
      if (inboxData['userId'] == ele['senderID']) {
        chatData = ele;
      }
    }

    if (userEmail == inboxData['email']) {
      return const SizedBox();
    } else {
      return inboxItem(
        id: inboxData['userId'],
        name: inboxData['username'],
        image: inboxData['profileImage'],
        pushToken: inboxData['pushToken'],
        isOnline: true,
        latestMessage: chatData['unreadMessages'].isEmpty
            ? "Tap to chat"
            : chatData['unreadMessages'].last['message'],
        timeStamp: chatData['unreadMessages'].isEmpty
            ? ""
            : chatData['unreadMessages'].last['timestamp'],
        isOpened: false,
        noOfUnreadMessages: chatData['unreadMessages'].isEmpty
            ? 0
            : chatData['unreadMessages'].length,
      );
    }
  }

  Widget inboxItem({
    required String id,
    required String name,
    required String image,
    required String pushToken,
    required bool isOnline,
    required String latestMessage,
    required String timeStamp,
    required bool isOpened,
    required int noOfUnreadMessages,
  }) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(
            fromUserName: name,
            fromUserImage: image,
            fromUserId: id,
            userPushToken: pushToken,
            isUserOnline: isOnline,
          );
        }));
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          image,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        latestMessage,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      trailing: noOfUnreadMessages == 0
          ? const SizedBox()
          : Column(
              children: [
                Text(
                  timeStamp,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.black,
                  child: Text(
                    "$noOfUnreadMessages",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
    );
  }
}
