import 'package:flutter/material.dart';
import 'package:rescue_aircraft/screens/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xff00bfff),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Icon(Icons.location_searching,color: Colors.white,size: 28,),
                  SizedBox(
                    width: 20,
                  ),
                  const Text(
                    "Search and Rescue ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                ListTile(
                  title: Text("Main",
                    style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.home,size: 35,),
                          SizedBox(
                            width: 30,
                          ),
                          Text("Home",style: TextStyle(
                            fontSize: 22,color: Colors.black,
                          ),)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.airplanemode_active_sharp,size: 35,),
                          SizedBox(
                            width: 30,
                          ),
                          Text("Report",style: TextStyle(
                              fontSize: 22,color: Colors.black,
                          ),)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text("Search and Rescue",
                    style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.zoom_in_map,size: 35,),
                          SizedBox(
                            width: 30,
                          ),
                          Text("Search Area",style: TextStyle(
                            fontSize: 22,color: Colors.black,
                          ),)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.airplanemode_active_sharp,size: 35,),
                          SizedBox(
                            width: 30,
                          ),
                          Text("Sweep Pattern",style: TextStyle(
                            fontSize: 22,color: Colors.black,
                          ),)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.bar_chart_outlined,size: 35,),
                          SizedBox(
                            width: 30,
                          ),
                          Text("Results",style: TextStyle(
                            fontSize: 22,color: Colors.black,
                          ),)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text("Extras",
                    style: TextStyle(color: Colors.grey[400],fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_outlined,size: 35,),
                          SizedBox(
                            width: 30,
                          ),
                          Text("Alerts",style: TextStyle(
                            fontSize: 22,color: Colors.black,
                          ),)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.android,size: 35,),
                          SizedBox(
                            width: 30,
                          ),
                          Text("About us",style: TextStyle(
                            fontSize: 22,color: Colors.black,
                          ),)
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
                child: const Icon(
                  Icons.menu,
                  color: Colors.black,
                  size: 40,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    fillColor: Colors.grey[200],
                    filled: true,
                    hintText: "Search",
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 25,
                      color: Colors.blueAccent,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                          color: Colors.blueAccent, width: 2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()),
                  );
                },
                child: const Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
