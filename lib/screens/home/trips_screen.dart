import 'package:car_pooling/screens/home/trips/trip_preview.dart';
import 'package:car_pooling/services/trips/trips_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TripsScreen extends StatefulWidget {
  const TripsScreen({super.key});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  bool isActive = true;
  bool isRecent = false;
  bool isCancelled = false;

  String? userId;

  @override
  void initState() {
    super.initState();

    getCurrentUserId();
    getAllTrips();
  }

  void getCurrentUserId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userId = sharedPreferences.getString('userId');
  }

  List allTrips = [];
  List activeTrips = [];

  void getAllTrips() async {
    allTrips = await TripsService().getTrips();

    for (var ele in allTrips) {
      if (ele['userId'] != userId) {
        setState(() {
          activeTrips.add(ele);
        });
      }
      print("status : ${ele['status']} on ${ele['departureDate']}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "Trips",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text("Active"),
                    ),
                    selected: isActive,
                    onSelected: (value) {
                      if (isActive == false) {
                        setState(() {
                          isActive = value;
                          isRecent = false;
                          isCancelled = false;
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
                      color: isActive ? Colors.black : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ChoiceChip(
                    label: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text("Recent"),
                    ),
                    selected: isRecent,
                    onSelected: (value) {
                      if (isRecent == false) {
                        setState(() {
                          isRecent = value;
                          isActive = false;
                          isCancelled = false;
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
                      color: isRecent ? Colors.black : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: ChoiceChip(
                    label: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Text("Cancelled"),
                    ),
                    selected: isCancelled,
                    onSelected: (value) {
                      if (isCancelled == false) {
                        setState(() {
                          isCancelled = value;
                          isActive = false;
                          isRecent = false;
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
                      color: isCancelled ? Colors.black : Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          isActive
              ? activeTrips.isEmpty
                  ? const Center(
                      child: Text("No active trips available"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: activeTrips.length,
                      itemBuilder: (context, index) {
                        print("TRIP : ${activeTrips[index].data()}");
                        return tripsCard(
                          tripDetails: activeTrips[index].data(),
                        );
                      },
                    )
              : isRecent
                  ? const Column()
                  : const Column(),
        ],
      ),
    );
  }

  Widget tripsCard({required tripDetails}) {
    DateTime tripDateTime =
        DateFormat('d MMMM yyyy').parse(tripDetails['departureDate']);
    String tripDate = DateFormat('EEE, MMM d').format(tripDateTime);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          // print("TRIP DETAILS : ${tripDetails.data()}");
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return TripsPreviewScreen(
              tripDetails: tripDetails,
            );
          }));
        },
        child: Container(
          height:
              tripDetails['stops'].isNotEmpty || tripDetails['stops'] != null
                  ? 240
                  : 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: const Color(0xFFE9E9E9),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "$tripDate at ${tripDetails['departureTime']}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${tripDetails['emptySeats']} seats left",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "₹ ${tripDetails['price']}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: tripDetails['stops'].isNotEmpty ||
                            tripDetails['stops'] != null
                        ? 75
                        : 50,
                    width: 4,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "${tripDetails['origin']}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "98, George St, Ottowa, Canada",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          tripDetails['stops'].isNotEmpty ||
                                  tripDetails['stops'] != null
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Container(
                                              height: 8,
                                              width: 2,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Text(
                                              "${tripDetails['stops']}",
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Container(
                                              height: 8,
                                              width: 2,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                          Row(
                            children: [
                              Text(
                                "${tripDetails['destination']}",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  "Pearson Airport Terminal 1",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "${tripDetails['vehicle']['model']}",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 1,
                  color: Color(0xFFE4E4E4),
                ),
              ),
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(
                        tripDetails['driverDetails']['driverImage'],
                      ),
                    ),
                    Text(
                      tripDetails['driverDetails']['driverName'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    tripDetails['driverDetails']['isVerified']
                        ? Image.asset(
                            'assets/icons/verified.png',
                            height: 26,
                            width: 26,
                          )
                        : const SizedBox(),
                    const VerticalDivider(
                      width: 1,
                    ),
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 22,
                    ),
                    Text(
                      tripDetails['driverDetails']['rating'],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const VerticalDivider(
                      width: 1,
                    ),
                    const Text(
                      "45 Rides",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
