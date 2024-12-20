import 'package:flutter/material.dart';
import 'package:rescue_aircraft/screens/profile.dart';
import 'package:rescue_aircraft/screens/report.dart';
import 'package:rescue_aircraft/widgets/card.dart';
import 'package:rescue_aircraft/widgets/drawer.dart';

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
      drawer:HomeDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
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
            Container(
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Perform Search and Rescue Operation for Missing Aircraft",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.purple, ),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                        child: RescueCard(title: "Rescue a missing aircraft", desc:"Fill the last known information about aircraft like coordinates,velocity,altitude,etc", icon: Icons.book,icColor: Colors.blueGrey,)),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                        child: RescueCard(title: "Identify most suitable search pattern", desc:"Hit and trial available algorithm to sweep the search area to find suitable aircraft", icon: Icons.swap_horizontal_circle,icColor: Colors.black,)),
                  ],
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 70,
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        child: RescueCard(title: "Predict the search area", desc:"Identify the probable search area.Get real time information of area for search and rescue strategy", icon: Icons.search,icColor: Colors.black,)),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        child: RescueCard(title: "Get Detailed Analysis", desc:"Get the search and rescue operations results and detailed analysis of information", icon: Icons.bar_chart_rounded, icColor: Colors.deepOrangeAccent,)),
                  ],
                )
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10,top: 20),
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
                borderRadius: BorderRadius.circular(8)
              ),
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Report()));
                  },
                  child: Text(
                    "Click here to report a missing aircraft",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
