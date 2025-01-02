import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rescue_aircraft/screens/report.dart';
import 'package:rescue_aircraft/screens/searchArea.dart';
import 'package:rescue_aircraft/utils/constant.dart';

class AircraftDetailScreen extends StatefulWidget {
  final String callsign;
  const AircraftDetailScreen({super.key, required this.callsign});

  @override
  _AircraftDetailScreenState createState() => _AircraftDetailScreenState();
}

class _AircraftDetailScreenState extends State<AircraftDetailScreen> {
  Map<String, dynamic>? details;
  Timer? _timer;
  final String username = "kunal_3004";
  final String password = "kunal.2580";

  @override
  void initState() {
    super.initState();
    fetchDetails();
    startAutoUpdate();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startAutoUpdate() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      fetchDetails();
    });
  }

  Future<void> fetchDetails() async {
    final url = Uri.parse(Utils.openApi);
    final credentials = '$username:$password';
    final base64Credentials = base64Encode(utf8.encode(credentials));
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Basic $base64Credentials',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final aircraftList = data['states'] ?? [];
      final aircraft = aircraftList.firstWhere(
            (plane) => plane[1] == widget.callsign,
        orElse: () => null,
      );

      if (aircraft != null) {
        setState(() {
          String formatDateTime(int timestamp) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
            final format = DateFormat("yyyy-MM-dd HH:mm:ss");
            return format.format(dateTime);
          }

          details = {
            'callsign': aircraft[1],
            'origin_country': aircraft[2],
            'time_position': formatDateTime(aircraft[3]),
            'last_contact': formatDateTime(aircraft[4]),
            'latitude': aircraft[6],
            'longitude': aircraft[5],
            'geo_altitude': aircraft[13],
            'velocity': aircraft[9],
            'heading': aircraft[10],
            'vertical_rate':aircraft[11],
            'category': getCategoryName(aircraft[16]),
          };
        });
        await fetchCrashLocation();
      }
    } else {
      print('Failed to fetch aircraft details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 15),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Report()));
                },
                  child: Icon(Icons.arrow_back_ios, size: 32)
              ),
              SizedBox(width: 40),
              Column(
                children: [
                  SizedBox(height: 100),
                  Text(
                    "Airplane Detail",
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          details == null
              ? Center(child: CircularProgressIndicator())
              : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Section
                    Center(
                      child: Text(
                        details!['callsign'] ?? "Unknown",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff00bfff),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Divider(thickness: 1.0),
                    SizedBox(height: 16),
                    buildDetailRow('Origin Country', details!['origin_country']),
                    buildDetailRow('Time Position', details!['time_position']),
                    buildDetailRow('Last Contact', details!['last_contact']),
                    buildDetailRow('Latitude', details!['latitude']),
                    buildDetailRow('Longitude', details!['longitude']),
                    buildDetailRow('Geometric Altitude', details!['geo_altitude']),
                    buildDetailRow('Velocity', details!['velocity']),
                    buildDetailRow('Heading', details!['heading']),
                    buildDetailRow('Vertical Rate', details!['vertical_rate']),
                    buildDetailRow('Category', details!['category']),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 60,
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
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width/2,
            child: Center(
              child: TextButton(
                onPressed: (){
                  List<List<dynamic>> aircraftData = [
                    [
                      details!['callsign'],
                      details!['origin_country'],
                      details!['time_position'],
                      details!['last_contact'],
                      details!['latitude'],
                      details!['longitude'],
                      details!['geo_altitude'],
                      details!['velocity'],
                      details!['heading'],
                      details!['vertical_rate'],
                      details!['category'],
                      details!['crashLocation'] ?? {'latitude': null, 'longitude': null},
                    ]
                  ];
                  Navigator.push(context, MaterialPageRoute(builder:
                  (context)=>SearchArea(aircraftData: aircraftData)
                  ));
                },
                child: Text(
                  "Search aircraft",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildDetailRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value != null ? value.toString() : "Unknown",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> fetchCrashLocation() async {
    if (details != null) {
      double latitude = details!['latitude'] ?? 0.0;
      double longitude = details!['longitude'] ?? 0.0;
      double heading = details!['heading'] ?? 0.0;
      double altitude = details!['geo_altitude'] ?? 0.0;
      double velocity = details!['velocity'] ?? 0.0;

      final url = Uri.parse(Utils.calLatLngApi);

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'latitude': latitude,
            'longitude': longitude,
            'heading': heading,
            'altitude': altitude,
            'velocity': velocity,
          }),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          double crashLatitude = data['expectedCoordinates']['latitude'];
          double crashLongitude = data['expectedCoordinates']['longitude'];

          setState(() {
            details!['crashLocation'] = {
              'latitude': crashLatitude,
              'longitude': crashLongitude,
            };
          });
          print('Crash Location: Latitude = $crashLatitude, Longitude = $crashLongitude');

        } else {
          print('Failed to fetch crash location. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching crash location: $e');
      }
    } else {
      print('Aircraft details not available for crash location calculation');
    }
  }
}

String getCategoryName(int category) {
  switch (category) {
    case 0:
      return "No information at all";
    case 1:
      return "No ADS-B Emitter Category Information";
    case 2:
      return "Light (< 15500 lbs)";
    case 3:
      return "Small (15500 to 75000 lbs)";
    case 4:
      return "Large (75000 to 300000 lbs)";
    case 5:
      return "High Vortex Large (B-757)";
    case 6:
      return "Heavy (> 300000 lbs)";
    case 7:
      return "High Performance (> 5g acceleration and 400 kts)";
    case 8:
      return "Rotorcraft";
    case 9:
      return "Glider / sailplane";
    case 10:
      return "Lighter-than-air";
    case 11:
      return "Parachutist / Skydiver";
    case 12:
      return "Ultralight / hang-glider / paraglider";
    case 13:
      return "Reserved";
    case 14:
      return "Unmanned Aerial Vehicle";
    case 15:
      return "Space / Trans-atmospheric vehicle";
    case 16:
      return "Surface Vehicle – Emergency Vehicle";
    case 17:
      return "Surface Vehicle – Service Vehicle";
    case 18:
      return "Point Obstacle (includes tethered balloons)";
    case 19:
      return "Cluster Obstacle";
    case 20:
      return "Line Obstacle";
    default:
      return "Unknown Category";
  }
}


