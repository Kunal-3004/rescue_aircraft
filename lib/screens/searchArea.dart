import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:rescue_aircraft/utils/constant.dart';

class SearchArea extends StatefulWidget {
  final List<List<dynamic>> aircraftData;
  const SearchArea({super.key, required this.aircraftData});

  @override
  State<SearchArea> createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  String? _selectedItem;
  bool _isCheckedRoad = false;
  bool _isCheckedHospital = false;
  bool _isCheckedOthers = false;

  TextEditingController subAreaSide=TextEditingController();
  TextEditingController helperDataRadius=TextEditingController();
  TextEditingController SearchAreaBuffer=TextEditingController();

  final List<String> _areaType = ["Rectangle", "Circular", "Accurate"];
  final String googleApiKey = "AlzaSyXVzb4FFLcTL26dAjdeuoGXu8-dbcUgq_c";

  late BitmapDescriptor airplaneIcon;
  late BitmapDescriptor policeStationIcon;
  late BitmapDescriptor hospitalIcon;
  late Future<void> _loadAirplaneIcon;
  late BitmapDescriptor crashIcon;
  late Future<void> _loadCrashIcon;

  MapType _mapType = MapType.normal;

  @override
  void initState() {
    super.initState();
    _loadAirplaneIcon = _loadIcon();
    _loadCrashIcon=_loadIcon();

  }

