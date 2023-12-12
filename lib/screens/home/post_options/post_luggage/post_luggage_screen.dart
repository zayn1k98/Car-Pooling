import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostLuggageScreen extends StatefulWidget {
  const PostLuggageScreen({super.key});

  @override
  State<PostLuggageScreen> createState() => _PostLuggageScreenState();
}

class _PostLuggageScreenState extends State<PostLuggageScreen> {
  PageController pageController = PageController();
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
  }

  bool isFinalPage = false;

  TextEditingController originController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController noOfBags = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController widthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    pages = [
      luggageToAndFrom(),
      luggageDetails(),
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
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
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

  Widget luggageToAndFrom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text("Post a luggage"),
          ),
          const Text("From"),
          textField(
            controller: originController,
            hint: "Enter an origin",
            icon: const Icon(
              Icons.location_on,
              color: Colors.black,
            ),
            onTapped: () {},
          ),
          const Text("To"),
          textField(
            controller: destinationController,
            hint: "Enter the destination",
            icon: const Icon(
              Icons.location_on,
              color: Colors.black,
            ),
            onTapped: () {},
          ),
          const Text("Departure date"),
          textField(
            controller: dateController,
            hint: "Enter departure date",
            icon: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.black,
            ),
            onTapped: () {
              datePicker();
            },
            isDateField: true,
          ),
        ],
      ),
    );
  }

  Widget luggageDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text("Post a luggage"),
          ),
          const Text("Luggage weight"),
          textField(
            controller: weightController,
            hint: "Weight in kgs",
            icon: const Icon(
              Icons.luggage_outlined,
              color: Colors.black,
            ),
            onTapped: () {},
          ),
          const Text("No. of bags"),
          textField(
            controller: noOfBags,
            hint: "0",
            onTapped: () {},
          ),
          const Text("Dimensions (in cms)"),
          Row(
            children: [
              Expanded(
                child: textField(
                  controller: heightController,
                  hint: "Length",
                  onTapped: () {},
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("x"),
              ),
              Expanded(
                child: textField(
                  controller: heightController,
                  hint: "Width",
                  onTapped: () {},
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("x"),
              ),
              Expanded(
                child: textField(
                  controller: heightController,
                  hint: "Breadth",
                  onTapped: () {},
                ),
              ),
            ],
          ),
          const Text("Description"),
          textField(
            controller: descriptionController,
            maxLines: 6,
            hint: "Description",
            onTapped: () {},
          ),
        ],
      ),
    );
  }

  Widget textField({
    required TextEditingController controller,
    int? maxLines,
    Icon? icon,
    required String hint,
    required Function() onTapped,
    bool isDateField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: GestureDetector(
        onTap: onTapped,
        child: TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            color: Colors.black,
          ),
          decoration: InputDecoration(
            enabled: false,
            filled: true,
            fillColor: const Color(0xFFECECEC),
            prefixIcon: icon,
            hintText: hint,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Color(0xFF858585),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
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
    );
  }

  void datePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    ).then((value) {
      String selectedDate = DateFormat('d MMMM yyyy').format(value!);
      setState(() {
        dateController.text = selectedDate;
      });
    });
  }
}
