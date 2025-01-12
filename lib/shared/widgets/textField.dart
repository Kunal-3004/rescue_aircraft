import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controllerName;
  final String hintText;
  final IconData icon;
  final Color? fillColor;
  final double iconSize;
  final Color iconColor;
  const MyTextField({super.key, required this.controllerName, required this.hintText, required this.icon, required this.fillColor, required this.iconSize, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controllerName,
      decoration: InputDecoration(
        filled: true,
        fillColor: fillColor,
        hintText: hintText,
        prefixIcon: Icon(
          icon,
          size: iconSize,
          color: iconColor,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
}
