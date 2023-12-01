import 'package:car_pooling/screens/chat_screen/chat_screen.dart';
import 'package:car_pooling/screens/home/trips/request_to_book.dart';
import 'package:car_pooling/widgets/map_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class TripsPreviewScreen extends StatefulWidget {
  final dynamic tripDetails;
  const TripsPreviewScreen({
    required this.tripDetails,
    super.key,
  });

  @override
  State<TripsPreviewScreen> createState() => _TripsPreviewScreenState();
}

class _TripsPreviewScreenState extends State<TripsPreviewScreen> {
  String? tripDate;
  @override
  void initState() {
    super.initState();

    DateTime tripDateTime = DateFormat('d MMMM yyyy').parse(
      widget.tripDetails['departureDate'],
    );
    tripDate = DateFormat('EEE, MMM d').format(tripDateTime);
  }

  double myLatitude = 12.963400;
  double myLongitude = 77.586790;

  double destLatitude = 12.963400;
  double destLongitude = 77.583278;

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
          "Trip Preview",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 200,
                  width: 5,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.tripDetails['origin'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "$tripDate at ${widget.tripDetails['departureTime']}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "origin",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widget.tripDetails['stops'].isNotEmpty ||
                              widget.tripDetails != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                Text(
                                  widget.tripDetails['stops'],
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  "stops address",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.tripDetails['destination'],
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "ETA",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "destination",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "${widget.tripDetails['emptySeats']} seats left",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(),
                Expanded(
                  child: Center(
                    child: Text(
                      "Rs. ${widget.tripDetails['price']} per seat",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              widget.tripDetails['tripDescription'],
              // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Integer quis auctor elit sed vulputate. Scelerisque fermentum dui faucibus in ornare quam viverra orci sagittis. Aliquam malesuada bibendum arcu vitae elementum curabitur vitae nunc. Massa ultricies mi quis hendrerit dolor magna eget est lorem.",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Booked:",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: CircleAvatar(
                          radius: 30,
                          child: Image.asset(
                            'assets/icons/seat.png',
                            height: 36,
                            width: 36,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    "${widget.tripDetails['driverDetails']['driverImage']}",
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.tripDetails['driverDetails']['driverName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Image.asset(
                              'assets/icons/verified.png',
                              height: 26,
                              width: 26,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              widget.tripDetails['driverDetails']['rating'],
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(
                              Icons.circle,
                              color: Colors.black,
                              size: 6,
                            ),
                          ),
                          const Text(
                            "45 rides",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Container(
                  height: 110,
                  width: 190,
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.tripDetails['vehicle']['vehicleImage'],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.tripDetails['vehicle']['model'],
                        ),
                        Text(
                          "${widget.tripDetails['vehicle']['color']}, ${widget.tripDetails['vehicle']['year']}",
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return const Row(
                              children: [
                                Icon(
                                  Icons.abc_sharp,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text("features"),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: MapWidget(
              originCoordinates: LatLng(
                myLatitude,
                myLongitude,
              ),
              destinationCoordinates: LatLng(
                destLatitude,
                destLongitude,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return const RequestToBookScreen();
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4E00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Request to book",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChatScreen(
                      isNewChat: true,
                      fromUserName: widget.tripDetails['driverDetails']
                          ['driverName'],
                      fromUserImage: widget.tripDetails['driverDetails']
                          ['driverImage'],
                      fromUserId: widget.tripDetails['userId'],
                      userPushToken: widget.tripDetails['driverDetails']
                          ['pushToken'],
                      isUserOnline: false,
                    );
                  }));
                },
                icon: const Icon(Icons.chat),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
