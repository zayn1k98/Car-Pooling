import 'package:car_pooling/screens/home/post_options/post_options_screen.dart';
import 'package:flutter/material.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  bool isAll = true;
  bool isTrips = false;
  bool isRequests = false;

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
        title: const Text(
          "Search results",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF3D3D3D),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text("All"),
                    ),
                    selected: isAll,
                    onSelected: (value) {
                      if (isAll == false) {
                        setState(() {
                          isAll = value;
                          isTrips = false;
                          isRequests = false;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide.none,
                    ),
                    showCheckmark: false,
                    side: BorderSide.none,
                    selectedColor: const Color(0xFFD9D9D9),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: isAll ? Colors.black : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ChoiceChip(
                    label: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text("Trips"),
                    ),
                    selected: isTrips,
                    onSelected: (value) {
                      if (isTrips == false) {
                        setState(() {
                          isTrips = value;
                          isAll = false;
                          isRequests = false;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    showCheckmark: false,
                    side: BorderSide.none,
                    selectedColor: const Color(0xFFD9D9D9),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: isTrips ? Colors.black : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ChoiceChip(
                    label: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text("Requests"),
                    ),
                    selected: isRequests,
                    onSelected: (value) {
                      if (isRequests == false) {
                        setState(() {
                          isRequests = value;
                          isAll = false;
                          isTrips = false;
                        });
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    showCheckmark: false,
                    side: BorderSide.none,
                    selectedColor: const Color(0xFFD9D9D9),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: isRequests ? Colors.black : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ElevatedButton.icon(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const PostOptionsScreen();
            }));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          label: const Text(
            "Post something",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
