part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

// For signing in
final class SignInButtonPressed extends AuthEvent {
  final String email;
  final String password;

  const SignInButtonPressed({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

// For signing up
final class SignUpButtonPressed extends AuthEvent {
  final String name;
  final String email;
  final String fullName;
  final String password;

  const SignUpButtonPressed({
    required this.name,
    required this.email,
    required this.fullName,
    required this.password,
  });

  @override
  List<Object> get props => [name, email,fullName, password];
}

// For signing out
final class SignOutButtonPressed extends AuthEvent {}

// For checking if user is already authenticated
final class CheckAuthStatus extends AuthEvent {}
