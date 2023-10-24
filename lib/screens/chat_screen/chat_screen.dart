import 'dart:developer';

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List messages = [];

  @override
  void initState() {
    super.initState();

    messages = [
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message": "Hi!",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message": "How are you?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message": "I'm fine. How about you?",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
      {
        "isIncoming": true,
        "timestamp": "14:02",
        "message":
            "I'm great! I thought we were meeting at your place today. What's up with the plan?",
        "isRead": true,
      },
      {
        "isIncoming": false,
        "timestamp": "14:02",
        "message":
            "Oh yea! Plan is still on. Let's meet around 6pm. I'll call you once I get everything set up.",
        "isRead": true,
      },
    ];
  }

  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/user_image.jpg'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Tim David",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 3,
                        backgroundColor: Colors.greenAccent[700],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          "Online",
                          style: TextStyle(
                            fontSize: 10,
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
      ),
      body: ListView(
        children: [
          const Center(
            child: Text(
              "Today",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: messages[index]['isIncoming'] == true
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (!messages[index]['isIncoming'])
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
                                  messages[index]['timestamp'],
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
                          color: messages[index]['isIncoming'] == true
                              ? const Color(0xFFFDFDFD)
                              : const Color(0xFFFF4E00),
                          border: Border.all(
                            color: messages[index]['isIncoming'] == true
                                ? const Color(0xFFE3E3E7)
                                : Colors.transparent,
                          ),
                          boxShadow: messages[index]['isIncoming'] == true
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
                              messages[index]['isIncoming'] == true ? 0 : 10,
                            ),
                            bottomRight: Radius.circular(
                              messages[index]['isIncoming'] == true ? 10 : 0,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            messages[index]['message'],
                            style: TextStyle(
                              color: messages[index]['isIncoming'] == true
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      if (messages[index]['isIncoming'])
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  messages[index]['timestamp'],
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
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
        child: TextFormField(
          controller: messageController,
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
                      log("mic tapped");
                    },
                    child: const Icon(
                      Icons.mic,
                      color: Color(0xFF7D7F88),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      log("file tapped");
                    },
                    child: const Icon(
                      Icons.attach_file,
                      color: Color(0xFF7D7F88),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
