// temp_state.dart
part of 'temp_bloc.dart';

//!Sealed classes
@immutable
sealed class TempState extends Equatable {
  const TempState();

  @override
  List<Object> get props => [];
}

//!

//^Loading initial
final class TempInitial extends TempState {
  const TempInitial();
}

//^ Loading state to show loading
final class TempLoading extends TempState {
  const TempLoading();
}

//^ Loaded state to show loaded
final class TempLoaded extends TempState {
  final double temperature;

  const TempLoaded({required this.temperature});

  //&  All the properties that are used in the class should be added in the props
  @override
  List<Object> get props => [temperature];
}

//^ Error state to show error
final class TempError extends TempState {
  final String message;

  const TempError({required this.message});

  @override
  List<Object> get props => [message];
}
