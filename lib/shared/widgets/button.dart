import 'package:flutter/material.dart';
import 'package:rescue_aircraft/utils/gradient.dart';

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
          gradient: kBlueGradient,
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
