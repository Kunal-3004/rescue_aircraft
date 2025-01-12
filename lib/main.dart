import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rescue_aircraft/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:rescue_aircraft/shared/pages/splashscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:rescue_aircraft/features/auth/domain/repositories/auth_repository.dart';
import 'package:rescue_aircraft/features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'package:rescue_aircraft/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:rescue_aircraft/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:rescue_aircraft/features/auth/domain/usecases/sign_out_use_case.dart';

import 'core/network/api_client.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart' as auth_impl;
import 'features/auth/domain/usecases/get_current_user_use_case.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences for AuthLocalDataSource
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final authLocalDataSource = AuthLocalDataSource(prefs);

  // Initialize ApiClient (configure base URL, headers, etc.)
  final apiClient = ApiClient(client: http.Client());

  // Initialize the AuthRemoteDataSource
  final authRemoteDataSource = AuthRemoteDataSource(
    apiClient,
    authLocalDataSource,
  );

  // Create instances of repositories
  final authRepository = auth_impl.AuthRepositoryImpl(
    authRemoteDataSource,
    authLocalDataSource,
  );

  // Initialize use cases
  final signInUseCase = SignInUseCase(authRepository);
  final signUpUseCase = SignUpUseCase(authRepository);
  final checkAuthStatusUseCase = CheckAuthStatusUseCase(authRepository);
  final signOutUseCase = SignOutUseCase(authRepository);
  final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(
            signInUseCase: signInUseCase,
            signUpUseCase: signUpUseCase,
            checkAuthStatusUseCase: checkAuthStatusUseCase,
            signOutUseCase: signOutUseCase,
            getCurrentUserUseCase: getCurrentUserUseCase,
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rescue Aircraft',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}