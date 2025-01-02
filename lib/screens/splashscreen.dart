import 'package:flutter/material.dart';
import 'package:rescue_aircraft/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences _sharedPreferences;

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    bool? isLoggedIn = _sharedPreferences.getBool('isLoggedIn');

    if (isLoggedIn==true) {
       Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } else {
       Navigator.push(context, MaterialPageRoute(builder: (context) => SignIn()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "images/splash.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: Text(
                "Search and Rescue Missing Aircraft",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.white.withOpacity(0.7),
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