  void _addPolygonAndGrid(Map geoJson, Map filteredGrid) {
    if (geoJson == null || filteredGrid == null) {
      print("GeoJSON or filteredGrid is null");
      return;
    }

    final coordinates = geoJson['features']?[0]?['geometry']?['coordinates']?[0];
    if (coordinates == null || coordinates.isEmpty) {
      print("Invalid GeoJSON structure: Missing coordinates");
      return;
    }

    List<LatLng> polygonPoints = coordinates.map<LatLng>((point) {
      double latitude = _parseToDouble(point[1]);
      double longitude = _parseToDouble(point[0]);
      return LatLng(latitude, longitude);
    }).toList();

    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId('mainPolygon'),
        color: Colors.orange,
        width: 5,
        points: polygonPoints,
      ));

      for (var feature in filteredGrid['features'] ?? []) {
        final gridCoordinates = feature['geometry']?['coordinates']?[0];
        if (gridCoordinates == null || gridCoordinates.isEmpty) continue;

        List<LatLng> gridPoints = gridCoordinates.map<LatLng>((point) {
          double latitude = _parseToDouble(point[1]);
          double longitude = _parseToDouble(point[0]);
          return LatLng(latitude, longitude);
        }).toList();

        _polylines.add(Polyline(
          polylineId: PolylineId('grid_${feature['id'] ?? DateTime.now().millisecondsSinceEpoch}'),
          color: Colors.red,
          width: 2,
          points: gridPoints,
        ));
      }
    });
  }

  Future<void> _loadIcon() async {
    airplaneIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(10, 10)),
      'images/aeroplane_icon.png',
    );
    crashIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(10,10)),
      'images/crash_marker.png',
    );
    policeStationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(10, 10)),
      'images/police-station_marker.png',
    );
    hospitalIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(10, 10)),
      'images/hospital_marker.png',
    );
    final aircraft = widget.aircraftData[0];
    print('Full Aircraft Data: $aircraft');
    double latitude = double.tryParse(aircraft[4]?.toString() ?? '0') ?? 0.0;
    double longitude = double.tryParse(aircraft[5]?.toString() ?? '0') ?? 0.0;
    double heading = double.tryParse(aircraft[8]?.toString() ?? '0') ?? 0.0;

    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(aircraft[0]),
        position: LatLng(latitude, longitude),
        icon: airplaneIcon,
        rotation: heading,
      ));
      Map crashLocation = aircraft[11];
      print('Raw Crash Location: $crashLocation');
      double crashLatitude = _parseToDouble(crashLocation['latitude']);
      double crashLongitude = _parseToDouble(crashLocation['longitude']);

      print('Crash Latitude: $crashLatitude, Crash Longitude: $crashLongitude');

      _markers.add(Marker(
        markerId: MarkerId('crashLocation'),
        position: LatLng(crashLatitude, crashLongitude),
        icon: crashIcon,
      ));
      _polylines.add(Polyline(
        polylineId: PolylineId('dotted_line'),
        color: Colors.blue,
        width: 5,
        points: [LatLng(latitude, longitude), LatLng(crashLatitude, crashLongitude)],
        patterns: [PatternItem.dash(10), PatternItem.gap(10)],
      )
      );
    });
  }

  double _parseToDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
  Future<Map<String, dynamic>> fetchCalculatedArea(
      LatLng center, double side, double direction, double cellSize) async {
    final response = await http.post(
      Uri.parse(Utils.calAreaApi),
      body: json.encode({
        'newLatLon': [center.latitude, center.longitude],
        'side': side,
        'direction': direction,
        'cellSide': cellSize,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    print("Center: ${center.latitude}, ${center.longitude}");
    print("Side: $side, Direction: $direction, CellSize: $cellSize");


    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      double someValue = result['someKey'] is int
          ? (result['someKey'] as int).toDouble()
          : result['someKey'] is double
          ? result['someKey']
          : 0.0;
      print("Fetched GeoJSON: $result");
      return result;
    } else {
      throw Exception('Failed to fetch calculated area');
    }
  }
  Future<Map<String, dynamic>> fetchCalculatedCircularArea(
      LatLng center, double side, double direction, double cellSize) async {
    final response = await http.post(
      Uri.parse(Utils.calCircleApi),
      body: json.encode({
        'newLatLon': [center.latitude, center.longitude],
        'side': side,
        'direction': direction,
        'cellSide': cellSize,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    print("Center: ${center.latitude}, ${center.longitude}");
    print("Side: $side, Direction: $direction, CellSize: $cellSize");


    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      double someValue = result['someKey'] is int
          ? (result['someKey'] as int).toDouble()
          : result['someKey'] is double
          ? result['someKey']
          : 0.0;
      print("Fetched GeoJSON: $result");
      return result;
    } else {
      throw Exception('Failed to fetch calculated area');
    }
  }

  double calculateEffectiveRadius(String radiusText, String bufferText) {
    double radius = double.tryParse(radiusText) ?? 0.0;
    double buffer = double.tryParse(bufferText) ?? 0.0;

    return radius + (2 * buffer);
  }


  Future<void> fetchNearbyPlaces(LatLng location, String type) async {
    final url =
        'https://maps.gomaps.pro/maps/api/place/nearbysearch/json?location=${location
        .latitude},${location
        .longitude}&radius=5000&type=$type&language=en&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      setState(() {
        _markers.removeWhere((marker) =>
            marker.markerId.value.startsWith(type));

        for (var place in results) {
          final LatLng placeLocation = LatLng(
            place['geometry']['location']['lat'],
            place['geometry']['location']['lng'],
          );
          BitmapDescriptor markerIcon;

          if (type == 'police_station' && _isCheckedRoad) {
            markerIcon = policeStationIcon;
            _markers.add(
              Marker(
                markerId: MarkerId("police_${place['place_id']}"),
                position: placeLocation,
                infoWindow: InfoWindow(
                  title: place['name'],
                  snippet: place['vicinity'],
                ),
                icon: markerIcon,
              ),
            );
          } else if (type == 'hospital' && _isCheckedHospital) {
            markerIcon = hospitalIcon;
            _markers.add(
              Marker(
                markerId: MarkerId("hospital_${place['place_id']}"),
                position: placeLocation,
                infoWindow: InfoWindow(
                  title: place['name'],
                  snippet: place['vicinity'],
                ),
                icon: markerIcon,
              ),
            );
          }
        }
      });
    } else {
      print('Failed to fetch nearby places');
    }
  }

  @override
  Widget build(BuildContext context) {
    final aircraft = widget.aircraftData[0];
    double latitude = double.tryParse(aircraft[4]?.toString() ?? '0') ?? 0.0;
    double longitude = double.tryParse(aircraft[5]?.toString() ?? '0') ?? 0.0;

    Map crashLocation = aircraft[11];
    double crashLatitude = _parseToDouble(crashLocation['latitude']);
    double crashLongitude = _parseToDouble(crashLocation['longitude']);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: FutureBuilder<void>(
            future: _loadAirplaneIcon,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error loading icon'));
              }
              return Column(
                children: [
                  Container(
                    height: 300,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(latitude, longitude),
                        zoom: 10,
                      ),
                      markers: _markers,
                      polylines: _polylines,
                      mapType: _mapType,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Select map type",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButton<MapType>(
                                value: _mapType,
                                isExpanded: true,
                                onChanged: (MapType? newType) {
                                  setState(() {
                                    _mapType = newType!;
                                  });
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: MapType.normal,
                                    child: Text('Normal View'),
                                  ),
                                  DropdownMenuItem(
                                    value: MapType.satellite,
                                    child: Text('Satellite View'),
                                  ),
                                  DropdownMenuItem(
                                    value: MapType.terrain,
                                    child: Text('Terrain View'),
                                  ),
                                  DropdownMenuItem(
                                    value: MapType.hybrid,
                                    child: Text('Hybrid View'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Select search area type",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: DropdownButton<String>(
                                value: _selectedItem,
                                isExpanded: true,
                                hint: const Text("Select area type"),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedItem =newValue;
                                  });
                                },
                                items: _areaType.map<DropdownMenuItem<String>>((
                                    String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Load additional information",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0, left: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isCheckedRoad,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isCheckedRoad = value ?? false;
                                          if (_isCheckedRoad) {
                                            fetchNearbyPlaces(
                                              LatLng(crashLatitude, crashLongitude),
                                              'police_station',
                                            );
                                          } else {
                                            _markers.removeWhere((marker) =>
                                                marker.markerId.value.startsWith(
                                                    'police'));
                                          }
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Police Station',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isCheckedHospital,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isCheckedHospital = value ?? false;
                                          if (_isCheckedHospital) {
                                            fetchNearbyPlaces(
                                              LatLng(crashLatitude, crashLongitude),
                                              'hospital',
                                            );
                                          } else {
                                            _markers.removeWhere((marker) =>
                                                marker.markerId.value.startsWith(
                                                    'hospital'));
                                          }
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Hospitals',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isCheckedOthers,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isCheckedOthers = value ?? false;
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Others',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Helper Data Radius(Km)",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: TextField(
                              controller: helperDataRadius,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: '20',
                                prefixIcon: Icon(
                                  Icons.pie_chart,
                                  size: 25,
                                  color: Colors.blueAccent,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.black, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Search Area Buffer(Km)",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: TextField(
                              controller: SearchAreaBuffer,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: '20',
                                prefixIcon: Icon(
                                  Icons.share_location,
                                  size: 25,
                                  color: Colors.blueAccent,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.black, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Subarea Side(Km)",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, right: 10),
                            child: TextField(
                              controller: subAreaSide,
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                hintText: '20',
                                prefixIcon: Icon(
                                  Icons.multiple_stop_outlined,
                                  size: 25,
                                  color: Colors.blueAccent,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.black, width: 2),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Card(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.black,width: 1),
                            ),
                            elevation: 6,
                            child: Padding(
                                padding:const EdgeInsets.only(left: 20,right: 20,top:10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text("Crash Area Information",style: TextStyle(
                                      fontSize: 22,fontWeight: FontWeight.w500,
                                    ),),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Type",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        hintText: 'Land',
                                        enabled: false,
                                        prefixIcon: Icon(
                                          Icons.landscape,
                                          size: 25,
                                          color: Colors.blueAccent,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 20),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.black, width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent, width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Area",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        hintText: '273 sq m',
                                        enabled: false,
                                        prefixIcon: Icon(
                                          Icons.architecture_outlined,
                                          size: 25,
                                          color: Colors.blueAccent,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 20),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.black, width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent, width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Shape",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        hintText: 'Rectangle',
                                        enabled: false,
                                        prefixIcon: Icon(
                                          Icons.format_shapes,
                                          size: 25,
                                          color: Colors.blueAccent,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 20),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.black, width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent, width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Description",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        enabled: false,
                                        hintText: 'This is dangerous.',
                                        prefixIcon: Icon(
                                          Icons.description_outlined,
                                          size: 25,
                                          color: Colors.blueAccent,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 20),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.black, width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent, width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Crash Point",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        enabled: false,
                                        hintText: '24,78.3',
                                        prefixIcon: Icon(
                                          Icons.location_searching,
                                          size: 25,
                                          color: Colors.blueAccent,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 14, horizontal: 20),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(color: Colors.black, width: 2),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.blueAccent, width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            )
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
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
                    width: MediaQuery.of(context).size.width/2.2,
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          final aircraft = widget.aircraftData[0];
                          Map crashLocation = aircraft[11];
                          double crashLatitude = _parseToDouble(crashLocation['latitude']);
                          double crashLongitude = _parseToDouble(crashLocation['longitude']);
                          double heading = double.tryParse(aircraft[8]?.toString() ?? '0') ?? 0.0;

                          double side = calculateEffectiveRadius(helperDataRadius.text.trim(), SearchAreaBuffer.text.trim());
                          double direction = heading;
                          double cellSize = double.tryParse(subAreaSide.text.trim()) ?? 0.0;
                          LatLng center = LatLng(crashLatitude,crashLongitude);

                          if(_selectedItem=="Rectangle"){
                            fetchCalculatedArea(center, side, direction, cellSize).then((result) {
                              _addPolygonAndGrid(result['geojson'], result['filteredGrid']);
                            }).catchError((error) {
                              print("Error fetching area: $error");
                            });
                          }
                          if(_selectedItem=="Circular"){
                            fetchCalculatedCircularArea(center, side, direction, cellSize).then((result) {
                              _addPolygonAndGrid(result['geojson'], result['filteredGrid']);
                            }).catchError((error) {
                              print("Error fetching area: $error");
                            });
                          }
                        },
                        child: Text(
                          "Find Area",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}