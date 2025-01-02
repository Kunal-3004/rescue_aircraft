import 'package:flutter/material.dart';
import 'package:rescue_aircraft/screens/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String selectedScreen = '/home';

  @override
  Widget build(BuildContext context) {
    selectedScreen = ModalRoute.of(context)?.settings.name ?? '/home';

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(top: 5, left: 5, right: 5),
            decoration: BoxDecoration(
              color: Color(0xff00bfff),
            ),
            child: Row(
              children: [
                SizedBox(width: 5),
                Icon(Icons.location_searching, color: Colors.white, size: 28),
                SizedBox(width: 20),
                const Text(
                  "Search and Rescue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Column(
            children: [
              ListTile(
                title: Text(
                  "Main",
                  style: TextStyle(
                      color: Colors.grey[400], fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  _drawerItem(
                    icon: Icons.home,
                    text: "Home",
                    color: Colors.black,
                    routeName: '/home',
                    selectedScreen: selectedScreen,
                  ),
                  _drawerItem(
                    icon: Icons.airplanemode_active_sharp,
                    text: "Report",
                    color: Colors.blueGrey,
                    routeName: '/report',
                    selectedScreen: selectedScreen,
                  ),
                ],
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  "Search and Rescue",
                  style: TextStyle(
                      color: Colors.grey[400], fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  _drawerItem(
                    icon: Icons.zoom_in_map,
                    text: "Search Area",
                    color: Colors.lightGreenAccent,
                    routeName: '/search-area',
                    selectedScreen: selectedScreen,
                  ),
                  _drawerItem(
                    icon: Icons.flight_land,
                    text: "Sweep Pattern",
                    color: Colors.grey,
                    routeName: '/sweep-pattern',
                    selectedScreen: selectedScreen,
                  ),
                  _drawerItem(
                    icon: Icons.bar_chart_outlined,
                    text: "Results",
                    color: Colors.deepOrangeAccent,
                    routeName: '/results',
                    selectedScreen: selectedScreen,
                  ),
                ],
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  "Extras",
                  style: TextStyle(
                      color: Colors.grey[400], fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  _drawerItem(
                    icon: Icons.warning_amber_outlined,
                    text: "Alerts",
                    color: Colors.red,
                    routeName: '/alerts',
                    selectedScreen: selectedScreen,
                  ),
                  _drawerItem(
                    icon: Icons.android,
                    color: Colors.green,
                    text: "About us",
                    routeName: '/about-us',
                    selectedScreen: selectedScreen,
                  ),
                ],
              ),
              SizedBox(height: 10),
              _drawerItem(
                icon: Icons.power_settings_new,
                color: Colors.red,
                text: "Log out",
                routeName: '/logout',
                selectedScreen: selectedScreen,
                isLogout: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String text,
    required Color color,
    required String routeName,
    required String selectedScreen,
    bool isLogout = false,
  }) {
    final bool isSelected = selectedScreen == routeName;

    return GestureDetector(
      onTap: () {
        if (isLogout) {
          _logout(context);
        } else {
          _navigateAndHighlight(context, routeName);
        }
      },
      child: Container(
        margin: EdgeInsets.only(left: 50, bottom: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.1) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 35,
              color: isSelected ? Colors.blue : color,
            ),
            SizedBox(width: 30),
            Text(
              text,
              style: TextStyle(
                fontSize: 22,
                color: isSelected ? Colors.blue : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateAndHighlight(BuildContext context, String routeName) {
    setState(() {
      selectedScreen = routeName;
    });

    Navigator.pushReplacementNamed(context, routeName);
  }

  void _logout(BuildContext context) async {
    Fluttertoast.showToast(
      msg: "Logout Successful",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
          (Route<dynamic> route) => false,
    );
  }
}
