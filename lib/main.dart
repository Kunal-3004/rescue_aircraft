import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:rescue_aircraft/bloc/auth/auth_bloc.dart';
import 'package:rescue_aircraft/providers/auth_provider.dart';
import 'package:rescue_aircraft/repositories/auth_repo.dart';
import 'package:rescue_aircraft/screens/login.dart';
import 'package:rescue_aircraft/screens/report.dart';
import 'package:rescue_aircraft/screens/home.dart';
import 'package:rescue_aircraft/services/auth_services.dart';
import 'package:rescue_aircraft/domain/user_register.dart';

void main() {
  final AuthRepository authRepository = AuthRepository();
  final RegisterUser registerUserUseCase =
      RegisterUser(authRepository: authRepository);

  runApp(MyApp(registerUserUseCase: registerUserUseCase));
}

class MyApp extends StatelessWidget {
  final RegisterUser registerUserUseCase;

  const MyApp({super.key, required this.registerUserUseCase});

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:(_)=>AuthBloc(
            authService: AuthService(),
            
          )
        )
      ], 
      child: 
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: '/',
        routes: {
          '/home': (context) => Home(),
          '/report': (context) => Report(),
        },
        home:Report(),
      ),
    
  }
}
