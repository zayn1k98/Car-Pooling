import 'package:car_pooling/screens/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   toolbarHeight: 70,
      //   leading: Padding(
      //     padding: const EdgeInsets.only(left: 10),
      //     child: Image.asset(
      //       'assets/icons/top.png',
      //     ),
      //   ),
      //   actions: [
      //     TextButton.icon(
      //       onPressed: () {},
      //       style: TextButton.styleFrom(
      //         side: const BorderSide(
      //           color: Colors.black,
      //         ),
      //       ),
      //       icon: const Icon(
      //         Icons.search,
      //         color: Colors.black,
      //       ),
      //       label: const Text(
      //         "Find",
      //         style: TextStyle(
      //           color: Colors.black,
      //         ),
      //       ),
      //     ),
      //     Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 12),
      //       child: TextButton.icon(
      //         onPressed: () {},
      //         style: TextButton.styleFrom(
      //           side: const BorderSide(
      //             color: Colors.black,
      //           ),
      //         ),
      //         icon: const Icon(
      //           Icons.add,
      //           color: Colors.black,
      //         ),
      //         label: const Text(
      //           "Post",
      //           style: TextStyle(
      //             color: Colors.black,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
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
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const ChatScreen();
                    }));
                  },
                  leading: const CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage('assets/images/user_image.jpg'),
                  ),
                  title: const Text(
                    "Tim David",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: const Text(
                    "Thanks! That was a great ride.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  trailing: const Column(
                    children: [
                      Text(
                        "12:34",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Spacer(),
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.black,
                        child: Text(
                          "1",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
