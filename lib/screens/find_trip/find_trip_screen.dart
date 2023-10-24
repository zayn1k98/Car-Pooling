import 'package:flutter/material.dart';

class FindTripScreen extends StatelessWidget {
  const FindTripScreen({super.key});

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
          "Find a trip",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF3D3D3D),
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
