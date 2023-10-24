import 'dart:developer';
import 'package:car_pooling/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  PageController pageController = PageController();

  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();

    pages = [
      setupProfile(),
      phoneNumber(),
      verifyPhoneNumber(),
      ageVerification(),
      selectGender(),
      addProfilePicture(),
      addDescription(),
      userType(),
      profileCompleted(),
    ];
  }

  TextEditingController phoneNumberController = TextEditingController();
  OtpFieldController otpController = OtpFieldController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  XFile? profilePicture;
  ImagePicker imagePicker = ImagePicker();

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
          "Profile Setup",
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
        onPageChanged: (value) {},
      ),
    );
  }

  Widget setupProfile() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Let's establish your profile information",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Don't worry, it takes only a minute. Tap 'Next' to get started",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Divider(),
        GestureDetector(
          onTap: () {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget phoneNumber() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Phone number",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Please enter your phone number with valid country code so other members can reach you.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Only members with confirmed bookings can see your number",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFECECEC),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: SizedBox(
                      width: 80,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Image.asset(
                              'assets/icons/india.png',
                              height: 30,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "+91",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (phoneNumberController.text.length > 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter a valid phone number"),
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (phoneNumberController.text.length > 10) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Please enter a valid phone number"),
                              ),
                            );
                          } else {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFAAAAAA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            "Send verification code",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget verifyPhoneNumber() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Verification code",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Please enter the verification code we just sent in an SMS text message to +91 9876543210",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "If you didn't receive a verification code, please go back and enter your number again",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
            left: 10,
            right: 10,
          ),
          child: Row(
            children: [
              Expanded(
                child: OTPTextField(
                  controller: otpController,
                  length: 6,
                  fieldStyle: FieldStyle.underline,
                  fieldWidth: 50,
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  otpFieldStyle: OtpFieldStyle(
                    disabledBorderColor: Colors.black,
                    enabledBorderColor: Colors.black,
                    focusBorderColor: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Divider(),
        GestureDetector(
          onTap: () {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Verify code",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF9B9B9B),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget ageVerification() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Age verification",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "You must be 18 years or older to use Top. Please verify your age by entering your date of birth below",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: GestureDetector(
                  onTap: () {
                    chooseDateOfBirth();
                  },
                  child: TextFormField(
                    controller: dateOfBirthController,
                    enabled: false,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFECECEC),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      hintText: "DD/MM/YYYY",
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Divider(),
        GestureDetector(
          onTap: () {
            if (age >= 18) {
              pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("You must be atleast 18 years old to use Top"),
                ),
              );
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF9B9B9B),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  int age = 0;
  void chooseDateOfBirth() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1933),
      lastDate: DateTime(2033),
    ).then((value) {
      String dob = DateFormat("dd/MM/yyyy").format(value!);
      setState(() {
        dateOfBirthController.text = dob;
        age = DateTime.now().year - value.year;
      });
    });
  }

  Widget selectGender() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "What is your gender?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Top members feel safer knowing who they are travelling with",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: CircleAvatar(
                    radius: 120,
                    backgroundImage: AssetImage('assets/images/gender.png'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Divider(),
        GestureDetector(
          onTap: () {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Male",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        GestureDetector(
          onTap: () {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Female",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        GestureDetector(
          onTap: () {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Other",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget addProfilePicture() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add a picture",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Show us your smiling face. This increses trust and gets your more bookings!",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Please follow these guidelines so other members can easily recognize you.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF93D3FF),
                      child: Image.asset(
                        'assets/icons/smile.png',
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        "Clearly show us your face",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFFFF9D9D),
                          child: Image.asset(
                            'assets/icons/sunglasses.png',
                            height: 30,
                          ),
                        ),
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.not_interested,
                              color: Color(0xFF0D0605),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        "No sunglasses",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFFFF9D9D),
                          child: Image.asset(
                            'assets/icons/group.png',
                            height: 30,
                          ),
                        ),
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.not_interested,
                              color: Color(0xFF0D0605),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        "No group shots",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFFFF9D9D),
                          child: Image.asset(
                            'assets/icons/pets.png',
                            height: 30,
                          ),
                        ),
                        const Positioned(
                          right: 0,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.not_interested,
                              color: Color(0xFF0D0605),
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    const Expanded(
                      child: Text(
                        "No pets",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
        const Divider(),
        GestureDetector(
          onTap: () async {
            log('open camera');
            profilePicture = await imagePicker.pickImage(
              source: ImageSource.camera,
            );
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Take Selfie",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        GestureDetector(
          onTap: () async {
            log('open gallery');
            profilePicture = await imagePicker.pickImage(
              source: ImageSource.gallery,
            );
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Choose from library",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget addDescription() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Add a description",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Please take a moment to introduce yourself to the Top community",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: TextFormField(
                  controller: descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFECECEC),
                    hintText:
                        "Example: I travel on weekends and would love to meet people and share rides",
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Divider(),
        GestureDetector(
          onTap: () {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Add profile description",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget userType() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "How will you use Top?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Let us know how you intend to use Top. This helps us send you relevant communications",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Divider(),
        GestureDetector(
          onTap: () {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Mostly as a driver",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(),
        GestureDetector(
          onTap: () {
            pageController.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeIn,
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "Mostly as a passenger",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget profileCompleted() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profile completed!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Nice one! You can now share rides with other members on Top.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "You can edit your profile anytime in Account > Profile settings",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF7C7C7C),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        const Divider(),
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const MainScreen();
            }));
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "All done",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
