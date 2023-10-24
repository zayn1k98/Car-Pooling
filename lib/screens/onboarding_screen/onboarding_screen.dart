import 'package:car_pooling/screens/profile_setup_screens/profile_setup_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  PageController pageController = PageController();

  List<Widget> pages = [];
  @override
  void initState() {
    super.initState();

    pages = [
      page1(),
      page2(),
      page3(),
      page4(),
      finalPage(),
    ];
  }

  bool isFinalPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            pageController.previousPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          icon: const Icon(
            Icons.chevron_left_rounded,
            size: 36,
          ),
        ),
        title: const Text(
          "Onboarding",
          style: TextStyle(
            fontSize: 18,
            color: Color(0xFF3D3D3D),
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
            setState(() {
              isFinalPage = true;
            });
          }
        },
      ),
      persistentFooterButtons: [
        GestureDetector(
          onTap: isFinalPage
              ? () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ProfileSetupScreen();
                  }));
                }
              : () {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  isFinalPage ? "I agree" : "Next",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget thingsToKnowContainer({
    required int index,
    required Color color,
  }) {
    return Center(
      child: Container(
        height: 80,
        width: 267,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 3.5,
            color: const Color(0xFF949494),
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(1.5, 1.5),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: color,
                  // color: const Color(0xFF7BC234),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    "$index",
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
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

  Widget page1() {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "3 things to know before you get started",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
        thingsToKnowContainer(
          index: 1,
          color: const Color(0xFF7BC234),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: thingsToKnowContainer(
            index: 2,
            color: const Color(0xFFF0CC0C),
          ),
        ),
        thingsToKnowContainer(
          index: 3,
          color: const Color(0xFF1E80F2),
        ),
      ],
    );
  }

  Widget page2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Top is a carpool community, not like other taxi services",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Align(
          alignment: const Alignment(-1.6, 0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Image.asset(
              'assets/images/page_2.png',
              height: 245,
            ),
          ),
        ),
      ],
    );
  }

  Widget page3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Cash or e-transfers are not available. Use our online booking system",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Align(
          alignment: const Alignment(-2.75, 0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Image.asset(
              'assets/images/page_3.png',
              height: 320,
            ),
          ),
        ),
      ],
    );
  }

  Widget page4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Passenger showing up 10 minutes before departure is advisable",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Align(
          alignment: const Alignment(1.6, 0),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Image.asset(
              'assets/images/page_4.png',
              height: 320,
            ),
          ),
        ),
      ],
    );
  }

  Widget finalPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            "Got it? Great!",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(
            left: 30,
            top: 16,
            right: 10,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 36,
                backgroundImage: AssetImage('assets/images/page_2.png'),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  "We're not just a taxi service. We're a community of carpoolers",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
                radius: 36,
                backgroundImage: AssetImage('assets/images/page_3.png'),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Cash not accepted",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
                radius: 36,
                backgroundImage: AssetImage('assets/images/arrival.png'),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  "Arrive 10 minutes ahead of departure",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Text(
              "By clicking 'I agree', you consent to the rules of our",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  "terms of service",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Text(
                "and",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "privacy policy",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
