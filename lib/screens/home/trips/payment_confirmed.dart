import 'package:flutter/material.dart';

class PaymentConfirmedScreen extends StatelessWidget {
  const PaymentConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 150),
            child: Center(
              child: Image.asset(
                "assets/icons/payment_done.gif",
                height: 150,
                width: 150,
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text("Thank you!"),
          const SizedBox(height: 10),
          const Text("Your booking has been added"),
          const SizedBox(height: 20),
          details(title: "From", value: "Origin"),
          details(title: "To", value: "Destination"),
          details(title: "Departure date", value: "5 Nov 2023"),
          details(title: "Amount", value: "Rs. 2,500"),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent[700],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget details({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 40,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(title),
          ),
          const Expanded(
            child: Center(
              child: Text(":"),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
