import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String name;
  final Future<void> Function() perform;
  final double btnHeight;
  final double btnWidth;
  final Color nameColor;
  final double nameSize;
  final FontWeight nameWeight;
  const MyButton({super.key, required this.name, required this.perform, required this.btnHeight, required this.btnWidth, required this.nameColor, required this.nameSize, required this.nameWeight});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: btnHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff87ceeb),
              Color(0xff00bfff),
              Color(0xff4682b4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        width: btnWidth,
        child: Center(
          child: TextButton(
            onPressed: (){
              perform();
            },
            child: Text(
              name,
              style: TextStyle(
                color: nameColor,
                fontSize: nameSize,
                fontWeight: nameWeight,
              ),
            ),
          ),
        ),
    );
  }
}
