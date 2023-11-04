import 'dart:developer';
import 'dart:io';
import 'package:car_pooling/models/vehicle_model.dart';
import 'package:car_pooling/services/vehicles/vehicle_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  List<Widget> carryBaggages = [];
  List<bool> toggleValues = [true, false, false, false];

  List<Widget> seating = [];
  List<bool> seatingValues = [true, false];

  bool isWinterTyres = false;
  bool isSnowboards = false;
  bool isBikes = false;
  bool isPets = false;

  @override
  void initState() {
    super.initState();

    carryBaggages = const [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(Icons.luggage_outlined),
            SizedBox(width: 4),
            Text("No Luggage"),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(Icons.luggage_outlined),
            SizedBox(width: 4),
            Text("S"),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(Icons.luggage_outlined),
            SizedBox(width: 4),
            Text("M"),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Icon(Icons.luggage_outlined),
            SizedBox(width: 4),
            Text("L"),
          ],
        ),
      ),
    ];

    seating = const [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("2 people"),
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("3 people"),
      ),
    ];
  }

  // TextEditingController descriptionController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();

  void addNewVehicle() async {
    String luggage;

    if (toggleValues[1] == true) {
      luggage = "S";
    } else if (toggleValues[2] == true) {
      luggage = "M";
    } else if (toggleValues[3] == true) {
      luggage = "L";
    } else {
      luggage = "No luggage";
    }

    int seatingCapacity = 0;

    if (seatingValues[0] == true) {
      seatingCapacity = 2;
    } else {
      seatingCapacity = 3;
    }

    if (formKey.currentState!.validate()) {
      Vehicle newVehicle = Vehicle(
        userId: FirebaseAuth.instance.currentUser!.uid,
        model: modelController.text,
        type: typeController.text,
        color: colorController.text,
        year: yearController.text,
        licensePlate: licensePlateController.text,
        luggageSize: luggage,
        seatingCapacity: "$seatingCapacity",
        isWinterTyres: isWinterTyres,
        isSnowboards: isSnowboards,
        isBikes: isBikes,
        isPets: isPets,
      );

      await VehicleServices()
          .addVehicle(
              vehicle: newVehicle, vehicleImage: File(selectedImage!.path))
          .then((value) {
        Navigator.pop(context);
      });
    }
  }

  final GlobalKey<FormState> formKey = GlobalKey();

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
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Add a vehicle",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: GestureDetector(
                      onTap: () {
                        chooseImage();
                      },
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFFCECECE),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  File(selectedImage!.path),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ),
                    // child: textField(
                    //   descriptionController,
                    //   maxLines: 6,
                    // ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        'assets/icons/description.png',
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      "Model",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: textField(modelController),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      "Type",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: textField(typeController),
                  ),
                  const SizedBox(
                    width: 80,
                    child: Center(
                      child: Text(
                        "Color",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: textField(colorController),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      "Year",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: textField(yearController),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(
                    width: 80,
                    child: Text(
                      "License Plate",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Expanded(
                    child: textField(licensePlateController),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Luggage",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ToggleButtons(
                  onPressed: (index) {
                    for (int i = 0; i < toggleValues.length; i++) {
                      if (toggleValues[i] == true) {
                        setState(() {
                          toggleValues[i] = false;
                        });
                      }
                    }
                    setState(() {
                      toggleValues[index] = true;
                    });
                  },
                  fillColor: Colors.black,
                  selectedColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  isSelected: toggleValues,
                  children: carryBaggages,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Maximum seating",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Pledge to a maximum of 2 people in the back for better reviews",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ToggleButtons(
                  onPressed: (index) {
                    for (int i = 0; i < seatingValues.length; i++) {
                      if (seatingValues[i] == true) {
                        setState(() {
                          seatingValues[i] = false;
                        });
                      }
                    }
                    setState(() {
                      seatingValues[index] = true;
                    });
                  },
                  fillColor: Colors.black,
                  selectedColor: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  isSelected: seatingValues,
                  children: seating,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Other",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                setState(() {
                  isWinterTyres = !isWinterTyres;
                });
              },
              leading: Image.asset(
                "assets/icons/tire.png",
                height: 26,
                width: 26,
              ),
              title: const Text("Winter tyres"),
              trailing: isWinterTyres
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 26,
                    )
                  : null,
            ),
            ListTile(
              onTap: () {
                setState(() {
                  isSnowboards = !isSnowboards;
                });
              },
              leading: Image.asset(
                "assets/icons/snowboard.png",
                height: 26,
                width: 26,
              ),
              title: const Text("Snowboards"),
              trailing: isSnowboards
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 26,
                    )
                  : null,
            ),
            ListTile(
              onTap: () {
                setState(() {
                  isBikes = !isBikes;
                });
              },
              leading: Image.asset(
                "assets/icons/bicycle.png",
                height: 26,
                width: 26,
              ),
              title: const Text("Bikes"),
              trailing: isBikes
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 26,
                    )
                  : null,
            ),
            ListTile(
              onTap: () {
                setState(() {
                  isPets = !isPets;
                });
              },
              leading: Image.asset(
                "assets/icons/pet.png",
                height: 26,
                width: 26,
              ),
              title: const Text("Pets"),
              trailing: isPets
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.green,
                      size: 26,
                    )
                  : null,
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        GestureDetector(
          onTap: () {
            if (selectedImage != null) {
              addNewVehicle();
            } else {
              Fluttertoast.showToast(
                  msg: "Please upload an image of your vehicle");
            }
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Center(
              child: Text(
                "Add Vehicle",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget textField(
    TextEditingController controller, {
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        filled: true,
        fillColor: maxLines != null ? Colors.white : const Color(0xFFECECEC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: maxLines != null
              ? const BorderSide(
                  color: Color(0xFFCECECE),
                )
              : BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: maxLines != null
              ? const BorderSide(
                  color: Color(0xFFCECECE),
                )
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: maxLines != null
              ? const BorderSide(
                  color: Color(0xFFCECECE),
                )
              : BorderSide.none,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: maxLines != null
              ? const BorderSide(
                  color: Colors.red,
                )
              : BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill the required field';
        }
        return null;
      },
    );
  }

  void chooseImage() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Choose image from",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Divider(
                  height: 1,
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  openImagePicker(imageSource: ImageSource.camera);
                },
                title: const Center(
                  child: Text("Camera"),
                ),
              ),
              const Divider(
                height: 1,
              ),
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  openImagePicker(imageSource: ImageSource.gallery);
                },
                title: const Center(
                  child: Text("Gallery"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  XFile? selectedImage;
  String? imageName;
  void openImagePicker({required ImageSource imageSource}) async {
    selectedImage = await ImagePicker().pickImage(source: imageSource);
    setState(() {
      imageName = selectedImage!.path.split('/').last.split('-').last;
      log("Image path : $imageName");
    });
  }
}
