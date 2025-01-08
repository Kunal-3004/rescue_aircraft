import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rescue_aircraft/screens/searchArea.dart';
import 'package:rescue_aircraft/utils/constant.dart';
import 'package:rescue_aircraft/utils/openSkyUser.dart';
import 'package:rescue_aircraft/widgets/drawer.dart';

import '../widgets/aircraftCard.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<dynamic> aircraftData = [];
  List<dynamic> filteredAircraftData = [];
  Map<String, dynamic>? details;
  TextEditingController searchController = TextEditingController();

  final String username = Data.username;
  final String password = Data.password;

  TextEditingController callsignController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController lastContactController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController altitudeController = TextEditingController();
  TextEditingController velocityController = TextEditingController();
  TextEditingController directionController = TextEditingController();
  TextEditingController verticalRateController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAircraftData();
    searchController.addListener(() {
      filteredData(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    callsignController.dispose();
    countryController.dispose();
    timeController.dispose();
    super.dispose();
  }

  Future<void> fetchAircraftData() async {
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
      final data = jsonDecode(response.body);
      setState(() {
        aircraftData = data['states'] ?? [];
        for (var aircraft in aircraftData) {
          int? timePosition = aircraft[3];
          if (timePosition != null) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
                timePosition * 1000);
            String formattedTime = dateTime.toLocal().toString();
            aircraft[3] = formattedTime;
          }
        }
        filteredAircraftData = aircraftData;
      });
    } else {
      print('Failed to load aircraft data');
    }
  }

  void filteredData(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredAircraftData = aircraftData;
      });
      return;
    }
    final lowerCaseQuery = query.toLowerCase();

    setState(() {
      filteredAircraftData = aircraftData.where((aircraft) {
        final callsign = (aircraft[1] ?? '').toString().toLowerCase();
        final country = (aircraft[2] ?? '').toString().toLowerCase();
        return callsign.contains(lowerCaseQuery) ||
            country.contains(lowerCaseQuery);
      }).toList();
    });
  }

  void _showAddReportDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Aircraft Report"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: callsignController,
                  decoration: InputDecoration(
                    labelText: "Callsign",
                    hintText: "Enter aircraft callsign",
                  ),
                ),
                TextField(
                  controller: countryController,
                  decoration: InputDecoration(
                    labelText: "Country",
                    hintText: "Enter country",
                  ),
                ),
                TextField(
                  controller: timeController,
                  decoration: InputDecoration(
                    labelText: "Time",
                    hintText: "Enter date and time",
                  ),
                ),
                TextField(
                  controller: lastContactController,
                  decoration: InputDecoration(
                    labelText: "LastContact",
                    hintText: "Enter lastContact",
                  ),
                ),
                TextField(
                  controller: latitudeController,
                  decoration: InputDecoration(
                    labelText: "Latitude",
                    hintText: "Enter latitude",
                  ),
                ),
                TextField(
                  controller: longitudeController,
                  decoration: InputDecoration(
                    labelText: "Longitude",
                    hintText: "Enter longitude",
                  ),
                ),
                TextField(
                  controller: altitudeController,
                  decoration: InputDecoration(
                    labelText: "Altitude",
                    hintText: "Enter altitude in meters",
                  ),
                ),
                TextField(
                  controller: velocityController,
                  decoration: InputDecoration(
                    labelText: "Velocity",
                    hintText: "Enter velocity in m/s",
                  ),
                ),
                TextField(
                  controller: directionController,
                  decoration: InputDecoration(
                    labelText: "Direction",
                    hintText: "Enter direction from north in degree",
                  ),
                ),
                TextField(
                  controller: verticalRateController,
                  decoration: InputDecoration(
                    labelText: "Vertical Rate",
                    hintText: "Enter vertical rate in m/s",
                  ),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(
                    labelText: "Category",
                    hintText: "Enter category",
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                print("Add Report Button Pressed");
                setState(() {
                  if (callsignController.text.isNotEmpty &&
                      countryController.text.isNotEmpty &&
                      timeController.text.isNotEmpty &&
                      lastContactController.text.isNotEmpty &&
                      latitudeController.text.isNotEmpty &&
                      longitudeController.text.isNotEmpty &&
                      altitudeController.text.isNotEmpty &&
                      velocityController.text.isNotEmpty &&
                      directionController.text.isNotEmpty &&
                      verticalRateController.text.isNotEmpty &&
                      categoryController.text.isNotEmpty) {

                    details = {
                      'callsign': callsignController.text,
                      'origin_country': countryController.text,
                      'time_position': timeController.text,
                      'last_contact': lastContactController.text,
                      'latitude': double.tryParse(latitudeController.text) ?? 0.0,
                      'longitude': double.tryParse(longitudeController.text) ?? 0.0,
                      'geo_altitude': double.tryParse(altitudeController.text) ?? 0.0,
                      'velocity': double.tryParse(velocityController.text) ?? 0.0,
                      'heading': double.tryParse(directionController.text) ?? 0.0,
                      'vertical_rate': double.tryParse(verticalRateController.text) ?? 0.0,
                      'category': categoryController.text,
                      'crashLocation': {'latitude': 0.0, 'longitude': 0.0},
                    };
                  }
                });
                print("Fetching crash location...");
                await fetchCrashLocation();

                print("Crash location fetched: ${details!['crashLocation']}");

                if (details != null && details!['crashLocation'] == null) {
                  details!['crashLocation'] = {
                    'latitude': 0.0,
                    'longitude': 0.0,
                  };
                }

                List<List<dynamic>> aircraft = [
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
                    details!['crashLocation'] ?? {'latitude': 0.0, 'longitude': 0.0},
                  ]
                ];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchArea(aircraftData: aircraft),
                  ),
                ).then((_) {
                  Navigator.pop(context);
                });
              },
              child: Text("Add Report"),
            ),
          ],
        );
      },
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
        print("API request completed. Status code: ${response.statusCode}");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: HomeDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: Colors.black, size: 40),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by callsign or country...',
                        prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  IconButton(
                    icon: Icon(Icons.add_circle_outline, color: Colors.black, size: 40),
                    onPressed: () {
                      _showAddReportDialog();
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredAircraftData.isEmpty
                  ? Center(child: CircularProgressIndicator(color: Colors.blueAccent))
                  : ListView.builder(
                itemCount: filteredAircraftData.length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final aircraft = filteredAircraftData[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: AircraftCard(
                      callSign: aircraft[1] ?? "Unknown",
                      time: aircraft[3]?.toString() ?? "Unknown",
                      country: aircraft[2] ?? "Unknown",
                      details: aircraft,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
