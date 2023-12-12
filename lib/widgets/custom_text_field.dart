import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final Function()? onTapped;
  final TextEditingController controller;
  final int? maxLines;
  final Icon? icon;
  final String hint;
  const CustomTextField({
    required this.controller,
    this.onTapped,
    required this.hint,
    this.icon,
    this.maxLines,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapped,
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          enabled: onTapped != null ? false : true,
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
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
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
    );
  }
}
