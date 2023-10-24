import 'package:car_pooling/screens/home/account_screen.dart';
import 'package:car_pooling/screens/home/home_screen.dart';
import 'package:car_pooling/screens/home/trips_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPageIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    pages = const [
      HomeScreen(),
      TripsScreen(),
      AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Image.asset(
            'assets/icons/top.png',
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            style: TextButton.styleFrom(
              side: const BorderSide(
                color: Colors.black,
              ),
            ),
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            label: const Text(
              "Find",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextButton.icon(
              onPressed: () {},
              style: TextButton.styleFrom(
                side: const BorderSide(
                  color: Colors.black,
                ),
              ),
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
              label: const Text(
                "Post",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPageIndex,
        selectedItemColor: const Color(0xFFFF4E00),
        unselectedItemColor: const Color(0xFFBBBBBB),
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Image.asset(
                currentPageIndex == 0
                    ? 'assets/icons/inbox_selected.png'
                    : 'assets/icons/inbox_unselected.png',
                height: 24,
              ),
            ),
            label: "Inbox",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Image.asset(
                currentPageIndex == 1
                    ? 'assets/icons/trips_selected.png'
                    : 'assets/icons/trips_unselected.png',
                height: 24,
              ),
            ),
            label: "Trips",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Image.asset(
                currentPageIndex == 2
                    ? 'assets/icons/account_selected.png'
                    : 'assets/icons/account_unselected.png',
                height: 24,
              ),
            ),
            label: "Account",
          ),
        ],
        onTap: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
    );
  }
}
