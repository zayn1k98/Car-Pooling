import 'package:car_pooling/screens/home/post_options/post_luggage/post_luggage_screen.dart';
import 'package:car_pooling/screens/home/post_options/post_ride/post_ride_screen.dart';
import 'package:flutter/material.dart';

class PostOptionsScreen extends StatelessWidget {
  const PostOptionsScreen({super.key});

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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Heading somewhere?"),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const PostRideScreen();
                  }));
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.vertical_shades_closed,
                        size: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("I'm driving"),
                      ),
                      Text("I want to fill empty seats in my car."),
                    ],
                  ),
                ),
              ),
            ),
            const Divider(),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.vertical_shades_closed,
                      size: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("I need a ride"),
                    ),
                    Text("Notify me when a ride is available"),
                  ],
                ),
              ),
            ),
            const Divider(),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const PostLuggageScreen();
                  }));
                },
                child: const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.vertical_shades_closed,
                        size: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("Post a luggage"),
                      ),
                      Text("Send or courier luggage"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
