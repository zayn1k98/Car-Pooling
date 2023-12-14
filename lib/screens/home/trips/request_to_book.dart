import 'package:car_pooling/screens/home/trips/payment_confirmed.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RequestToBookScreen extends StatefulWidget {
  final dynamic tripDetails;
  const RequestToBookScreen({
    required this.tripDetails,
    super.key,
  });

  @override
  State<RequestToBookScreen> createState() => _RequestToBookScreenState();
}

class _RequestToBookScreenState extends State<RequestToBookScreen> {
  bool isAcceptedTnC = false;
  PageController pageController = PageController();

  List<Widget> pages = [];
  bool isFinalPage = false;

  @override
  Widget build(BuildContext context) {
    pages = [
      firstPage(),
      tripDetails(),
      meetTheDriver(),
      seatsAndPricing(),
      messageToDriver(),
      bookingExpiry(),
      paymentPage(),
    ];
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
          "Book",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: pageController,
        scrollDirection: Axis.horizontal,
        children: pages,
        onPageChanged: (value) {
          if (value == pages.indexOf(pages.last)) {
            print("FINAL PAGE");
            setState(() {
              isFinalPage = true;
            });
          } else {
            isFinalPage = false;
          }
        },
      ),
      persistentFooterButtons: [
        SizedBox(
          height: 50,
          child: GestureDetector(
            onTap: () {
              if (isAcceptedTnC == false) {
                Fluttertoast.showToast(
                  msg: "Please accept the conditions",
                );
              } else {
                isFinalPage
                    ? Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                        return const PaymentConfirmedScreen();
                      }))
                    : pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
              }
            },
            child: Center(
              child: Text(
                isFinalPage ? "Done" : "Next",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget firstPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "What you need to know",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: 30,
            top: 30,
            right: 10,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundImage: AssetImage('assets/images/page_2.png'),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "This is not a taxi service",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "You need to meet up at the pickup location, sit in the front seat with the driver. Minimum phone conversations is advisable.",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: 30,
            top: 20,
            right: 10,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/page_3.png'),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cash is not allowed",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Only online transactions are allowed. The driver will get paid after the trip.",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: 30,
            top: 20,
            right: 10,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('assets/images/arrival.png'),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Show up on time",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Passenger showing up 10 minutes before departure is advisable.",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SwitchListTile(
            value: isAcceptedTnC,
            title: const Text(
              "I understand that my account could be suspended if i break these rules.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            activeColor: const Color(0xff05AC08),
            thumbColor: const MaterialStatePropertyAll(
              Colors.white,
            ),
            onChanged: (value) {
              setState(() {
                isAcceptedTnC = value;
                print("SWITCH VALUE ===> $isAcceptedTnC");
              });
            },
          ),
        ),
      ],
    );
  }

  Widget tripDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Trip Details",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: 30,
            top: 30,
          ),
          child: Text(
            "Itinerary",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          color: const Color(0xFFFFEFAD),
          child: const Padding(
            padding: EdgeInsets.all(30),
            child: Text(
              "The departure time for this trip is the estimated time of departure.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Container(
              height: 150,
              width: 6,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.tripDetails['origin']}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Origin"),
                      const SizedBox(height: 10),
                      Text(
                        "${widget.tripDetails['destination']}",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Destination"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(30),
          child: Text(
            "Trip Description",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "${widget.tripDetails['tripDescription']}",
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget meetTheDriver() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Meet the driver",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal,
                backgroundImage: NetworkImage(
                  widget.tripDetails['driverDetails']['driverImage'],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.tripDetails['driverDetails']['driverName']}",
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Text("Joined month,year"),
                      ),
                      const Text("Gender, xx years old"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Bio",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            '''"I travel often and I love to have some company on my trips."''',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black.withOpacity(0.5),
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Row(
            children: [
              Container(
                height: 110,
                width: 160,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
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
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.tripDetails['vehicle']['model']}",
                      ),
                      const SizedBox(height: 10),
                      Text(
                          "${widget.tripDetails['vehicle']['color']}, ${widget.tripDetails['vehicle']['year']}"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  int seatsNeeded = 1;

  Widget seatsAndPricing() {
    double pricePerSeat = double.parse(
      widget.tripDetails['price'],
    );

    double bookingFee = 100.00;

    double totalAmount = (pricePerSeat * seatsNeeded) + bookingFee;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Seats and Pricing",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text("Seats needed"),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (seatsNeeded != 1) {
                      seatsNeeded--;
                    } else {
                      Fluttertoast.showToast(
                        msg: "Minimum 1 seat must be selected",
                      );
                    }
                  });
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                ),
                icon: const Icon(
                  Icons.remove_rounded,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Text("$seatsNeeded"),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (seatsNeeded <= 3) {
                      seatsNeeded++;
                    } else {
                      Fluttertoast.showToast(
                        msg: "Maximum 4 seats can be selected",
                      );
                    }
                  });
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[400],
                ),
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text("1 seat"),
              ),
              Text("Rs. $pricePerSeat"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            children: [
              const Expanded(
                child: Text("Booking fee"),
              ),
              Text("Rs. $bookingFee"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 20,
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text("Total"),
              ),
              Text("Rs. $totalAmount"),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Divider(),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Container(
              height: 150,
              width: 6,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Promo Code (Optional)"),
                    const SizedBox(height: 30),
                    TextFormField(
                      // controller: controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFECECEC),
                        hintText: "Enter a valid promo code",
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF858585),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please fill the required field';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget messageToDriver() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Message to the driver",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(30),
          child: Text(
            "Tell the driver why you're travelling",
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: TextFormField(
            // controller: controller,
            maxLines: 6,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFECECEC),
              hintText: "Message",
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Color(0xFF858585),
              ),
              contentPadding: const EdgeInsets.all(16),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please fill the required field';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  List<String> expiryTime = [
    'Immediately',
    'Before departure',
  ];
  String? selectedExpiry;

  Widget bookingExpiry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Booking Expiry",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(30),
          child: Text(
            "How quickly do you need the driver to approve the request?",
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Divider(),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: DropdownButtonFormField(
            value: selectedExpiry,
            items: expiryTime.map<DropdownMenuItem<String>>((var ele) {
              return DropdownMenuItem<String>(
                value: ele,
                child: Text(
                  ele,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFECECEC),
              hintText: "Select booking expiry",
              hintStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Color(0xFF858585),
              ),
              contentPadding: const EdgeInsets.all(16),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black,
            ),
            borderRadius: BorderRadius.circular(10),
            onChanged: (value) {},
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Divider(),
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Container(
              height: 150,
              width: 6,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 30,
                  right: 30,
                ),
                child: Text(
                  "Choose how long the driver has to respond to your booking request. After this time, the booking request will expire automatically.",
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  int selectedPaymentIndex = 0;

  Widget paymentPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Select your payment method",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            itemBuilder: (context, index) {
              return ListTile(
                onTap: () {
                  setState(() {
                    selectedPaymentIndex = index;
                  });
                },
                leading: const Icon(Icons.payment),
                title: Text("Payment option ${index + 1}"),
                trailing: selectedPaymentIndex == index
                    ? const Icon(
                        Icons.check_rounded,
                        color: Colors.blue,
                      )
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }
}
