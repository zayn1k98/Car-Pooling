import 'package:car_pooling/screens/chat_screen/chat_screen.dart';
import 'package:car_pooling/services/chat/chat_service.dart';
import 'package:car_pooling/services/user/user_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  void dispose() {
    super.dispose();
  }

  Map<String, dynamic> userMessages = {};

  bool isLoading = true;

  String? searchKey;
  void searchString({required String key}) {
    setState(() {
      searchKey = key;
    });
    print("SEARCH KEY = = = > $searchKey");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
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
              onChanged: (value) {
                if (searchController.value.text.isNotEmpty) {
                  searchString(key: value);
                } else {
                  setState(() {
                    searchKey = null;
                  });
                }
              },
            ),
          ),
          searchKey != null ? searchTextBuilder() : allChats(),
        ],
      ),
    );
  }

  Widget searchTextBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: 6,
      itemBuilder: (context, index) {
        return const ListTile(
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Username"),
                  Text("23 nov 2023"),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  "This is a sample message being used to test the search functionality of the search box in the home page.",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Divider(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget allChats() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chat_rooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading..."),
            );
          }
          return Column(
            children: snapshot.data!.docs.map<Widget>((doc) {
              return buildInboxList(
                snapshot: doc,
              );
            }).toList(),
          );
        },
      ),
    );
  }

  Widget buildInboxList({required DocumentSnapshot snapshot}) {
    Map<String, dynamic> inboxData = snapshot.data() as Map<String, dynamic>;

    if (FirebaseAuth.instance.currentUser!.uid != inboxData['receiver_id'] &&
        FirebaseAuth.instance.currentUser!.uid != inboxData['sender_id']) {
      return const SizedBox();
    } else {
      Map<String, dynamic> userChatData = {};
      List messages = [];
      int noOfUnreadMessages = 0;

      String otherUserId =
          inboxData['receiver_id'] != FirebaseAuth.instance.currentUser!.uid
              ? inboxData['receiver_id']
              : inboxData['sender_id'];

      return FutureBuilder(
        future: Future(
          () async {
            messages = await ChatService().getChatMessages(
              docID: inboxData['doc_id'],
            );

            if (messages.first['isMessageRead'] == true) {
              noOfUnreadMessages = 0;
            } else {
              if (messages.first['senderID'] ==
                  FirebaseAuth.instance.currentUser!.uid) {
                noOfUnreadMessages = 0;
              } else {
                noOfUnreadMessages = messages.length;
              }
            }

            userChatData = await UserServices().getUserData(
              userId: otherUserId,
            );
          },
        ),
        builder: (context, snapshot) {
          return userChatData.isEmpty
              ? const SizedBox()
              : messages.isEmpty
                  ? const SizedBox()
                  : inboxItem(
                      userData: userChatData,
                      latestMessage: messages.first['message'],
                      timeStamp: messages.first['timestamp'],
                      isOpened: false,
                      noOfUnreadMessages: noOfUnreadMessages,
                    );
        },
      );
    }
  }

  Widget inboxItem({
    required Map<String, dynamic> userData,
    required String latestMessage,
    required Timestamp timeStamp,
    required bool isOpened,
    required int noOfUnreadMessages,
  }) {
    Timestamp timestamp = timeStamp;

    DateTime dateTime = timestamp.toDate();
    String messageTime = DateFormat('h:mm a').format(dateTime);

    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ChatScreen(
            isNewChat: false,
            userData: userData,
          );
        })).then((value) {
          setState(() {});
        });
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          userData['profileImage'],
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        userData['username'],
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            messageTime,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          noOfUnreadMessages == 0
              ? const SizedBox()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CircleAvatar(
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
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
