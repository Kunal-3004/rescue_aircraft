import 'package:flutter/material.dart';
import 'package:rescue_aircraft/widgets/text.dart';

import '../screens/aircraftDetailScreen.dart';

class AircraftCard extends StatelessWidget {
  final String callSign;
  final String time;
  final String country;
  final dynamic details;

  const AircraftCard({
    super.key,
    required this.callSign,
    required this.time,
    required this.country,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AircraftDetailScreen(callsign: callSign,),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(12.0),
                child: Icon(
                  Icons.airplanemode_active,
                  size: 32,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                        text:callSign.isNotEmpty ? callSign : "Unknown",
                        fontColor: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                    SizedBox(height: 4),
                    Text(
                      country,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Last Update: $time',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Navigate Icon
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
