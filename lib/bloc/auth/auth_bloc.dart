// auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rescue_aircraft/models/new_user_model.dart';
import 'package:rescue_aircraft/repositories/auth_repo.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInButtonPressed>(_onSignInButtonPressed);
    on<SignUpButtonPressed>(_onSignUpButtonPressed);
    on<SignOutButtonPressed>(_onSignOutButtonPressed);
  }
  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {}

  Future<void> _onSignInButtonPressed(
    SignInButtonPressed event,
    Emitter<AuthState> emit,
  ) async {}

  Future<void> _onSignUpButtonPressed(
    SignUpButtonPressed event,
    Emitter<AuthState> emit,
  ) async {}

  Future<void> _onSignOutButtonPressed(
    SignOutButtonPressed event,
    Emitter<AuthState> emit,
  ) async {}
}
