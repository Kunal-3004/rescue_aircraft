import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String text;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;
  const MyText({super.key, required this.text, required this.fontColor, required this.fontSize, required this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }
}
