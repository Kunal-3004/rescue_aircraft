// temp_event.dart
part of 'temp_bloc.dart';

@immutable
sealed class TempEvent extends Equatable {
  const TempEvent();

  @override
  List<Object> get props => [];
}

//^ All Events are defined as classes that extend TempEvent and are immutable.

final class UpdateTemperature extends TempEvent {
  final double temperature;

  const UpdateTemperature({required this.temperature});

  @override
  List<Object> get props => [temperature];
}

final class ResetTemperature extends TempEvent {
  const ResetTemperature();
}
