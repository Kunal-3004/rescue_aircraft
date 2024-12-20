import 'package:flutter/material.dart';

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
          Text(
            title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            desc,
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 12),
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
