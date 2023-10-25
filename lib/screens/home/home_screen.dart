import 'package:car_pooling/screens/chat_screen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  }

  void getUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    userEmail = sharedPreferences!.getString('userEmail');
  }

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
                  children: snapshot.data!.docs
                      .map<Widget>(
                        (doc) => buildInboxList(
                          snapshot: doc,
                        ),
                      )
                      .toList(),
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

    if (userEmail == inboxData['email']) {
      return const SizedBox();
    } else {
      return inboxItem(
        id: inboxData['userId'],
        name: inboxData['username'],
        image: inboxData['profileImage'],
        isOnline: true,
        latestMessage: "Chat service testing",
        timeStamp: "12:00",
        isOpened: false,
        noOfUnreadMessages: 2,
      );
    }
  }

  Widget inboxItem({
    required String id,
    required String name,
    required String image,
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
      trailing: Column(
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
