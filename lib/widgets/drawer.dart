import 'package:flutter/material.dart';
import 'package:rescue_aircraft/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});


  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

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
  @override
  Widget build(BuildContext context) {
    return Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.only(top: 5,left: 5,right: 5),
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
                        child: GestureDetector(
                          onTap: (){
                            Navigator.popAndPushNamed(context, '/home');
                          },
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.popAndPushNamed(context, '/report');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.airplanemode_active_sharp,size: 35,color: Colors.grey[700],),
                              SizedBox(
                                width: 30,
                              ),
                              Text("Report",style: TextStyle(
                                fontSize: 22,color: Colors.black,
                              ),)
                            ],
                          ),
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
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.zoom_in_map,size: 35,color: Colors.lightGreen,),
                              SizedBox(
                                width: 30,
                              ),
                              Text("Search Area",style: TextStyle(
                                fontSize: 22,color: Colors.black,
                              ),)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.flight_land,size: 35,color: Colors.blueGrey,),
                              SizedBox(
                                width: 30,
                              ),
                              Text("Sweep Pattern",style: TextStyle(
                                fontSize: 22,color: Colors.black,
                              ),)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.bar_chart_outlined,size: 35,color: Colors.deepOrangeAccent,),
                              SizedBox(
                                width: 30,
                              ),
                              Text("Results",style: TextStyle(
                                fontSize: 22,color: Colors.black,
                              ),)
                            ],
                          ),
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
                        child: GestureDetector(
                          onTap: (){

                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.warning_amber_outlined,size: 35,color: Colors.red,),
                              SizedBox(
                                width: 30,
                              ),
                              Text("Alerts",style: TextStyle(
                                fontSize: 22,color: Colors.black,
                              ),)
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 50),
                        child: GestureDetector(
                          onTap: (){
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.android,size: 35,color: Colors.green,),
                              SizedBox(
                                width: 30,
                              ),
                              Text("About us",style: TextStyle(
                                fontSize: 22,color: Colors.black,
                              ),)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 50),
                child: GestureDetector(
                  onTap: (){
                    _logout(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.power_settings_new,size: 35,color: Colors.red,),
                      SizedBox(
                        width: 30,
                      ),
                      Text("Log out",style: TextStyle(
                        fontSize: 22,color: Colors.black,
                      ),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
  }
}
