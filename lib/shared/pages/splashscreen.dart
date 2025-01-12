import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue_aircraft/features/auth/presentation/pages/login.dart';
import 'package:rescue_aircraft/features/auth/presentation/pages/home.dart';
import 'package:rescue_aircraft/features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'package:rescue_aircraft/features/auth/presentation/bloc/auth_bloc.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/home/presentation/pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    // Dispatch the event to check the authentication status
    authBloc.add(CheckAuthStatus());

    // Listen for the state change to navigate
    authBloc.stream.listen((state) {
      if (state is Authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      } else if (state is Unauthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      }
    });
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
