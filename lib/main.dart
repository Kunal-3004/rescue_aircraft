import 'package:flutter/material.dart';
import 'package:rescue_aircraft/screens/forgot_password.dart';
import 'package:rescue_aircraft/screens/home.dart';
import 'package:rescue_aircraft/screens/login.dart';
import 'package:rescue_aircraft/screens/register.dart';
import 'package:rescue_aircraft/screens/report.dart';
import 'package:rescue_aircraft/screens/splashscreen.dart';
import 'package:rescue_aircraft/widgets/button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/home': (context) => Home(),
        '/report': (context) => Report(), // Ensure this matches '/report'
       // '/search-area': (context) => SearchAreaScreen(),
       // '/sweep-pattern': (context) => SweepPatternScreen(),
       // '/results': (context) => ResultsScreen(),
       // '/alerts': (context) => AlertsScreen(),
       // '/about-us': (context) => AboutUsScreen(),
       // '/logout': (context) => LoginScreen(),
      },
      home:SplashScreen(),
    );
  }
}