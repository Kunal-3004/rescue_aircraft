import 'package:flutter/material.dart';
import 'package:rescue_aircraft/widgets/text.dart';

class RescueCard extends StatelessWidget {
  final String title;
  final String desc;
  final IconData icon;
  final Color icColor;
  const RescueCard({super.key, required this.title, required this.desc, required this.icon, required this.icColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: 170,
      width: 170,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          MyText(
              text: title,
              fontColor: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold
          ),
          SizedBox(
            height: 4,
          ),
          MyText(
              text: desc,
              fontColor: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500
          ),
          SizedBox(
            height: 7,
          ),
          Icon(
            icon,
            color: icColor,
            size: 30,
          ),
        ],
      ),
    );
  }
}
