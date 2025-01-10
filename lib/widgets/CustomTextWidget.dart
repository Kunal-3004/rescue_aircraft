import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon prefixIcon;
  final bool enabled;

  CustomTextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          fillColor: Colors.white,
          hintText: hintText,
          prefixIcon: prefixIcon,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
          ),
        ),
      ),
    );
  }
}
