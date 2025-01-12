import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:rescue_aircraft/core/usecases/empty_params.dart';
import 'package:rescue_aircraft/features/auth/domain/repositories/auth_repository.dart';
import 'package:rescue_aircraft/features/auth/domain/entities/user.dart';
import 'package:rescue_aircraft/core/errors/failures.dart';
import 'package:rescue_aircraft/features/auth/domain/usecases/check_auth_status_use_case.dart';
import 'package:rescue_aircraft/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:rescue_aircraft/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:rescue_aircraft/features/auth/domain/usecases/sign_out_use_case.dart';
import 'package:rescue_aircraft/features/auth/domain/usecases/sign_up_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final CheckAuthStatusUseCase _checkAuthStatusUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc(this._signInUseCase, this._signUpUseCase, this._checkAuthStatusUseCase, this._signOutUseCase, this._getCurrentUserUseCase, {
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required CheckAuthStatusUseCase checkAuthStatusUseCase,
    required SignOutUseCase signOutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<SignInButtonPressed>(_onSignInButtonPressed);
    on<SignUpButtonPressed>(_onSignUpButtonPressed);
    on<SignOutButtonPressed>(_onSignOutButtonPressed);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  void _onSignInButtonPressed(SignInButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _signInUseCase(SignInParams(email: event.email, password: event.password));

    result.fold(
          (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
          (user) => emit(Authenticated(user: user)),
    );
  }

  void _onSignUpButtonPressed(SignUpButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _signUpUseCase(SignUpParams(
        name: event.name,
        email: event.email,
        fullName: event.fullName,
        password: event.password));

    result.fold(
          (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
          (user) => emit(Authenticated(user: user)),
    );
  }

  void _onSignOutButtonPressed(SignOutButtonPressed event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _signOutUseCase(NoParams());
    result.fold(
          (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
          (_) => emit(Unauthenticated(message: 'Logged out')),
    );
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _checkAuthStatusUseCase();
    result.fold(
          (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
          (isAuthenticated) async {
        if (isAuthenticated) {
          final userResult = await _getCurrentUserUseCase(NoParams());
          userResult.fold(
                (failure) => emit(AuthError(message: _mapFailureToMessage(failure))),
                (user) => emit(Authenticated(user: user)),
          );
        } else {
          emit(Unauthenticated(message: 'Not authenticated'));
        }
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ValidationFailure) {
      return failure.message;
    } else if (failure is ServerFailure) {
      return failure.message;
    } else {
      return 'An unexpected error occurred';
    }
  }
}
